var express      = require('express');
var router       = express.Router();
var mw           = require('../model/middleware')
var log_db_error = require('../model/log_db_error')

//Router para /log_db_error/
// define the home page route
// router.get('/', mw.isLogged, log_db_error.obtener);
router.get('/lista',   mw.isLogged, log_db_error.errorLista);

module.exports = router;