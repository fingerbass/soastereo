var  jwt = require('jsonwebtoken')
    ,config = require('../util/config')
    ;

var isLogged = function(req, res, next) {
  // verifies secret and checks exp
  // console.log('req.query:', req.query)
  // console.log('req.body:', req.body)
  var token = req.body.token || req.query.token;
  // console.log('token:', token)
  // console.log('config.secret:', config.secret)
  jwt.verify(token, config.secret, function(err, decoded) {      
    var response = {
      status : -1,
      message: 'No ha ingresado al sistema'
    }
    
    if (err) {
      res.send(response);
    } else {
      // si todo esta bien, ahorre para solicitar su uso en otras rutas
      // console.log('decoded:', decoded);
      req.decoded = decoded;    
      next();
    }
  });
};

var validateEmpresa = function(req, res, next) {
  var empresa = req.body.empresa || req.query.empresa || req.params.empresa || '';

  if (empresa === 'soa' || empresa === 'demo') {
    next();
  } else {
    var response = {
      status: 0,
      message: 'La empresa no está registrada'
    }
    res.send(response)
  }
}

var cargarGlobales = function (callback) {
  // Emulamos Boxer, porque son iguales en todas las empresas
  callback(null)
}

exports.isLogged        = isLogged;
exports.validateEmpresa = validateEmpresa;
exports.cargarGlobales  = cargarGlobales;