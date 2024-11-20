var moment = require('moment')
  , api    = require('../api/index')
  , _      = require('lodash')
  , jwt    = require('jsonwebtoken')
  , config = require('../util/config')
  , async  = require('async')
	;

// MANTENIMIENTO DE PROVEEDORES
var proveedoresLista = function(req, res) {
  var usuarioLogueado   = req.decoded ? req.decoded.usuario : 'undefined'
  var empresa           = req.query.empresa           || 'soa'
  var idestado          = req.query.idestado          || 2
  var sortByName        = req.query.sortByName        || 'idproveedor'
  var sortByType        = req.query.sortByType        || 'ASC'
  var ultimoRecnum      = req.query.ultimoRecnum      || 0
  var cantidadRegistros = req.query.limit
  var pagination        = req.query.pagination        || 1
  var textSearch        = req.query.textSearch
  var isExcel           = false

  var query      = ` EXEC USP_adm_proveedores_lista @idestado`

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

	api.sql.adm_proveedores.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
		if (err) {
			res.send({ status: 0, message: err.message})
			return
		}

    if (lista.length < cantidadRegistros) response.noMore = true
    else {
      if (ultimoRecnum === lista[lista.length -1].ultimoRecnum) response.noMore = true
      else response.ultimoRecnum = +ultimoRecnum + +cantidadRegistros
    }

    let mockList = lista
  
    if (sortByName === '-idproveedor') {
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

var proveedoresMantenimiento = function(req, res) {
  var usuarioLogueado   = req.decoded ? req.decoded.usuario : 'undefined'
  var username          = req.body.username                  || 'soa'
  var empresa           = req.body.empresa                   || 'soa'
  var idestado          = req.body.idestado                  || 2
  var arreglo        = req.body.arreglo                || []
  var tipoaccion        = req.body.tipoaccion                || []
  var sortByName        = req.body.sortByName                || 'idproveedor'
  var sortByType        = req.body.sortByType                || 'ASC'
  var ultimoRecnum      = req.body.ultimoRecnum              || 0
  var cantidadRegistros = req.body.limit                     || 50
  var pagination        = req.body.pagination                || 1
  var textSearch        = req.body.textSearch
  var isExcel           = false

  var response = {
    status : 0
  }

  
  if (tipoaccion === 1 || tipoaccion === 2) {

    var obj = {
      tipo           : +tipoaccion,
      idproveedor          : arreglo.idproveedor,
      nombre         : arreglo.nombre,
      activo         : arreglo.activo,
      usuarioregistro: arreglo.usuarioregistro || username,
      fecharegistro  : arreglo.fecharegistro
    }
  
    console.log('obj:>>> ', obj)
    
    var query      = ` EXEC USP_adm_proveedores_mantenimiento @tipo, @idproveedor, @nombre, @activo, @usuarioregistro`
    var parameters = {}
    var isWhere    = false
    var aux        = ''
    var where      = []
  
    parameters.tipo            = obj.tipo
    parameters.idproveedor           = obj.idproveedor
    parameters.nombre          = obj.nombre
    parameters.activo          = obj.activo
    parameters.usuarioregistro = obj.usuarioregistro

    console.log('parameters:>>> ', parameters)

    api.sql.adm_proveedores.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
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
      api.sql.adm_proveedores.getOne(empresa, servicio.idproveedor, function(err, found, servicioEncontrado) {
        if (err) cb(err)
        else {
          if (servicioEncontrado && servicioEncontrado.idproveedor) {
            var query             = ` EXEC USP_adm_proveedores_mantenimiento @tipo, @idproveedor `
            var parameters        = {}
            parameters.tipo       = tipoaccion
            parameters.idproveedor      = servicioEncontrado.idproveedor        
            // console.log('parameters:>>> ', parameters)
            api.sql.adm_proveedores.builtGet(empresa, query, parameters, function(error, cantidad, lista) {
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

exports.proveedoresLista         = proveedoresLista
exports.proveedoresMantenimiento = proveedoresMantenimiento