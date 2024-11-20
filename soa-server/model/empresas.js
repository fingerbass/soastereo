var moment        = require('moment')
  , api           = require('../api/index')
  , _             = require('lodash')
  , jwt           = require('jsonwebtoken')
  , config        = require('../util/config')
  , async         = require('async')
  , path          = require('path')
  , moment        = require('moment')
  // , procesosModel = require('./procesos')
  , general       = require('../util/general')
  , Excel         = require('exceljs')
  , mail          = require('../util/mail')
  , nodemailer    = require('nodemailer')
	;

  const uuid = require('uuid');

// MANTENIMIENTO DE EMPRESAS
var empresasLista = function(req, res) {
  var usuarioLogueado   = req.decoded ? req.decoded.usuario : 'undefined'
  var empresa           = req.query.empresa           || 'mastermind'
  var idestado          = req.query.idestado          || 2
  var sortByName        = req.query.sortByName        || 'idempresa'
  var sortByType        = req.query.sortByType        || 'ASC'
  var ultimoRecnum      = req.query.ultimoRecnum      || 0
  var cantidadRegistros = req.query.limit
  var pagination        = req.query.pagination        || 1
  var textSearch        = req.query.textSearch
  var isExcel           = false

  var query      = ` EXEC USP_adm_empresas_lista @idestado`

	var parameters = {}
	var isWhere    = false
	var aux        = ''
	var where      = []

	parameters.idestado = +idestado

  var response = {
    status : 0
  }

  // console.log('empresa:>>> ', empresa)
  // console.log('query:>>> ', query)
  // console.log('parameters:>>> ', parameters)

	api.sql.adm_empresas.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
		if (err) {
			res.send({ status: 0, message: err.message})
			return
		}

    console.log('lista:>>> ', lista)

    if (lista.length < cantidadRegistros) response.noMore = true
    else {
      if (ultimoRecnum === lista[lista.length -1].ultimoRecnum) response.noMore = true
      else response.ultimoRecnum = +ultimoRecnum + +cantidadRegistros
    }

    for (let i = 0; i < lista.length; i++) {
      if (lista[i].logo) {
        lista[i].logo = lista[i].logo.toString()
      }
      if (lista[i].isotipo) {
        lista[i].isotipo = lista[i].isotipo.toString()
      }
    }

    let mockList = lista
    if (sortByName === '-idempresa') {
      mockList = mockList.reverse()
    }

    var pageList = []
    if (cantidadRegistros) {
      pageList = mockList.filter((item, index) => index < cantidadRegistros * pagination && index >= cantidadRegistros * (pagination - 1))
    }
    // console.log('pageList:>>> ', pageList)

    response.status   = 1
    response.cantidad = cantidad
    response.lista    = cantidadRegistros ? pageList : lista
    res.send(response)
		
	})
}

