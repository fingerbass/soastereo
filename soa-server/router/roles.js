var express = require('express');
var router  = express.Router();
var mw      = require('../model/middleware')
var roles   = require('../model/roles')

//Router para /roles/
// define the home page route
// router.get('/', mw.isLogged, roles.obtener);
router.get('/lista',            mw.isLogged,  roles.rolesLista);
router.post('/mantenimiento',   mw.isLogged,  roles.rolesMantenimiento);

module.exports = router;