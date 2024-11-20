var express = require('express');
var router = express.Router();
var mw = require('../model/middleware')
var proveedores = require('../model/proveedores')

router.get('/lista', mw.isLogged, proveedores.proveedoresLista);
router.post('/mantenimiento', mw.isLogged, proveedores.proveedoresMantenimiento);

module.exports = router;