var empresasMantenimiento = function(req, res) {
  var usuarioLogueado   = req.decoded ? req.decoded.usuario : 'undefined'
  var username          = req.body.username                  || 'mastermind'
  var empresa           = req.body.empresa                   || 'mastermind'
  var idestado          = req.body.idestado                  || 2
  var arreglo           = req.body.arreglo            || []
  var tipoaccion        = req.body.tipoaccion                || []
  var sortByName        = req.body.sortByName                || 'idempresa'
  var sortByType        = req.body.sortByType                || 'ASC'
  var ultimoRecnum      = req.body.ultimoRecnum              || 0
  var cantidadRegistros = req.body.limit || 50
  var pagination        = req.body.pagination                || 1
  var textSearch        = req.body.textSearch
  var isExcel           = false

  var response = {
    status : 0
  }

  if (tipoaccion === 1 || tipoaccion === 2) {

    var obj = {
      tipo           : +tipoaccion,
      idempresa      : arreglo.idempresa,
      nombre         : arreglo.nombre,
      ruc            : arreglo.ruc,
      direccion      : arreglo.direccion,
      distrito       : arreglo.distrito,
      ciudad         : arreglo.ciudad,
      telefono       : arreglo.telefono,
      email          : arreglo.email,
      activo         : arreglo.activo,
      logo           : arreglo.logo,
      isotipo        : arreglo.isotipo,
      usuarioregistro: arreglo.usuarioregistro  || username,
      fecharegistro  : arreglo.fecharegistro
    }
  
    console.log('obj:>>> ', obj)

    var query      = ` EXEC USP_adm_empresas_mantenimiento @tipo, @idempresa, @nombre, @ruc, @direccion, @distrito, @ciudad, @telefono, @email, @activo, @logo, @isotipo, @usuarioregistro`
    var parameters = {}
    var isWhere    = false
    var aux        = ''
    var where      = []
  
    parameters.tipo            = obj.tipo
    parameters.idempresa       = obj.idempresa
    parameters.nombre          = obj.nombre
    parameters.ruc             = obj.ruc
    parameters.direccion       = obj.direccion
    parameters.distrito        = obj.distrito
    parameters.ciudad          = obj.ciudad
    parameters.telefono        = obj.telefono
    parameters.email           = obj.email
    parameters.activo          = obj.activo
    parameters.logo            = Buffer.from(obj.logo || '', 'utf8')
    parameters.isotipo         = Buffer.from(obj.isotipo || '', 'utf8')
    parameters.usuarioregistro = obj.usuarioregistro

    console.log('parameters:>>> ', parameters)

    api.sql.adm_empresas.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
      if (err) {
        res.send({ status: 0, message: err.message})
        return
      }

      response.status   = 1
      response.cantidad = cantidad
      response.lista    = lista
      res.send(response)
    })

  } else if (tipoaccion === 3) {
    async.eachSeries(arreglo, function(empresas, cb) {
      api.sql.adm_empresas.getOne(empresa, empresas.idempresa, function(err, found, empresaEncontrado) {
        if (err) cb(err)
        else {
          if (empresaEncontrado && empresaEncontrado.idempresa) {
            var query             = ` EXEC USP_adm_empresas_mantenimiento @tipo, @idempresa `
            var parameters        = {}
            parameters.tipo       = tipoaccion
            parameters.idempresa  = empresaEncontrado.idempresa        
            // console.log('parameters:>>> ', parameters)
            api.sql.adm_empresas.builtGet(empresa, query, parameters, function(error, cantidad, lista) {
              if (err) cb(err)
              else {
                cb()
              }
            })
          }
        }
      })
    }, function (err) {
      if (err) {
        console.error('err.message', err.message)
        response.message = err.message
        res.send(response)
      } else {
        response.status = 1
        res.send(response)
      }
    })
  } else {
    res.send({ status: 0, message: 'Seleccione el tipo de accion correspondiente.'})
    return
  }
}

// var empresasUUID = function(req, res) {
//   var usuarioLogueado   = req.decoded ? req.decoded.usuario : 'undefined'
//   var username          = req.body.username                  || 'mastermind'
//   var empresa           = req.body.empresa                   || 'mastermind'
//   var idestado          = req.body.idestado                  || 2
//   var arreglo           = req.body.arreglo                   || []
//   var tipoaccion        = req.body.tipoaccion                || []
//   var sortByName        = req.body.sortByName                || 'idempresa'
//   var sortByType        = req.body.sortByType                || 'ASC'
//   var ultimoRecnum      = req.body.ultimoRecnum              || 0
//   var cantidadRegistros = req.body.limit || 50
//   var pagination        = req.body.pagination                || 1
//   var textSearch        = req.body.textSearch
//   var isExcel           = false

//   var response = {
//     status : 0
//   }

//   var uuid = handlerGenerarUUID('mastermind')

//   response.status = 1
//   response.uuid   = uuid
//   res.send(response)
// }

// handlerGenerarUUID = function(idempresa) {
//   // console.log('uuid.v4():>>> ', uuid.v4());
//   const namespace = uuid.parse(uuid.v4())
//   const name      = idempresa
//   var   uuidAux   = uuid.v5(name, namespace)
//   console.log('uuidAux:>>> ', uuidAux)
//   // callback(uuid)
//   return uuidAux
// }

