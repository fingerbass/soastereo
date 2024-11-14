var moment = require('moment')
  , api    = require('../api/index')
  , _      = require('lodash')
  , jwt    = require('jsonwebtoken')
  , config = require('../util/config')
  , async  = require('async')
	;

// MANTENIMIENTO DE DASHBOARD
var dashboardListaPersonas = function(req, res) {
  var usuarioLogueado   = req.decoded ? req.decoded.usuario : 'undefined'
  var empresa           = req.query.empresa           || 'soa'
  var idestado          = req.query.idestado          || 2
  var idempresa         = req.query.idempresa         || 0
  var sortByName        = req.query.sortByName        || 'idagentesede'
  var sortByType        = req.query.sortByType        || 'ASC'
  var ultimoRecnum      = req.query.ultimoRecnum      || 0
  var cantidadRegistros = req.query.limit
  var pagination        = req.query.pagination        || 1
  var textSearch        = req.query.textSearch
  var isExcel           = false

  var query      = ` EXEC USP_vig_ingresosalida_lista_idempresa @idempresa `

	var parameters = {}
	var isWhere    = false
	var aux        = ''
	var where      = []

	// parameters.idestado  = +idestado
	parameters.idempresa = +idempresa

  var response = {
    status : 0
  }

  // console.log('empresa:>>> ', empresa)
  // console.log('query:>>> ', query)
  // console.log('parameters:>>> ', parameters)
  
	api.sql.vig_ingresosalida.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
    if (err) {
      res.send({ status: 0, message: err.message})
			return
		}
    // console.log('lista:>>> ', lista)

    response.status   = 1
    response.cantidad = cantidad
    response.lista    = lista
    res.send(response)
		
	})
}

var dashboardListaActivos = function(req, res) {
  var usuarioLogueado   = req.decoded ? req.decoded.usuario : 'undefined'
  var empresa           = req.query.empresa           || 'soa'
  var idestado          = req.query.idestado          || 2
  var idempresa         = req.query.idempresa         || 0
  var sortByName        = req.query.sortByName        || 'idagentesede'
  var sortByType        = req.query.sortByType        || 'ASC'
  var ultimoRecnum      = req.query.ultimoRecnum      || 0
  var cantidadRegistros = req.query.limit
  var pagination        = req.query.pagination        || 1
  var textSearch        = req.query.textSearch
  var isExcel           = false

  var query      = ` EXEC USP_adm_personal_activos_lista_idempresa @idempresa `

	var parameters = {}
	var isWhere    = false
	var aux        = ''
	var where      = []

	// parameters.idestado = +idestado
  parameters.idempresa = +idempresa

  var response = {
    status : 0
  }

  // console.log('empresa:>>> ', empresa)
  // console.log('query:>>> ', query)
  // console.log('parameters:>>> ', parameters)

	api.sql.adm_personal_activos.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
		if (err) {
			res.send({ status: 0, message: err.message})
			return
		}

    // console.log('lista:>>> ', lista)

    response.status   = 1
    response.cantidad = cantidad
    response.lista    = lista
    res.send(response)
		
	})
}

var dashboardListaCorrespondencia = function(req, res) {
  var usuarioLogueado   = req.decoded ? req.decoded.usuario : 'undefined'
  var empresa           = req.query.empresa           || 'soa'
  var idestado          = req.query.idestado          || 2
  var idempresa         = req.query.idempresa         || 0
  var sortByName        = req.query.sortByName        || 'idagentesede'
  var sortByType        = req.query.sortByType        || 'ASC'
  var ultimoRecnum      = req.query.ultimoRecnum      || 0
  var cantidadRegistros = req.query.limit
  var pagination        = req.query.pagination        || 1
  var textSearch        = req.query.textSearch
  var isExcel           = false

  var query      = ` EXEC USP_vig_correspondencia_lista_idempresa @idempresa `

	var parameters = {}
	var isWhere    = false
	var aux        = ''
	var where      = []

	// parameters.idestado = +idestado
  parameters.idempresa = +idempresa

  var response = {
    status : 0
  }

  // console.log('empresa:>>> ', empresa)
  // console.log('query:>>> ', query)
  // console.log('parameters:>>> ', parameters)

	api.sql.vig_correspondencia.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
		if (err) {
			res.send({ status: 0, message: err.message})
			return
		}

    // console.log('lista:>>> ', lista)

    response.status   = 1
    response.cantidad = cantidad
    response.lista    = lista
    res.send(response)
		
	})
}

var dashboardListaIncidencias = function(req, res) {
  var usuarioLogueado   = req.decoded ? req.decoded.usuario : 'undefined'
  var empresa           = req.query.empresa           || 'soa'
  var idestado          = req.query.idestado          || 2
  var idempresa         = req.query.idempresa         || 0
  var sortByName        = req.query.sortByName        || 'idagentesede'
  var sortByType        = req.query.sortByType        || 'ASC'
  var ultimoRecnum      = req.query.ultimoRecnum      || 0
  var cantidadRegistros = req.query.limit
  var pagination        = req.query.pagination        || 1
  var textSearch        = req.query.textSearch
  var isExcel           = false

  var query      = ` EXEC USP_vig_incidencias_lista_idempresa @idempresa `

	var parameters = {}
	var isWhere    = false
	var aux        = ''
	var where      = []

	// parameters.idestado = +idestado
  parameters.idempresa = +idempresa

  var response = {
    status : 0
  }

  // console.log('empresa:>>> ', empresa)
  // console.log('query:>>> ', query)
  // console.log('parameters:>>> ', parameters)

	api.sql.vig_incidencias.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
		if (err) {
			res.send({ status: 0, message: err.message})
			return
		}

    // console.log('lista:>>> ', lista)

    response.status   = 1
    response.cantidad = cantidad
    response.lista    = lista
    res.send(response)
		
	})
}

exports.dashboardListaPersonas        = dashboardListaPersonas
exports.dashboardListaActivos         = dashboardListaActivos
exports.dashboardListaCorrespondencia = dashboardListaCorrespondencia
exports.dashboardListaIncidencias     = dashboardListaIncidencias