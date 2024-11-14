var moment = require('moment')
  , api    = require('../api/index')
  , _      = require('lodash')
  , jwt    = require('jsonwebtoken')
  , config = require('../util/config')
  , async  = require('async')
	;

// MANTENIMIENTO DE TIPO PERSONAL
var usuariosempresaLista = function(req, res) {
  var usuarioLogueado   = req.decoded ? req.decoded.usuario : 'undefined'
  var empresa           = req.query.empresa           || 'soa'
  var idestado          = req.query.idestado          || 2
  var sortByName        = req.query.sortByName        || 'idusuarioempresa'
  var sortByType        = req.query.sortByType        || 'ASC'
  var ultimoRecnum      = req.query.ultimoRecnum      || 0
  var cantidadRegistros = req.query.limit
  var pagination        = req.query.pagination        || 1
  var textSearch        = req.query.textSearch
  var isExcel           = false

  var query      = ` EXEC USP_seg_usuarios_empresa_lista`

	var parameters = {}
	var isWhere    = false
	var aux        = ''
	var where      = []

  var response = {
    status : 0
  }

  // console.log('empresa:>>> ', empresa)
  // console.log('query:>>> ', query)
  // console.log('parameters:>>> ', parameters)

	api.sql.seg_usuarios_empresa.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
		if (err) {
			res.send({ status: 0, message: err.message})
			return
		}

    let mockList = lista
  
    if (sortByName === '-idusuarioempresa') {
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

var usuariosempresaListaIdEmpresa = function(req, res) {
  var usuarioLogueado   = req.decoded ? req.decoded.usuario : 'undefined'
  var empresa           = req.query.empresa           || 'soa'
  var idestado          = req.query.idestado          || 2
  var idempresa         = req.query.idempresa
  var sortByName        = req.query.sortByName        || 'idempresa'
  var sortByType        = req.query.sortByType        || 'ASC'
  var ultimoRecnum      = req.query.ultimoRecnum      || 0
  var cantidadRegistros = req.query.limit
  var pagination        = req.query.pagination        || 1
  var textSearch        = req.query.textSearch
  var isExcel           = false
    
  var query           = ` EXEC USP_seg_usuarios_empresa_lista_idempresa @idempresa `
  var parameters      = {}
  var isWhere         = false
  var aux             = ''
  var where           = []
  var arregloAuxiliar = []
   
   var response = {
     status : 0
   }
 
   parameters.idempresa = idempresa
 
  //  console.log('empresa:>>> ', empresa)
  //  console.log('query:>>> ', query)
  //  console.log('parameters:>>> ', parameters)
 
   api.sql.seg_usuarios.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
    if (err) {
			res.send({ status: 0, message: err.message})
			return
		}
 
    if (lista && lista.length > 0) {
      for (let i = 0; i < lista.length; i++) {
        if (lista[i].logo) {
          lista[i].logo = lista[i].logo.toString()
        }
        if (lista[i].isotipo) {
          lista[i].isotipo = lista[i].isotipo.toString()
        }
      }
    }
 
     response.status   = 1
     response.cantidad = cantidad
     response.lista    = cantidadRegistros ? pageList : lista
     res.send(response)
   })
}