// var empresasUploadPlantillaCargaMasiva = function(req, res) {
//   var usuarioLogueado   = req.decoded ? req.decoded.usuario : 'undefined'
//   var usuario          = req.body.username                  || 'mastermind'
//   var empresa           = req.body.empresa                   || 'mastermind'
//   var empresa           = req.body.empresa
//   var fileSubido        = req.body.fileSubido
//   var idestado          = req.body.idestado                  || 2
//   var arreglo           = req.body.arreglo                   || []
//   var tipoaccion        = req.body.tipoaccion                || []
//   var sortByName        = req.body.sortByName                || 'idempresa'
//   var sortByType        = req.body.sortByType                || 'ASC'
//   var ultimoRecnum      = req.body.ultimoRecnum              || 0
//   var cantidadRegistros = req.body.limit || 50
//   var pagination        = req.body.pagination                || 1
//   var textSearch        = req.body.textSearch
//   var isExcel           = false

//   general.infoLog(empresa, {metodo: 'empresas.empresasUploadPlantillaCargaMasiva', usuario: usuario})

//   var response = {
//     status : 0
//   }

//   var filename = path.join(process.cwd(), fileSubido);

//   handlerPlantillaEmpresas(empresa, usuario, filename, 'guardar', function(err, observaciones) {
//     if (err) {
//       response.message = err.message
//       res.send(response)
//       return
//     }

//     console.log('observaciones: >>> ', observaciones)

//     response.status        = 1
//     response.observaciones = observaciones
//     res.send(response)
//     return
//   })

// }


// var handlerPlantillaEmpresas = function(empresa, usuario, filename, accion, callback) {
// 	var observations   = []
// 	var empresas       = []
// 	var app            = 'mastermind'
// 	// var segundaEmpresa = ''

// 	// if (empresa === 'datacont') segundaEmpresa = 'reprodata'
// 	// else segundaEmpresa = 'datacont'

// 	// Esta procesando
// 	// Aca creamos el proceso
// 	var idProceso = procesosModel.crear(empresa, usuario, app, 'void', 'Carga de excel de empresas')
// 	callback(null, null)

//   // console.log('filename handleeeeeeeer :', filename)
//   // read from a file
//   var workbook = new Excel.Workbook();
//   workbook.xlsx.readFile(filename).then(function() {
//     // use workbook
//     // var worksheet = workbook.getWorksheet(1);
//     var worksheet     = workbook.worksheets[0];
//     var headersPrecio = [
//       // 'nombre', 'ruc', 'direccion', 'distrito', 'ciudad', 'telefono', 'email', 'activo', 'logo', 'isotipo', 'usuarioregistro', 'fecharegistro'
//       'nombre', 'ruc', 'direccion', 'distrito', 'ciudad', 'telefono', 'email', 'activo', 'logo', 'isotipo', 'usuarioregistro'
//     ]

//     worksheet.eachRow(function(row, rowNumber) {
//       console.log('rowNumber :', rowNumber)
//       if (rowNumber === 1) {

//         // Aqui estan los encabezados
//         for (var i = 1; i < row.values.length; i++) {
//           var element = row.values[i];
//           var header  = headersPrecio[i]
//           if (element !== header) {
//             var texto = 'El dato de cabecera "' + element + '" deberia ser "' + header + '"'
//             observations.push(texto);
//           }
//         }

//       } else {
//         var aux = {
// 					nombre          : row.values[1] + ''  || '',
// 					ruc             : row.values[2] + ''  || '',
// 					direccion       : row.values[3] + ''  || '',
// 					distrito        : row.values[4] + ''  || '',
// 					ciudad          : row.values[5] + ''  || '',
// 					telefono        : row.values[6] + ''  || '',
// 					email           : row.values[7] + ''  || '',
// 					activo          : row.values[8] + ''  || '',
// 					logo            : row.values[9] + ''  || '',
// 					isotipo         : row.values[10] + '' || '',
// 					usuarioregistro : row.values[11] + '' || '',
// 					// fecharegistro   : row.values[12] + '' || '',
// 					rowNumber       : rowNumber
//         }

//         // console.log('aux :', aux)
//         // console.log('row.values[5] :', row.values[5])
//         empresas.push(aux)
//       }
//     });

