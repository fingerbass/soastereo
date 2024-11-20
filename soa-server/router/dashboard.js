var express = require('express');
var router = express.Router();
var mw = require('../model/middleware')
var dashboard = require('../model/dashboard')

// Rutas existentes
router.get('/lista-personas', mw.isLogged, dashboard.dashboardListaPersonas);
router.get('/lista-activos', mw.isLogged, dashboard.dashboardListaActivos);

// Nuevas rutas para el dashboard de eventos
router.get('/eventos/kpis', mw.isLogged, dashboard.dashboardEventosKpis);
router.get('/eventos/tendencia', mw.isLogged, dashboard.dashboardEventosTendencia);
router.get('/eventos/radar', mw.isLogged, dashboard.dashboardEventosRadar);
router.get('/eventos/distribucion', mw.isLogged, dashboard.dashboardEventosDistribucion);
router.get('/eventos/costos', mw.isLogged, dashboard.dashboardEventosCostos);

module.exports = router;