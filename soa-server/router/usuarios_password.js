var express = require('express');
var router = express.Router();

var mw = require('../model/middleware')

var usuarios_password = require('../model/usuarios_password')

//Router para /usuario_password/

// define the home page route
// router.get('/', mw.isLogged, usuarios_password.obtener);

router.post('/password-cambiar',        mw.isLogged,  usuarios_password.usuariospasswordCambiar);
router.post('/password-restablecer',                  usuarios_password.usuariospasswordRestablecer);
router.post('/password-mantenimiento',  mw.isLogged,  usuarios_password.usuariospasswordMantenimiento);

module.exports = router;