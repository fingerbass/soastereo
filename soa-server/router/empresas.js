var express = require('express');
var router = express.Router();

var mw = require('../model/middleware')

var empresas = require('../model/empresas')

//Router para /usuario/

// define the home page route
router.get('/lista',            mw.isLogged,  empresas.empresasLista);
router.post('/mantenimiento',   mw.isLogged,  empresas.empresasMantenimiento);
// router.post('/uuid',   mw.isLogged,  empresas.empresasUUID);
// router.post('/upload-plantilla-carga-masiva',   mw.isLogged,  empresas.empresasUploadPlantillaCargaMasiva);

module.exports = router;