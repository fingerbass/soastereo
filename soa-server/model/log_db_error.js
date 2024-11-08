var moment = require('moment')
  , api    = require('../api/index')
  , _      = require('lodash')
  , jwt    = require('jsonwebtoken')
  , config = require('../util/config')
  , async  = require('async')
	;

// MANTENIMIENTO DE ERROR
var errorLista = function(req, res) {
  var usuarioLogueado   = req.decoded ? req.decoded.usuario : 'undefined'
  var empresa           = req.query.empresa           || 'mastermind'
  var idestado          = req.query.idestado          || 2
  var sortByName        = req.query.sortByName        || 'iderror'
  var sortByType        = req.query.sortByType        || 'ASC'
  var ultimoRecnum      = req.query.ultimoRecnum      || 0
  var cantidadRegistros = req.query.limit
  var pagination        = req.query.pagination        || 1
  var textSearch        = req.query.textSearch
  var isExcel           = false

  var query      = ` SELECT * FROM seg_log_db_error `

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

	api.sql.seg_log_db_error.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
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
    if (sortByName === '-iderror') {
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

exports.errorLista         = errorLista