//     var contador = 0
//     // Aca viene el proceso de actualizacion con async
//     console.log('empresas.length ================================= :', empresas.length)
//     console.log('empresas:>>> ', empresas)
//     console.log('empresas.length ================================= :', empresas.length)

//     if (empresas.length === 0) {
//     	var mensaje = 'No hay ningun dato ingresado en la plantilla.'
//     	observations.push(mensaje)
//     }

// 		var arrayErrores 	= []
// 		var texto 				= []
//     procesosModel.actualizar(empresa, usuario, app, idProceso, {total : empresas.length})

//     async.eachSeries(empresas, function(a, cb) {
//       console.log('empresa:>>> ', a)
//       // console.log('contador:', contador)
//     	procesosModel.actualizar(empresa, usuario, app, idProceso, {counter : contador})
//       // ++contador
// 			// contador = 0
//       handlerValidarRegistroEmpresa(empresa, usuario, a, true, a.rowNumber, function(err, arregloErrores) {
// 				// ++contador
//         if (err) {
// 					cb(err)
// 				} else {
//           if (arregloErrores && arregloErrores.length > 0) {
// 						for (var i = 0; i < arregloErrores.length; i++) {
// 							arrayErrores.push(arregloErrores[i])
// 						}
// 						cb()
//           } else {
// 						++contador
// 						procesosModel.actualizar(empresa, usuario, app, idProceso, {counter : contador})
// 						// ++contador

// 		      	var objUpdate = {}
// 		      	if  (a.nombre && a.nombre !== 'undefined') objUpdate.nombre = a.nombre
// 		      	if  (a.ruc && a.ruc !== 'undefined') objUpdate.ruc = a.ruc
// 		      	if  (a.direccion && a.direccion !== 'undefined') objUpdate.direccion = a.direccion
// 		      	if  (a.distrito && a.distrito !== 'undefined') objUpdate.distrito = a.distrito
// 		      	if  (a.ciudad && a.ciudad !== 'undefined') objUpdate.ciudad = a.ciudad
// 		      	if  (a.telefono && a.telefono !== 'undefined') objUpdate.telefono = a.telefono
// 		      	if  (a.email && a.email !== 'undefined') objUpdate.email = a.email
// 		      	if  (a.activo && a.activo !== 'undefined') objUpdate.activo = a.activo
// 		      	if  (a.logo && a.logo !== 'undefined') objUpdate.logo = a.logo
// 		      	if  (a.isotipo && a.isotipo !== 'undefined') objUpdate.isotipo = a.isotipo
// 		      	if  (a.usuarioregistro && a.usuarioregistro !== 'undefined') objUpdate.usuarioregistro = a.usuarioregistro
// 						// console.log('objUpdate :>> ', objUpdate);

//             var query      = ` EXEC USP_adm_empresas_mantenimiento @tipo, @idempresa, @nombre, @ruc, @direccion, @distrito, @ciudad, @telefono, @email, @activo, @logo, @isotipo, @usuarioregistro`
//             var parameters = {}
          
//             parameters.tipo            = 1
//             parameters.idempresa       = null
//             parameters.nombre          = objUpdate.nombre     || ''
//             parameters.ruc             = objUpdate.ruc        || ''
//             parameters.direccion       = objUpdate.direccion  || ''
//             parameters.distrito        = objUpdate.distrito   || ''
//             parameters.ciudad          = objUpdate.ciudad     || ''
//             parameters.telefono        = objUpdate.telefono   || ''
//             parameters.email           = objUpdate.email      || ''
//             parameters.activo          = objUpdate.activo === 'VERDADERO' ? 1 : 'FALSO' ? 0 : 1
//             parameters.logo            = Buffer.from(objUpdate.logo || '', 'utf8')
//             parameters.isotipo         = Buffer.from(objUpdate.isotipo || '', 'utf8')
//             parameters.usuarioregistro = usuario
        
//             console.log('parameters:>>> ', parameters)
        
