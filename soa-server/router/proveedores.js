var express     = require('express');
var router      = express.Router();
var mw          = require('../model/middleware')
var proveedores = require('../model/proveedores')

//Router para /proveedores/
// define the home page route
// router.get('/', mw.isLogged, proveedores.obtener);
router.get('/lista',            mw.isLogged,  proveedores.proveedoresLista);
router.post('/mantenimiento',   mw.isLogged,  proveedores.proveedoresMantenimiento);

module.exports = router;