var express = require('express');
var router = express.Router();
var mw = require('../model/middleware')
var evaluacion = require('../model/evaluacion')

router.get('/lista', mw.isLogged, evaluacion.evaluacionLista);
router.post('/mantenimiento', mw.isLogged, evaluacion.evaluacionMantenimiento);

module.exports = router;