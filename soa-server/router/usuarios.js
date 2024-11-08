var express = require('express');
var router = express.Router();

var mw = require('../model/middleware')

var usuarios = require('../model/usuarios')

//Router para /usuario/

// define the home page route
// router.get('/', mw.isLogged, usuarios.obtener);
router.post('/',                              usuarios.login);
router.get('/menu',             mw.isLogged,  usuarios.getMenu);
router.get('/info',                           usuarios.getInfo);
router.post('/logout',                        usuarios.postLogout);

router.get('/lista',            mw.isLogged,  usuarios.usuariosLista);
router.get('/lista-completo',   mw.isLogged,  usuarios.usuariosListaCompleto);
router.get('/lista-idusuario',  mw.isLogged,  usuarios.usuariosListaIdUsuario);
router.post('/mantenimiento',   mw.isLogged,  usuarios.usuariosMantenimiento);

module.exports = router;