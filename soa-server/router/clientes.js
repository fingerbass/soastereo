var express = require('express');
var router = express.Router();

var mw = require('../model/middleware')

var clientes = require('../model/clientes')

//Router para /usuario/

// define the home page route
router.get('/lista',            mw.isLogged,  clientes.clientesLista);
router.post('/mantenimiento',   mw.isLogged,  clientes.clientesMantenimiento);

module.exports = router;