var usuariosempresaListaIdUsuario = function(req, res) {
  var usuarioLogueado   = req.decoded ? req.decoded.usuario : 'undefined'
  var empresa           = req.query.empresa           || 'soa'
  var idestado          = req.query.idestado          || 2
  var idusuario         = req.query.idusuario
  var sortByName        = req.query.sortByName        || 'idempresa'
  var sortByType        = req.query.sortByType        || 'ASC'
  var ultimoRecnum      = req.query.ultimoRecnum      || 0
  var cantidadRegistros = req.query.limit
  var pagination        = req.query.pagination        || 1
  var textSearch        = req.query.textSearch
  var isExcel           = false
    
  var query           = ` EXEC USP_seg_usuarios_empresa_lista_idusuario @idusuario `
  var parameters      = {}
  var isWhere         = false
  var aux             = ''
  var where           = []
  var arregloAuxiliar = []
   
   var response = {
     status : 0
   }
 
   parameters.idusuario = idusuario
 
  //  console.log('empresa:>>> ', empresa)
  //  console.log('query:>>> ', query)
  //  console.log('parameters:>>> ', parameters)
 
   api.sql.seg_usuarios.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
    if (err) {
			res.send({ status: 0, message: err.message})
			return
		}
 
    if (lista && lista.length > 0) {
      for (let i = 0; i < lista.length; i++) {
        if (lista[i].logo) {
          lista[i].logo = lista[i].logo.toString()
        }
        if (lista[i].isotipo) {
          lista[i].isotipo = lista[i].isotipo.toString()
        }
      }
    }
 
     response.status   = 1
     response.cantidad = cantidad
     response.lista    = cantidadRegistros ? pageList : lista
     res.send(response)
   })
}

var usuariosempresaMantenimiento = function(req, res) {
  var usuarioLogueado   = req.decoded ? req.decoded.usuario : 'undefined'
  var username          = req.body.username                  || 'soa'
  var empresa           = req.body.empresa                   || 'soa'
  var idestado          = req.body.idestado                  || 2
  var arreglo           = req.body.arreglo           || []
  var tipoaccion        = req.body.tipoaccion                || []
  var sortByName        = req.body.sortByName                || 'idusuarioempresa'
  var sortByType        = req.body.sortByType                || 'ASC'
  var ultimoRecnum      = req.body.ultimoRecnum              || 0
  var cantidadRegistros = req.body.limit                     || 50
  var pagination        = req.body.pagination                || 1
  var textSearch        = req.body.textSearch
  var isExcel           = false

  console.log('arreglo:>>> ', arreglo)

  var response = {
    status : 0
  }

  
  if (tipoaccion === 1 || tipoaccion === 2) {

    var obj = {
      tipo            : +tipoaccion,
      idusuarioempresa: arreglo.idusuarioempresa,
      idusuario       : arreglo.idusuario,
      idempresa       : arreglo.idempresa,
      idrol           : arreglo.idrol,
      usuarioregistro : arreglo.usuarioregistro || username,
      fecharegistro   : arreglo.fecharegistro
    }
  
    console.log('obj:>>> ', obj)
    
    var query      = ` EXEC USP_seg_usuarios_empresa_mantenimiento @tipo, @idusuarioempresa, @idusuario, @idempresa, @idrol, @usuarioregistro`
    var parameters = {}
    var isWhere    = false
    var aux        = ''
    var where      = []
  
    parameters.tipo             = obj.tipo
    parameters.idusuarioempresa = obj.idusuarioempresa
    parameters.idusuario        = obj.idusuario
    parameters.idempresa        = obj.idempresa
    parameters.idrol            = obj.idrol
    parameters.usuarioregistro  = obj.usuarioregistro

    console.log('parameters:>>> ', parameters)

    api.sql.seg_usuarios_empresa.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
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
    async.eachSeries(arreglo, function(servicio, cb) {
      api.sql.seg_usuarios_empresa.getOne(empresa, servicio.idusuarioempresa, function(err, found, servicioEncontrado) {
        if (err) cb(err)
        else {
          if (servicioEncontrado && servicioEncontrado.idusuarioempresa) {
            var query             = ` EXEC USP_seg_usuarios_empresa_mantenimiento @tipo, @idusuarioempresa `
            var parameters        = {}
            parameters.tipo       = tipoaccion
            parameters.idusuarioempresa  = servicioEncontrado.idusuarioempresa        
            // console.log('parameters:>>> ', parameters)
            api.sql.seg_usuarios_empresa.builtGet(empresa, query, parameters, function(error, cantidad, lista) {
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

exports.usuariosempresaLista          = usuariosempresaLista
exports.usuariosempresaListaIdEmpresa = usuariosempresaListaIdEmpresa
exports.usuariosempresaListaIdUsuario = usuariosempresaListaIdUsuario
exports.usuariosempresaMantenimiento  = usuariosempresaMantenimiento