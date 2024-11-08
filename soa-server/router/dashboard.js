var express   = require('express');
var router    = express.Router();
var mw        = require('../model/middleware')
var dashboard = require('../model/dashboard')

//Router para /dashboard/
// define the home page route
// router.get('/', mw.isLogged, dashboard.obtener);
router.get('/lista-personas',         mw.isLogged,  dashboard.dashboardListaPersonas);

module.exports = router;