//             api.sql.adm_empresas.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
//               if (err) {
//                 var mensajeError = `La empresa ${a.ruc} tiene el error ${err} en la empresa ${empresa} en la linea ${a.rowNumber}.`
// 								var objAux       = {
// 									ruc      : a.ruc,
// 									empresa  : empresa,
// 									rowNumber: a.rowNumber,
// 									mensaje  : mensajeError
// 								}
// 								arrayErrores.push(objAux)
// 								cb()
//               } else {
//                 cb()
// 								// api.octo.articulo.updateArticulo(segundaEmpresa, usuario, a.ruc, segundaEmpresa, objUpdate, function (err, data) {
// 								// 	// ++contador
// 								// 	if (err) {
// 								// 		var mensajeError = `La empresa ${a.ruc} tiene el error ${err} en la empresa ${segundaEmpresa} en la linea ${a.rowNumber}.`
// 								// 		var objAux = {
// 								// 			ruc      : a.ruc,
// 								// 			empresa  : segundaEmpresa,
// 								// 			rowNumber: a.rowNumber,
// 								// 			mensaje  : mensajeError
// 								// 		}
// 								// 		arrayErrores.push(objAux)
// 								// 		cb()
// 								// 	} else {
// 								// 		cb()
// 								// 	}
// 								// })
//               }
//             })
// 	        }
// 	      }
// 	    })
//     }, function(err) {
//       if (err) {
//       	procesosModel.terminar(empresa, usuario, app, idProceso, {error: true, message: err.message})
//       } else {
//         console.log('arrayErrores:>>> ', arrayErrores)
// 				if 				(arrayErrores && arrayErrores.length < 1) {
// 					for (var i = 0; i < arrayErrores.length; i++) {
// 						procesosModel.actualizar(empresa, usuario, config.app, idProceso, {registro : arrayErrores[i].mensaje, counter : contador})
// 					}
// 					procesosModel.terminar(empresa, usuario, app, idProceso, {})
// 				} else if (arrayErrores && arrayErrores.length >= 1) {
// 					texto = 'Se encontraron errores al cargar el excel, se envió un correo indicando los errores.'

// 					procesosModel.terminar(empresa, usuario, config.app, idProceso, {error: true, message: texto})
// 					generarPDFExcelErroresEmpresas(empresa, usuario, arrayErrores, function (err, filenameOutput, reportName) {
// 						if (err) console.error(err)
// 						var fecha    = moment().format('DD_MM_YYYY_HHmm')
// 						var objEmail = {
// 							usuario         : usuario,
// 							template        : 'notificacion_errores_importar_plantilla_excel',
// 							subject         : `Errores al importar las empresas de excel`,
// 							to              : `${usuario}@${config[empresa].dominio}`,
// 							prefix          : '[MASTERMIND]',
// 							from            : 'notificacion de errores al importar articulos',
// 							empresaOrigen   : empresa,
// 							texto           : 'Se encontraron errores al subir la plantilla de empresas, porfavor revisar el adjunto para visualizar los errores.',
// 							esAttachment    : 1,
// 							tipoAttachment  : 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
// 							rutaAttachment  : reportName,
// 							nombreAttachment: filenameOutput
// 							// nombreAttachment: `maestro_empresas_errores_${fecha}.xlsx`
// 						}
// 						console.log('objEmail:>>> ', objEmail)
					
// 						sendEmailNotificacionImportarEmpresas(empresa, usuario, objEmail, function (err) {
// 							if (err) console.error('Error al enviar correo:', err)
// 						})
// 						// sendEmailNotificacionImportarExcelEmpresas(empresa, usuario, objEmail, function (err) {
// 						// 	if (err) console.error('Error al enviar correo:', err)
// 						// })
// 					})

// 				} else {
// 					procesosModel.terminar(empresa, usuario, app, idProceso, {})
// 				}
//       }
//     })
//   });
// }

// var handlerValidarRegistroEmpresa = function(empresaOrigen, usuario, empresa, isExcel, rowNumber, callback) {
// 	var observaciones  = []

