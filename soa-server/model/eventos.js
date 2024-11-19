var moment = require('moment')
  , api    = require('../api/index')
  , _      = require('lodash')
  ;

// MANTENIMIENTO DE EVENTOS
var eventosLista = function(req, res) {
  var usuarioLogueado   = req.decoded ? req.decoded.usuario : 'undefined'
  var empresa           = req.query.empresa           || 'soa'
  var idestado         = req.query.idestado          || 2
  var sortByName       = req.query.sortByName        || 'id'
  var sortByType       = req.query.sortByType        || 'ASC'
  var ultimoRecnum     = req.query.ultimoRecnum      || 0
  var cantidadRegistros = req.query.limit
  var pagination       = req.query.pagination        || 1
  var textSearch       = req.query.textSearch
  var isExcel         = false

  var query = ` EXEC USP_adm_eventos_lista @idestado`

  var parameters = {}
  var isWhere = false
  var aux = ''
  var where = []

  parameters.idestado = +idestado

  var response = {
    status: 0
  }

  api.sql.adm_eventos.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
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
    if (sortByName === '-id') {
      mockList = mockList.reverse()
    }

    var pageList = []
    if (cantidadRegistros) {
      pageList = mockList.filter((item, index) => index < cantidadRegistros * pagination && index >= cantidadRegistros * (pagination - 1))
    }

    response.status = 1
    response.cantidad = cantidad
    response.lista = cantidadRegistros ? pageList : lista
    res.send(response)
  })
}

var eventosMantenimiento = function(req, res) {
  var usuarioLogueado = req.decoded ? req.decoded.usuario : 'undefined'
  var username = req.body.username || 'soa'
  var empresa = req.body.empresa || 'soa'
  var tipoaccion = req.body.tipoaccion
  var evento = req.body.evento || {}

  var response = {
    status: 0
  }

  if (tipoaccion === 1 || tipoaccion === 2) {
    var obj = {
      tipo: +tipoaccion,
      id: evento.id,
      nombre: evento.nombre,
      fecha: evento.fecha,
      lugar: evento.lugar,
      descripcion: evento.descripcion,
      estado: evento.estado || 'PENDIENTE',
      costo_total: evento.costo_total || 0,
      usuarioregistro: evento.usuarioregistro || username
    }

    var query = ` EXEC USP_adm_eventos_mantenimiento 
      @tipo, @id, @nombre, @fecha, @lugar, @descripcion, 
      @estado, @costo_total, @usuarioregistro`

    var parameters = {}
    parameters.tipo = obj.tipo
    parameters.id = obj.id
    parameters.nombre = obj.nombre
    parameters.fecha = obj.fecha
    parameters.lugar = obj.lugar
    parameters.descripcion = obj.descripcion
    parameters.estado = obj.estado
    parameters.costo_total = obj.costo_total
    parameters.usuarioregistro = obj.usuarioregistro

    api.sql.adm_eventos.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
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
  else if (tipoaccion === 3) {
    var query = ` EXEC USP_adm_eventos_mantenimiento @tipo, @id `
    var parameters = {}
    parameters.tipo = tipoaccion
    parameters.id = evento.id

    api.sql.adm_eventos.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
      if (err) {
        res.send({ status: 0, message: err.message})
        return
      }
      response.status = 1
      res.send(response)
    })
  } 
  else {
    res.send({ status: 0, message: 'Seleccione el tipo de acción correspondiente.'})
    return
  }
}

exports.eventosLista = eventosLista
exports.eventosMantenimiento = eventosMantenimiento