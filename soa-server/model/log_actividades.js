var moment = require('moment')
  , api    = require('../api/index')
  , _      = require('lodash')
  , jwt    = require('jsonwebtoken')
  , config = require('../util/config')
  , async  = require('async')
	;

const http = require('node:http')

// MANTENIMIENTO DE ERROR
var logActividadesLista = function(req, res) {
  var usuarioLogueado   = req.decoded ? req.decoded.usuario : 'undefined'
  var empresa           = req.query.empresa           || 'mastermind'
  var idestado          = req.query.idestado          || 2
  var sortByName        = req.query.sortByName        || 'idlogusuario'
  var sortByType        = req.query.sortByType        || 'ASC'
  var ultimoRecnum      = req.query.ultimoRecnum      || 0
  var cantidadRegistros = req.query.limit
  var pagination        = req.query.pagination        || 1
  var textSearch        = req.query.textSearch
  var isExcel           = false

  var query      = ` EXEC USP_seg_log_actividades_lista `

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

	api.sql.seg_log_actividades.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
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
    if (sortByName === '-idlogusuario') {
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

var logActividadesMantenimiento = function(req, res) {
}

var handlerViewSegLogActividades = function(empresa, accion, callback) {

  var query      = ` SELECT * FROM vt_seg_log_acciones `
	var parameters = {}

	api.sql.seg_log_actividades.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
		if (err) {
			callback(err)
			return
		}

    // console.log('lista:>>> ', lista)
    // [
    //   { idaccion: 1, nombre: 'INICIO DE SESION' },
    //   { idaccion: 2, nombre: 'CIERRE SESION' },
    //   { idaccion: 3, nombre: 'SELECCION' },
    //   { idaccion: 4, nombre: 'AGREGAR REGISTRO' },
    //   { idaccion: 5, nombre: 'EDITAR REGISTRO' },
    //   { idaccion: 6, nombre: 'ELIMINAR REGISTRO' },
    //   { idaccion: 7, nombre: 'EXPORTAR' }
    // ]
    
    const arreglofiltrado = lista.filter((lista) => lista.idaccion === accion)
    // console.log('arreglofiltrado:>>> ', arreglofiltrado)

    var consolidado = []
    var isfound     = false
    if (arreglofiltrado && arreglofiltrado.length > 0) {
      isfound     = true
      consolidado = arreglofiltrado[0]
    } else {
      isfound     = false
      consolidado = []
    }

    callback(null, isfound, consolidado)
	})
}

// idlogusuario
// idusuario
// accion
// opcion
// valoranterior
// valoractual
// fecharegistro
// latitud
// longitud
// dispositivo
// ip

var guardarLogActividades = function (obj, callback) {
  // console.log('obj:>>> ', obj)
  var empresaGlobal = 'mastermind'
  handlerViewSegLogActividades(empresaGlobal, obj.accion, function(err, isfound, data) {
    if (err) {
      callback ? callback(err) : console.error('Error en vt_seg_log_acciones', err.message)
    } else {
      // console.log('data:>>> ', data)
      if (isfound) {
        var point = { type: 'Point', coordinates: [39.807222, -76.984722]}
        var objLogActividades = {
          // idlogusuario : obj.idlogusuario   || '',
          idusuario    : obj.idusuario      || '',
          accion       : data.nombre        || '',
          opcion       : obj.opcion         || '',
          valoranterior: obj.valoranterior  || '',
          valoractual  : obj.valoractual    || '',
          fecharegistro: (new Date())       || null,
          // latitud      : obj.latitud && obj.longitud ? `POINT(${obj.latitud} ${obj.longitud})` : ``,
          // longitud     : obj.latitud && obj.longitud ? `POINT(${obj.latitud} ${obj.longitud})` : ``,
          // latitud      : obj.latitud && obj.longitud ? `POINT(${obj.latitud} ${obj.longitud})` : `POINT(-12.1109666 -76.9736296)`,
          // longitud     : obj.latitud && obj.longitud ? `POINT(${obj.latitud} ${obj.longitud})` : `POINT(-12.1109666 -76.9736296)`,
          // latitud      : obj.latitud        || 'LINESTRING(-122.360 47.656, -122.343 47.656 )',
          // longitud     : obj.longitud       || 'LINESTRING(-122.360 47.656, -122.343 47.656 )',
          latitud      : obj.latitud        || '',
          longitud     : obj.longitud       || '',
          dispositivo  : obj.dispositivo    || '',
          ip           : obj.ip             || ''
        }
        
        // if (obj.idlogusuario)   objLogActividades.idlogusuario  = obj.idlogusuario
        if (obj.idusuario)      objLogActividades.idusuario     = obj.idusuario
        if (obj.accion)         objLogActividades.accion        = obj.accion
        if (obj.opcion)         objLogActividades.opcion        = obj.opcion
        if (obj.valoranterior)  objLogActividades.valoranterior = obj.valoranterior
        if (obj.valoractual)    objLogActividades.valoractual   = obj.valoractual
        if (obj.fecharegistro)  objLogActividades.fecharegistro = obj.fecharegistro || new Date()
        if (obj.latitud)        objLogActividades.latitud       = obj.latitud && obj.longitud ? `POINT(${obj.latitud} ${obj.longitud})` : ''
        if (obj.longitud)       objLogActividades.longitud      = obj.latitud && obj.longitud ? `POINT(${obj.latitud} ${obj.longitud})` : ''
        if (obj.dispositivo)    objLogActividades.dispositivo   = obj.dispositivo || ''
        if (obj.ip)             objLogActividades.ip            = obj.ip          || ''
        console.log('objLogActividades:>>> ', objLogActividades)
      }

      // console.log('obj :', obj)
      api.sql.seg_log_actividades.insert(empresaGlobal, objLogActividades, function(err) {
        if (err) callback ? callback(err) : console.error('Error en seg_log_actividades.insert', err.message)
        else callback && callback(null)
      })

    }
  })
}

exports.logActividadesLista         = logActividadesLista
exports.logActividadesMantenimiento = logActividadesMantenimiento
exports.guardarLogActividades       = guardarLogActividades