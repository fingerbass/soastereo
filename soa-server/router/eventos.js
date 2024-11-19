var express = require('express');
var router = express.Router();
var mw = require('../model/middleware')
var eventos = require('../model/eventos')

router.get('/lista', mw.isLogged, eventos.eventosLista);
router.post('/mantenimiento', mw.isLogged, eventos.eventosMantenimiento);

module.exports = router;

