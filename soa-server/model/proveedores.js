var moment = require('moment')
  , api    = require('../api/index')
  , _      = require('lodash')
  ;

// MANTENIMIENTO DE PROVEEDORES
var proveedoresLista = function(req, res) {
  var usuarioLogueado   = req.decoded ? req.decoded.usuario : 'undefined'
  var empresa           = req.query.empresa           || 'soa'
  var idestado         = req.query.idestado          || 2
  var sortByName       = req.query.sortByName        || 'id'
  var sortByType       = req.query.sortByType        || 'ASC'
  var ultimoRecnum     = req.query.ultimoRecnum      || 0
  var cantidadRegistros = req.query.limit || 0
  var pagination       = req.query.pagination        || 1
  var textSearch       = req.query.textSearch
  var isExcel         = false

  var query = ` EXEC USP_adm_proveedores_lista @idestado`

  var parameters = {}
  var isWhere = false
  var aux = ''
  var where = []

  parameters.idestado = +idestado

  var response = {
    status: 0
  }

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

var proveedoresMantenimiento = function(req, res) {
  var usuarioLogueado = req.decoded ? req.decoded.usuario : 'undefined'
  var username = req.body.username || 'soa'
  var empresa = req.body.empresa || 'soa'
  var idestado = req.body.idestado || 2
  var arreglo = req.body.arreglo || {}
  var tipoaccion = req.body.tipoaccion || 0

  var response = {
    status: 0
  }

  if (tipoaccion === 1 || tipoaccion === 2) {
    var obj = {
      tipo: +tipoaccion,
      id: arreglo.id,
      nombre: arreglo.nombre,
      email: arreglo.email,
      telefono: arreglo.telefono,
      direccion: arreglo.direccion,
      reputacion: arreglo.reputacion,
      verificado: arreglo.verificado,
      activo: arreglo.activo,
      idcategoria: arreglo.idcategoria,
      usuarioregistro: arreglo.usuarioregistro || username
    }

    var query = ` EXEC USP_adm_proveedores_mantenimiento 
      @tipo, @id, @nombre, @email, @telefono, @direccion,
      @reputacion, @verificado, @activo, @idcategoria, @usuarioregistro`

    var parameters = {
      tipo: obj.tipo,
      id: obj.id,
      nombre: obj.nombre,
      email: obj.email,
      telefono: obj.telefono,
      direccion: obj.direccion,
      reputacion: obj.reputacion,
      verificado: obj.verificado,
      activo: obj.activo,
      idcategoria: obj.idcategoria,
      usuarioregistro: obj.usuarioregistro
    }

    api.sql.adm_proveedores.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
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
    var query = ` EXEC USP_adm_proveedores_mantenimiento @tipo, @id `
    var parameters = {
      tipo: tipoaccion,
      id: arreglo.id
    }

    api.sql.adm_proveedores.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
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

exports.proveedoresLista = proveedoresLista
exports.proveedoresMantenimiento = proveedoresMantenimiento