// 	if (!empresa.nombre) {
// 		var mensaje = `Debe ingresar un nombre de empresa en la linea ${rowNumber}.`
// 		var objAux = {
// 			nombre   : '',
// 			// empresa  : empresaOrigen,
// 			rowNumber: rowNumber,
// 			mensaje  : mensaje
// 		}
// 		observaciones.push(objAux)
// 	} else if (empresa.codigo === '') {
//     var mensaje = `El nombre de empresa no puede ser vacio en la linea ${rowNumber}.`
//     var objAux = {
//       nombre   : '',
//       // empresa  : empresaOrigen,
//       rowNumber: rowNumber,
//       mensaje  : mensaje
//     }
//     observaciones.push(objAux)
// 	} else if (empresa.nombre === 'undefined') {
//     var mensaje = `El nombre de empresa no puede ser vacio en la linea ${rowNumber}.`
//     var objAux = {
//       nombre   : '',
//       // empresa  : empresaOrigen,
//       rowNumber: rowNumber,
//       mensaje  : mensaje
//     }
//     observaciones.push(objAux)
// 	}

// 	// if (empresa.tipoVenta && empresa.tipoVenta !== 'undefined' && empresa.tipoVenta !== '') {
// 	// 	if (empresa.tipoVenta !== 'V' && empresa.tipoVenta !== 'O') {
// 	// 		var mensaje = `El tipo de venta no puede ser diferente a V y O en la linea ${rowNumber}.`
// 	// 		var objAux = {
// 	// 			codigoempresa: '',
// 	// 			empresa       : '',
// 	// 			rowNumber     : rowNumber,
// 	// 			mensaje       : mensaje
// 	// 		}
// 	// 		observaciones.push(objAux)
// 	// 	}
// 	// }

// 	var obj = {
// 		ruc: empresa.ruc
// 	}
//   console.log('obj:>>> ', obj)
  
// 	api.sql.adm_empresas.getOneEmpresa(empresaOrigen, obj, function(err, cantidad, empresaEncontrado) {
//     console.log('cantidad:>>> ', cantidad)
//     console.log('empresaEncontrado:>>> ', empresaEncontrado)
//     if (err) {
//       callback(err)
//     } else {
//       if (empresaEncontrado && empresaEncontrado.length > 0) {
//         var mensaje = `La empresa con codigo ${empresa.ruc} se encuentra registrado en la empresa ${empresaEncontrado[0].nombre} en la linea ${rowNumber}.`
// 				var objAux = {
// 					ruc      : empresa.ruc,
// 					// empresa  : empresaOrigen,
// 					rowNumber: rowNumber,
// 					mensaje  : mensaje
// 				}
// 				observaciones.push(objAux)
//       }
// 			// if (cantidad === 0) {
// 			// 	var mensaje = `La empresa con codigo ${empresa.ruc} no se encuentra registrado en la empresa ${empresa.nombre} en la linea ${rowNumber}.`
// 			// 	var objAux = {
// 			// 		ruc      : empresa.ruc,
// 			// 		// empresa  : empresaOrigen,
// 			// 		rowNumber: rowNumber,
// 			// 		mensaje  : mensaje
// 			// 	}
// 			// 	observaciones.push(objAux)
// 			// } else {
// 			// 	// empresaEncontrado = empresaEncontrado[0]
//       //   if (empresaEncontrado && empresaEncontrado.length !== 0) {
//       //     var empresaPrimeraEmpresaFound = _.find(empresaEncontrado, function (o) { return o.ruc === empresa.ruc})
//       //     // console.log('empresaEncontrado empresa:', empresaEncontrado)

//       //     // if (empresa.ruc !== empresaEncontrado.codigoNuevo) {
//       //     if (!empresaPrimeraEmpresaFound) {
//       //       var mensaje = `La empresa con código ${empresa.ruc} no se encuentra registrado en la empresa ${empresa.nombre} en la linea ${rowNumber}.`
//       //       var objAux = {
//       //         ruc      : empresa.ruc,
//       //         // empresa  : empresaOrigen,
//       //         rowNumber: rowNumber,
//       //         mensaje  : mensaje
//       //       }
//       //       observaciones.push(objAux)
//       //     }
//       //   }
// 			// }
//       // console.log('observaciones: ', observaciones)
//       callback(null, observaciones)
// 		}
// 	})

// }

