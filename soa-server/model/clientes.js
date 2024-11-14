var moment        = require('moment')
  , api           = require('../api/index')
  , _             = require('lodash')
  , jwt           = require('jsonwebtoken')
  , config        = require('../util/config')
  , async         = require('async')
  , path          = require('path')
  , moment        = require('moment')
  , general       = require('../util/general')
  , Excel         = require('exceljs')
  , mail          = require('../util/mail')
  , nodemailer    = require('nodemailer')
	;

  const uuid = require('uuid');

// MANTENIMIENTO DE clientes
var clientesLista = function(req, res) {
  var usuarioLogueado   = req.decoded ? req.decoded.usuario : 'undefined'
  var empresa           = req.query.empresa           || 'soa'
  var idestado          = req.query.idestado          || 2
  var sortByName        = req.query.sortByName        || 'idcliente'
  var sortByType        = req.query.sortByType        || 'ASC'
  var ultimoRecnum      = req.query.ultimoRecnum      || 0
  var cantidadRegistros = req.query.limit
  var pagination        = req.query.pagination        || 1
  var textSearch        = req.query.textSearch
  var isExcel           = false

  var query      = ` EXEC USP_adm_clientes_lista @idestado`

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

	api.sql.adm_clientes.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
		if (err) {
			res.send({ status: 0, message: err.message})
			return
		}

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
    if (sortByName === '-idcliente') {
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

var clientesMantenimiento = function(req, res) {
  var usuarioLogueado   = req.decoded ? req.decoded.usuario : 'undefined'
  var username          = req.body.username                  || 'soa'
  var empresa           = req.body.empresa                   || 'soa'
  var idestado          = req.body.idestado                  || 2
  var arreglo           = req.body.arreglo            || []
  var tipoaccion        = req.body.tipoaccion                || []
  var sortByName        = req.body.sortByName                || 'idcliente'
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
      idcliente      : arreglo.idcliente,
      nombres        : arreglo.nombres,
      apellidos      : arreglo.apellidos,
      numerodocumento: arreglo.numerodocumento,
      direccion      : arreglo.direccion,
      distrito       : arreglo.distrito,
      ciudad         : arreglo.ciudad,
      telefono       : arreglo.telefono,
      email          : arreglo.email,
      activo         : arreglo.activo,
      usuarioregistro: arreglo.usuarioregistro  || username,
      fecharegistro  : arreglo.fecharegistro
    }
  
    console.log('obj:>>> ', obj)

    var query      = ` EXEC USP_adm_clientes_mantenimiento @tipo, @idcliente, @nombres, @apellidos, @numerodocumento, @direccion, @distrito, @ciudad, @telefono, @email, @activo, @usuarioregistro`
    var parameters = {}
    var isWhere    = false
    var aux        = ''
    var where      = []
  
    parameters.tipo            = obj.tipo
    parameters.idcliente       = obj.idcliente
    parameters.nombres         = obj.nombres
    parameters.apellidos       = obj.apellidos
    parameters.numerodocumento = obj.numerodocumento
    parameters.direccion       = obj.direccion
    parameters.distrito        = obj.distrito
    parameters.ciudad          = obj.ciudad
    parameters.email           = obj.email
    parameters.telefono        = obj.telefono
    parameters.activo          = obj.activo
    parameters.usuarioregistro = obj.usuarioregistro

    console.log('parameters:>>> ', parameters)

    api.sql.adm_clientes.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
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
    async.eachSeries(arreglo, function(clientes, cb) {
      api.sql.adm_clientes.getOne(empresa, clientes.idcliente, function(err, found, empresaEncontrado) {
        if (err) cb(err)
        else {
          if (empresaEncontrado && empresaEncontrado.idcliente) {
            var query             = ` EXEC USP_adm_clientes_mantenimiento @tipo, @idcliente `
            var parameters        = {}
            parameters.tipo       = tipoaccion
            parameters.idcliente  = empresaEncontrado.idcliente        
            // console.log('parameters:>>> ', parameters)
            api.sql.adm_clientes.builtGet(empresa, query, parameters, function(error, cantidad, lista) {
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

var clientesUploadPlantillaCargaMasiva = function(req, res) {
  var usuarioLogueado   = req.decoded ? req.decoded.usuario : 'undefined'
  var usuario          = req.body.username                  || 'soa'
  var empresa           = req.body.empresa                   || 'soa'
  var empresa           = req.body.empresa
  var fileSubido        = req.body.fileSubido
  var idestado          = req.body.idestado                  || 2
  var arreglo           = req.body.arreglo                   || []
  var tipoaccion        = req.body.tipoaccion                || []
  var sortByName        = req.body.sortByName                || 'idcliente'
  var sortByType        = req.body.sortByType                || 'ASC'
  var ultimoRecnum      = req.body.ultimoRecnum              || 0
  var cantidadRegistros = req.body.limit || 50
  var pagination        = req.body.pagination                || 1
  var textSearch        = req.body.textSearch
  var isExcel           = false

  general.infoLog(empresa, {metodo: 'clientes.clientesUploadPlantillaCargaMasiva', usuario: usuario})

  var response = {
    status : 0
  }

  var filename = path.join(process.cwd(), fileSubido);

  handlerPlantillaclientes(empresa, usuario, filename, 'guardar', function(err, observaciones) {
    if (err) {
      response.message = err.message
      res.send(response)
      return
    }

    console.log('observaciones: >>> ', observaciones)

    response.status        = 1
    response.observaciones = observaciones
    res.send(response)
    return
  })

}

exports.clientesLista                      = clientesLista
exports.clientesMantenimiento              = clientesMantenimiento