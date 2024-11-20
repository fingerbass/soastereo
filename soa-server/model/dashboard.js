var moment = require('moment')
  , api    = require('../api/index')
  , _      = require('lodash')
  , jwt    = require('jsonwebtoken')
  , config = require('../util/config')
  , async  = require('async')
  ;

// MANTENIMIENTO DE DASHBOARD - FUNCIONES EXISTENTES
var dashboardListaPersonas = function(req, res) {
  var usuarioLogueado   = req.decoded ? req.decoded.usuario : 'undefined'
  var empresa           = req.query.empresa           || 'soa'
  var idestado         = req.query.idestado          || 2
  var idempresa        = req.query.idempresa         || 0
  var sortByName       = req.query.sortByName        || 'idagentesede'
  var sortByType       = req.query.sortByType        || 'ASC'
  var ultimoRecnum     = req.query.ultimoRecnum      || 0
  var cantidadRegistros = req.query.limit
  var pagination       = req.query.pagination        || 1
  var textSearch       = req.query.textSearch
  var isExcel          = false

  var query = ` EXEC USP_vig_ingresosalida_lista_idempresa @idempresa `

  var parameters = {}
  var isWhere = false
  var aux = ''
  var where = []

  parameters.idempresa = +idempresa

  var response = {
    status: 0
  }

  api.sql.vig_ingresosalida.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
    if (err) {
      res.send({ status: 0, message: err.message})
      return
    }

    response.status = 1
    response.cantidad = cantidad
    response.lista = lista
    res.send(response)
  })
}

var dashboardListaActivos = function(req, res) {
  var usuarioLogueado   = req.decoded ? req.decoded.usuario : 'undefined'
  var empresa           = req.query.empresa           || 'soa'
  var idestado         = req.query.idestado          || 2
  var idempresa        = req.query.idempresa         || 0
  var sortByName       = req.query.sortByName        || 'idagentesede'
  var sortByType       = req.query.sortByType        || 'ASC'
  var ultimoRecnum     = req.query.ultimoRecnum      || 0
  var cantidadRegistros = req.query.limit
  var pagination       = req.query.pagination        || 1
  var textSearch       = req.query.textSearch
  var isExcel          = false

  var query = ` EXEC USP_adm_personal_activos_lista_idempresa @idempresa `

  var parameters = {}
  var isWhere = false
  var aux = ''
  var where = []

  parameters.idempresa = +idempresa

  var response = {
    status: 0
  }

  api.sql.adm_personal_activos.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
    if (err) {
      res.send({ status: 0, message: err.message})
      return
    }

    response.status = 1
    response.cantidad = cantidad
    response.lista = lista
    res.send(response)
  })
}

// DASHBOARD DE EVENTOS - NUEVAS FUNCIONES
var dashboardEventosKpis = function(req, res) {
  var usuarioLogueado = req.decoded ? req.decoded.usuario : 'undefined'
  var empresa = req.query.empresa || 'soa'
  var año = req.query.año || moment().year()

  var query = ` EXEC USP_dashboard_kpis `
  var parameters = {}
  var response = { status: 0 }

  api.sql.adm_dashboard.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
    if (err) {
      res.send({ status: 0, message: err.message})
      return
    }
    response.status = 1
    response.cantidad = cantidad
    response.lista = lista[0] // Solo necesitamos el primer resultado para los KPIs
    res.send(response)
  })
}

var dashboardEventosTendencia = function(req, res) {
  var usuarioLogueado = req.decoded ? req.decoded.usuario : 'undefined'
  var empresa = req.query.empresa || 'soa'
  var año = req.query.año || moment().year()
  var mes = req.query.mes || moment().month() + 1

  var query = ` EXEC USP_dashboard_eventos_trend `
  var parameters = {
    año: año,
    mes: mes
  }
  var response = { status: 0 }

  api.sql.adm_dashboard.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
    if (err) {
      res.send({ status: 0, message: err.message})
      return
    }
    response.status = 1
    response.cantidad = cantidad
    response.lista = lista
    res.send(response)
  })
}

var dashboardEventosRadar = function(req, res) {
  var usuarioLogueado = req.decoded ? req.decoded.usuario : 'undefined'
  var empresa = req.query.empresa || 'soa'

  var query = ` EXEC USP_dashboard_radar_stats `
  var parameters = {}
  var response = { status: 0 }

  api.sql.adm_dashboard.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
    if (err) {
      res.send({ status: 0, message: err.message})
      return
    }
    response.status = 1
    response.cantidad = cantidad
    response.lista = {
      estados: lista[0],
      tiempos: lista[1]
    }
    res.send(response)
  })
}

var dashboardEventosDistribucion = function(req, res) {
  var usuarioLogueado = req.decoded ? req.decoded.usuario : 'undefined'
  var empresa = req.query.empresa || 'soa'

  var query = ` EXEC USP_dashboard_pie_chart `
  var parameters = {}
  var response = { status: 0 }

  api.sql.adm_dashboard.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
    if (err) {
      res.send({ status: 0, message: err.message})
      return
    }
    response.status = 1
    response.cantidad = cantidad
    response.lista = {
      estados: lista[0],
      costos: lista[1]
    }
    res.send(response)
  })
}

var dashboardEventosCostos = function(req, res) {
  var usuarioLogueado = req.decoded ? req.decoded.usuario : 'undefined'
  var empresa = req.query.empresa || 'soa'
  var año = req.query.año || moment().year()

  var query = ` EXEC USP_dashboard_costos_mensuales `
  var parameters = {
    año: año
  }
  var response = { status: 0 }

  api.sql.adm_dashboard.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
    if (err) {
      res.send({ status: 0, message: err.message})
      return
    }
    response.status = 1
    response.cantidad = cantidad
    response.lista = lista
    res.send(response)
  })
}

// Exportaciones
exports.dashboardListaPersonas = dashboardListaPersonas
exports.dashboardListaActivos = dashboardListaActivos
exports.dashboardEventosKpis = dashboardEventosKpis
exports.dashboardEventosTendencia = dashboardEventosTendencia
exports.dashboardEventosRadar = dashboardEventosRadar
exports.dashboardEventosDistribucion = dashboardEventosDistribucion
exports.dashboardEventosCostos = dashboardEventosCostos