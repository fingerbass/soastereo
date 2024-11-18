var moment = require('moment')
  , api    = require('../api/index')
  , _      = require('lodash')
;

var evaluacionLista = function(req, res) {
  var usuarioLogueado = req.decoded ? req.decoded.usuario : 'undefined'
  var empresa = req.query.empresa || 'soa'
  var proveedor_id = req.query.proveedor_id
  
  var query = `
    SELECT 
      e.*,
      p.nombre as proveedor_nombre,
      c.nombre as categoria_nombre,
      ev.nombre as evento_nombre
    FROM evaluacion e
    INNER JOIN proveedor p ON e.proveedor_id = p.id
    INNER JOIN adm_categorias c ON p.idcategoria = c.idcategoria
    INNER JOIN evento ev ON e.evento_id = ev.id
    WHERE (@proveedor_id IS NULL OR e.proveedor_id = @proveedor_id)
    ORDER BY e.creado_en DESC
  `

  var parameters = {
    proveedor_id: proveedor_id
  }

  var response = {
    status: 0
  }

  api.sql.adm_evaluacion.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
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

var evaluacionMantenimiento = function(req, res) {
  var usuarioLogueado = req.decoded ? req.decoded.usuario : 'undefined'
  var usuario = req.body.username || 'soa'
  var empresa = req.body.empresa || 'soa'
  var tipoaccion = req.body.tipoaccion
  var evaluacion = req.body.evaluacion || {}

  var response = {
    status: 0
  }

  if (tipoaccion === 1) { // Insertar
    var obj = {
      evento_id: evaluacion.evento_id,
      proveedor_id: evaluacion.proveedor_id,
      puntuacion: evaluacion.puntuacion,
      comentario: evaluacion.comentario,
      usuarioregistro: usuario,
      fecharegistro: new Date(),
      creado_en: new Date()
    }

    api.sql.adm_evaluacion.insert(empresa, obj, function(err, result) {
      if (err) {
        res.send({ status: 0, message: err.message})
        return
      }
      response.status = 1
      res.send(response)
    })
  } 
  else if (tipoaccion === 2) { // Actualizar
    var obj = {
      puntuacion: evaluacion.puntuacion,
      comentario: evaluacion.comentario,
      proveedor_id: evaluacion.proveedor_id,
      usuarioregistro: usuario
    }

    api.sql.adm_evaluacion.update(empresa, evaluacion.id, obj, function(err, result) {
      if (err) {
        res.send({ status: 0, message: err.message})
        return
      }
      response.status = 1
      res.send(response)
    })
  }
  else if (tipoaccion === 3) { // Eliminar
    api.sql.adm_evaluacion.deleteById(empresa, evaluacion.id, function(err) {
      if (err) {
        res.send({ status: 0, message: err.message})
        return
      }
      response.status = 1
      res.send(response)
    })
  }
  else {
    res.send({ status: 0, message: 'Tipo de acción no válido'})
  }
}

exports.evaluacionLista = evaluacionLista
exports.evaluacionMantenimiento = evaluacionMantenimiento