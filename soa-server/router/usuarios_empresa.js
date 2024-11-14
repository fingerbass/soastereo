var express          = require('express');
var router           = express.Router();
var mw               = require('../model/middleware')
var usuarios_empresa = require('../model/usuarios_empresa')

//Router para /usuarios_empresa/
// define the home page route
// router.get('/', mw.isLogged, usuarios_empresa.obtener);
router.get('/lista',            mw.isLogged,  usuarios_empresa.usuariosempresaLista);
router.get('/lista-idempresa',  mw.isLogged,  usuarios_empresa.usuariosempresaListaIdEmpresa);
router.get('/lista-idusuario',  mw.isLogged,  usuarios_empresa.usuariosempresaListaIdUsuario);
router.post('/mantenimiento',   mw.isLogged,  usuarios_empresa.usuariosempresaMantenimiento);

module.exports = router;