// var generarPDFExcelErroresEmpresas = function (empresa, usuario, arrayErrores, callback) {

//   // arrayErrores.shift()
  
// 	var workbook  = new Excel.Workbook();
//   var sheet     = workbook.addWorksheet("Errores de Importacion de Empresas");
//   var worksheet = workbook.getWorksheet(1);

//   var columns = [
//     { header: 'Codigo', 	key: 'ruc', 	width: 40, style: { font: { name: 'Calibri' } } },
//     // { header: 'Empresa', 					key: 'empresa', 				width: 40, style: { font: { name: 'Calibri' } } },
//     { header: 'Nro de Fila',		  key: 'rowNumber', 			width: 40, style: { font: { name: 'Calibri' } } },
//     { header: 'Mensaje', 					key: 'mensaje', 				width: 150, style: { font: { name: 'Calibri' } } }
//   ];

//   worksheet.columns = columns;

//   // Agrego algunos estilos
//   var borders   = { top: { style: "thin" }, left: { style: "thin" }, bottom: { style: "thin" }, right: { style: "thin" } };
//   var alignment = { horizontal: 'center' };
//   var font      = { bold: true };

//   var firstRow = worksheet.getRow(1);

//   for (var i = 0; i < columns.length; i++) {
//     firstRow.getCell(i + 1).border    = borders;
//     firstRow.getCell(i + 1).alignment = alignment;
//     firstRow.getCell(i + 1).font      = font;
//   }

// 	// console.log('arrayErrores: ', arrayErrores)
//   var i = 0
// 	for (i in arrayErrores) {
// 		// var objAux = { element : arrayErrores[i] }
// 		// worksheet.addRow(objAux)
// 		worksheet.addRow(arrayErrores[i])
// 	}

// 	var filenameOutput = 'documento_errores_' + usuario + '_' + moment().format('YYYYMMDDHHmmss') + '.xlsx'
// 	var filename       = path.join(process.cwd(), 'app_archivos', filenameOutput)
// 	var pathOutput     = config.apiRoute + '/app_archivos/' + filenameOutput

//   console.log('filenameOutput:>>> ', filenameOutput)
//   console.log('filename:>>> ', filenameOutput, filename)
// 	workbook.xlsx.writeFile(filename)
// 		.then(function() {
// 			callback(null, filenameOutput, filename)
// 		}).catch(function(err){
// 			console.log('err.message:', err.message)
// 			callback(err.message, null)
// 			return
// 		})


// }

// var sendEmailNotificacionImportarExcelEmpresas = function(empresa, usuario, obj, callback) {
//   var mailObj = {
//       template					: obj.template,
//       subject 					: obj.subject,
//       data    					: obj,
//       to      					: obj.to,
//       cc      					: obj.cc,
//       bcc     					: '',
//       prefix  					: '[MASTERMIND]',
// 			esAttachment     	: obj.esAttachment,
// 			tipoAttachment   	: obj.tipoAttachment,
// 			rutaAttachment   	: obj.rutaAttachment,
// 			nombreAttachment	: obj.nombreAttachment
//   }

//   mail.sendAttachmentExcel(empresa, mailObj, function (err) {
//     if (err) {
//       console.error('Error al enviar mail de sendAttachmentExcel:', err)
//       callback(err)
//     } else {
//       callback(null)
//     }
//   })
// }

// var sendEmailNotificacionImportarEmpresas = function(empresa, usuario, obj, callback) {
//   // console.log('obj:>>> ', obj)
//   // return
//   var plataforma_link_aqui = '<bold><a href="https://localhost:8063/#/login">Aqui</a></bold>'
//   var logoAux              = 'logo_mastermind.png'
//   var logotipo             = ''
//   if  (empresa) logotipo   = path.join(process.cwd(),'logo', logoAux)
//   var archivo              = ''
//   if  (empresa) archivo    = path.join(process.cwd(),'temporal', obj.nombreAttachment)


