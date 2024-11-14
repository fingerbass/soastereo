var express         = require('express');
var router          = express.Router();
var mw              = require('../model/middleware')
var log_actividades = require('../model/log_actividades')

//Router para /log_actividades/
// define the home page route
// router.get('/', mw.isLogged, log_actividades.obtener);
router.get('/lista',          mw.isLogged, log_actividades.logActividadesLista);
router.post('/mantenimiento', mw.isLogged, log_actividades.logActividadesMantenimiento);

module.exports = router;