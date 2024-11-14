var express = require('express');
var router = express.Router();

var mw = require('../model/middleware')

var categorias = require('../model/categorias')

//Router para /usuario/

// define the home page route
router.get('/lista',            mw.isLogged,  categorias.categoriasLista);
router.post('/mantenimiento',   mw.isLogged,  categorias.categoriasMantenimiento);

module.exports = router;