//   // ENVIO DE EMAIL
//   var html = `
//     <table border="0" cellspacing="0" cellpadding="0" width="100%" style="width:100.0%; background:#DFE5E9;">
//       <tbody>
//         <tr>
//           <td style="padding:0cm 0cm 0cm 0cm;height:37.5pt"></td>
//         </tr>
//         <tr>
//           <td style="padding:0cm 0cm 0cm 0cm">
//             <table border="0" cellpadding="0" width="100%" style="width:100.0%;">
//               <tbody>
//                 <tr>
//                   <td style="padding:.75pt .75pt .75pt .75pt"></td>
//                   <td width="468" style="width:351.0pt; padding:37.5pt 49.5pt 24.0pt 49.5pt; background:white;">
//                 <table border="0" cellspacing="0" cellpadding="0" width="100%" style="width:100.0%; word-wrap: break-word">
//                   <tbody>
//                     <tr>
//                       <td style="background: #000e36; padding: 0cm; height: 45pt; text-align: center;">
//                         <img src="cid:unique@openjavascript.info" width="200" alt="MasterMind" />
//                       </td>
//                     </tr>
//                     <tr>
//                       <td style="padding:0cm 0cm 18.75pt 0cm"><p><br /></p><p>Hola, ${usuario}:
//                         <br />
//                         <br />
//                         Hemos mandado los errores de la importación de empresas.
//                         <br />
//                         <br />
//                         <p>
//                         </p><p>Atentamente,</p><p> Plataforma MasterMind
//                         <br /></p><p><br />
//                         <span style="font-size: 10pt;"><span style="color: #ff0000;">Por favor no responder a este email. El buzón que generó este correo electrónico no se supervisa en busca de respuestas.</span></span>
//                         <br />
//                         <br />
//                         <br />
//                         <br />
//                         <br />
//                                   </p></td>
//                               </tr>
//                           </tbody></table>
//                       </td>
//                       <td style="padding:.75pt .75pt .75pt .75pt"></td>
//                   </tr>
//             </tbody>
//           </table>
//         </td>
//       </tr>
//       <tr>
//         <td style="padding:0cm 0cm 0cm 0cm">
//           <table border="0" cellspacing="0" cellpadding="0" width="100%" style="width:100.0%">
//             <tbody>
//               <tr>
//               <!-- <td style='padding:12.0pt 0cm 0cm 0cm'> -->
//                  <td>
//                     <p align="center" style="text-align:center">
//                       <span style="font-size:9.0pt">
//                         © PATROL INNOVATIONS S.A.C. 2023. Todos los derechos reservados.
//                       </span>
//                     </p>
//                   </td>
//                 </tr>
//               <tr>
//                 <td style="padding:0cm 0cm 0cm 0cm;height:22.5pt"></td>
//               </tr>
//             </tbody>
//           </table>
//         </td>
//       </tr>
//     </tbody>
//     </table>
// `
//   const transporter = nodemailer.createTransport({
//     host  : 'mail.patrol.com.pe',
//     port  : 465,                  // 143, 110
//     secure: true,
//     auth  : {
//       user: 'mastermind@patrol.com.pe',
//       pass: 'Pa130923%'
//     }
//   })

//   const info = transporter.sendMail({
//     from       : 'Soporte <desarrollador@patrol.com.pe>',
//     to         : 'desarrollador@patrol.com.pe',
//     subject    : obj.subject,
//     html       : html,
//     attachments: [
//       {
//         filename: logoAux,
//         path    : `./logo/${logoAux}`,
//         cid     : 'unique@openjavascript.info'
//       },
//       {
//         filename: obj.nombreAttachment,
//         path    : `./temporal/${obj.nombreAttachment}`,
//         cid     : 'unique@openjavascript.info'
//       }
//     ]
//   })
//   console.log('info:>>> ', info)
//   console.log("Mensaje enviado: " + info.messageId)
//   console.log("accepted enviado: " + info.accepted)
//   console.log("rejected enviado: " + info.rejected)
//   console.log('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>')
//   callback(null, null)
// }


exports.empresasLista                      = empresasLista
exports.empresasMantenimiento              = empresasMantenimiento
// exports.empresasUUID                       = empresasUUID
// exports.empresasUploadPlantillaCargaMasiva = empresasUploadPlantillaCargaMasiva