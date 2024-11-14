var moment = require('moment')
  , api    = require('../api/index')
  , _      = require('lodash')
  , jwt    = require('jsonwebtoken')
  , config = require('../util/config')
  , mail   = require('../util/mail')
  , async  = require('async')
  , fs     = require('fs')
	;

var seg_log_actividades = require('./log_actividades')

// var stream = fs.createReadStream('xml/bigxmlfile.xml');

const { createHash } = require('crypto');

// Crear una cadena hash
function hash(str) {
  return createHash('sha512').update(str).digest('hex');
}

// // Comparar las dos contraseñas hasheadas
// let password = 'mi-password';
// const hash1 = hash(password);
// console.log(hash1)

// /// ... en alguna otra parte del código
// password = 'mi-password';
// const hash2 = hash(password);
// const match = hash1 === hash2;

// console.log(match ? 'Exitoso, contraseña son iguales' : 'Error, contraseñas no son iguales');

var obtener = function (req, res) {

  var selectApp = {}

	api.sql.usuario.get(selectApp, function(err, cantidad, lista) {
		if (err) {
			res.send({ status: 0, message: err.message})
			return
		}

		res.send({
			status: 1,
			cantidad : cantidad,
			lista : lista
		})
	})
}

var login = function(req, res){

  var empresa  = req.body.empresa
  var usuario  = req.body.username
  var password = req.body.password

  console.log('empresa: ',  empresa)
  console.log('usuario: ',  usuario)
  console.log('password: ', password)
  
  var response = {
    status: 0
  }

  if (!usuario || !password) {
    response.message = 'Alguno de los campos se encuentran vacios'
    res.send(response)
    return
  }

  api.sql.seg_usuarios.getOneUsuario(empresa, usuario, function(err, found, data) {
    // console.log('getOneUsuario.usuario', data)
    if (err) {
      console.error('Error : ', err.message)
      response.message = err.message
      res.send(response)
      return
    }
    
    if (found) {      

      const passwordIngresado = hash(password);
      
      // console.log('passwordIngresado ', passwordIngresado)
      // console.log('data.password: ', data.password)

      // var passwordOriginal = new Buffer(data.password, 'base64')
      // var passwordOriginal = new Buffer(data.password, 'hex')
      var passwordOriginal = new Buffer(data.password, 'uft8')
      var passwordOriginal = data.password.toString('hex')
      // console.log('passwordOriginal: ', passwordOriginal)
      
      if (passwordOriginal !== passwordIngresado) {
        response.message = 'La usuarios o contaseña ingresada es incorrecta.'
        res.send(response)
        return
      }

      if (!data.activo) {
        response.message = 'Usuario inactivo, no puede ingresar.'
        res.send(response)
        return
      }

      var objetoUsuario = {
        idusuario      : data.idusuario,
        paterno        : data.paterno,
        materno        : data.materno,
        nombre         : data.nombre,
        documento      : data.documento,
        login          : data.login,
        email          : data.email,
        movil          : data.movil,
        ultimoingreso  : data.ultimoingreso,
        cambioclave    : data.cambioclave,
        administrador  : data.administrador || false,
        activo         : data.activo,
        usuarioregistro: data.usuarioregistro,
        fecharegistro  : data.fecharegistro
      }

      // JSON WEB TOKENS
      var token = jwt.sign(objetoUsuario, config.secret)

      objetoUsuario.foto = data.foto ? data.foto.toString() : 'https://e7.pngegg.com/pngimages/309/800/png-clipart-user-profile-computer-icons-avatar-heroes-black.png'

      if (data.administrador) {
        response = {
          empresa        : empresa,
          // empresaNombre  : empresaNombre,
          token                   : token,
          idusuario               : objetoUsuario.idusuario,
          paterno                 : objetoUsuario.paterno,
          materno                 : objetoUsuario.materno,
          nombre                  : objetoUsuario.nombre,
          documento               : objetoUsuario.documento,
          login                   : objetoUsuario.login,
          email                   : objetoUsuario.email,
          movil                   : objetoUsuario.movil,
          ultimoingreso           : objetoUsuario.ultimoingreso,
          cambioclave             : objetoUsuario.cambioclave,
          administrador           : objetoUsuario.administrador,
          activo                  : objetoUsuario.activo,
          foto                    : objetoUsuario.foto,
          usuarioregistro         : objetoUsuario.usuarioregistro,
          fecharegistro           : objetoUsuario.fecharegistro,
          data                    : token,
          username                : objetoUsuario.login
        }

        response.status = 1
        res.send(response)
      } else {
        response = {
          empresa                 : empresa,
          token                   : token,
          idusuario               : objetoUsuario.idusuario,
          paterno                 : objetoUsuario.paterno,
          materno                 : objetoUsuario.materno,
          nombre                  : objetoUsuario.nombre,
          documento               : objetoUsuario.documento,
          login                   : objetoUsuario.login,
          email                   : objetoUsuario.email,
          movil                   : objetoUsuario.movil,
          ultimoingreso           : objetoUsuario.ultimoingreso,
          cambioclave             : objetoUsuario.cambioclave,
          administrador           : objetoUsuario.administrador,
          activo                  : objetoUsuario.activo,
          foto                    : objetoUsuario.foto,
          usuarioregistro         : objetoUsuario.usuarioregistro,
          fecharegistro           : objetoUsuario.fecharegistro,
          data                    : token,
          username                : objetoUsuario.login
        }

        response.status = 1
        res.send(response)
      }

      handlersegusuariosUltimoingresoCambiar(empresa, data.idusuario, function(err, data) {
        if (err) { console.log('handlersegusuariosUltimoingresoCambiar:>>> ', err) }
      })

    } else {
      response.message = 'El usuario no se encuentra en nuestra base de datos.'
      res.send(response)
      return
    }
  })
};

var getInfo = function(req, res) {
  console.log('getInfo')
  var empresa   = req.query.empresa
  var username  = req.query.username
  var idusuario = req.query.idusuario
  var token     = req.query.token

  // const info  = users[token]

  // console.log('token:>>>', token)

  var response = {
    status : 0
  }

  // if (!token) {
  //   res.send({ status: 0, message: 'Error de inicio de sesión, no se pueden obtener los detalles del usuario.'})
  //   return
  // }

  // var data = {
  //   roles       : ['ADMINISTRADOR'],
  //   introduction: 'Soy un super administrador.',
  //   avatar      : 'https://e7.pngegg.com/pngimages/309/800/png-clipart-user-profile-computer-icons-avatar-heroes-black.png',
  //   name        : 'Super Admin'
  // }

  // response.status = 1
  // response.token  = token
  // response.data   = data
  // res.send(response)

  api.sql.seg_usuarios.getOne(empresa, idusuario, function(err, isFound, data) {
    // console.log('data:>>> ')
    if (err) {
      response.message = err.message
      res.send(response)
      return
    }

    // console.log('data:>>> ', data)

    if (isFound) {

      var data = {
        roles          : [],
        introduction   : '',
        name           : '',
        idusuario      : data.idusuario,
        paterno        : data.paterno,
        materno        : data.materno,
        nombre         : data.nombre,
        idtipodocumento: data.idtipodocumento,
        documento      : data.documento,
        login          : data.login,
        email          : data.email,
        movil          : data.movil,
        ultimoingreso  : data.ultimoingreso,
        cambioclave    : data.cambioclave,
        administrador  : data.administrador,
        activo         : data.activo,
        foto           : data.foto ? data.foto.toString() : '',
        avatar         : data.foto ? data.foto.toString() : 'https://e7.pngegg.com/pngimages/309/800/png-clipart-user-profile-computer-icons-avatar-heroes-black.png'
      }

      if (data.administrador) {
        data.roles        = ['ADMINISTRADOR']
        data.name         = 'ADMINISTRADOR'
        data.introduction = 'SOY UN SUPER ADMINISTRADOR'
  
        response.status = 1
        response.token  = token
        response.data   = data
        res.send(response)
      } else {
        handlerusuariosempresaListaIdUsuario(empresa, data.idusuario, function(err, listaEmpresa) {
          if (err) {
            console.error('Error : ', err.message)
            response.message = err.message
            res.send(response)
            return
          } else {
            // console.log('listaEmpresa getinfo:>>> ', listaEmpresa)

            if (listaEmpresa && listaEmpresa.length >= 1) {
              var rolesAux = []
              for (let i = 0; i < listaEmpresa.length; i++) {
                const element = listaEmpresa[i]
                // data.name = element.rol
                rolesAux.push(element.rol)
              }
              // console.log('rolesAux:>>> ', rolesAux)
              data.roles        = rolesAux
              data.name         = rolesAux[0]
              data.introduction = `SOY UN CONSULTOR ${rolesAux[0]}`

              response.status = 1
              response.token  = token
              response.data   = data
              res.send(response)
            } else {
              // data.roles        = ['CONSULTOR']
              // data.name         = 'CONSULTOR'
              // data.introduction = 'SOY UN CONSULTOR'

              // response.status = 1
              // response.token  = token
              // response.data   = data
              // res.send(response)

              response.message = 'Error no tiene roles ni es administrador.'
              res.send(response)
              return
            }

          }
        })
      }

    } else {
      response.message = 'No esta registrado el usuario en la base de datos.'
      res.send(response)
      return
    }

  })

}

var postLogout = function(req, res) {
  // var token = req.body.token
  // console.log('token:>>>', token)

  var response = {
    status : 0
  }

  // if (!token) {
  //   res.send({ status: 0, message: 'Error de inicio de sesión, no se pueden obtener los detalles del usuario.'})
  //   return
  // }

  response.status = 1
  // response.token  = token
  res.send(response)
}

var getMenu =  function(req, res) {

  var perfil  = req.decoded.perfil

  var response = {
    status : 0
  }

  var obj = []

  if (perfil === '01') {
    obj  = addMenuItem(obj, 'Dashboard')
  }

  response.status = 1
  response.menu   = obj
  res.send(response)
}

var addMenuItem = function (menu, item) {
  var aux  = {}
  if (item === 'Colaboradores') {
    aux = {
      key : 'colaboradores',
      name: 'Colaboradores',
      path: '/',
      icon: 'fa-home'
    }
  }

  if (aux.key) menu.push(aux)
  return menu
}

// MANTENIMIENTO DE USUARIOS
var usuariosLista = function(req, res) {
  var usuarioLogueado   = req.decoded ? req.decoded.usuario : 'undefined'
  var empresa           = req.query.empresa           || 'soa'
  var idestado          = req.query.idestado          || 2
  var sortByName        = req.query.sortByName        || 'idusuario'
  var sortByType        = req.query.sortByType        || 'ASC'
  var ultimoRecnum      = req.query.ultimoRecnum      || 0
  var cantidadRegistros = req.query.limit             || 50
  var pagination        = req.query.pagination        || 1
  var textSearch        = req.query.textSearch
  var isExcel           = false

  var query      = ` EXEC USP_seg_usuarios_lista @idestado `

	var parameters = {}
	var isWhere    = false
	var aux        = ''
	var where      = []

	parameters.idestado = +idestado

  var response = {
    status : 0
  }

  // console.log('empresa:>>> ', empresa)
  // console.log('query:>>> ', query)
  // console.log('parameters:>>> ', parameters)

	api.sql.seg_usuarios.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
		if (err) {
			res.send({ status: 0, message: err.message})
			return
		}

    if (lista.length < cantidadRegistros) response.noMore = true
    else {
      if (ultimoRecnum === lista[lista.length -1].ultimoRecnum) response.noMore = true
      else response.ultimoRecnum = +ultimoRecnum + +cantidadRegistros
    }

    // console.log('lista:>>> ', lista[0])
    // console.log('lista[0].foto:>>> ', lista[0].foto)
    
    // var passwordOriginal = new Buffer(lista[0].foto, 'base64')
    // var passwordOriginal = new Buffer(lista[0].foto, 'hex')
    // var passwordOriginal = new Buffer(lista[0].foto, 'uft8')
    // var passwordOriginal = lista[0].foto.toString('hex')
    // console.log('passwordOriginal:>>> ', passwordOriginal)
    
    // var o = Buffer.from(lista[0].foto, 'base64').toString('ascii')
    // console.log('o:>>> ', o)
    // var base64String = Buffer.from(lista[0].foto).toString('base64')
    // console.log('base64String:>>> ', base64String)
    // const withPrefix = 'data:image/jpeg;base64,' + base64String;
    // console.log('withPrefix:>>> ', withPrefix)

    // var o = lista[0].foto.toString('base64')
    // console.log('o:>>> ', o)

    // var buff = new Buffer(lista[0].foto, 'base64')
    // let base64data = buff.toString('base64')
    // console.log('buff:>>> ', buff)
    // console.log('"' + lista[0].foto + '" converted to Base64 is "' + base64data + '"');

    for (let i = 0; i < lista.length; i++) {
      if (lista[i].foto) {
        lista[i].foto = lista[i].foto.toString()
        // lista[i].foto = lista[i].foto.toString('base64')
      }
    }

    let mockList = lista
  
    if (sortByName === '-idusuario') {
      mockList = mockList.reverse()
    }

    const pageList = mockList.filter((item, index) => index < cantidadRegistros * pagination && index >= cantidadRegistros * (pagination - 1))
    // console.log('pageList:>>> ', pageList)

    response.status   = 1
    response.cantidad = cantidad
    response.lista    = pageList
    res.send(response)
		
	})
}

var usuariosListaCompleto = function(req, res) {
  var usuarioLogueado   = req.decoded ? req.decoded.usuario : 'undefined'
  var empresa           = req.query.empresa           || 'soa'
  var idestado          = req.query.idestado          || 2
  var sortByName        = req.query.sortByName        || 'idusuario'
  var sortByType        = req.query.sortByType        || 'ASC'
  var ultimoRecnum      = req.query.ultimoRecnum      || 0
  var cantidadRegistros = req.query.limit
  var pagination        = req.query.pagination        || 1
  var textSearch        = req.query.textSearch
  var isExcel           = false

  var query      = ` EXEC USP_seg_usuarios_lista @idestado `

	var parameters = {}
	var isWhere    = false
	var aux        = ''
	var where      = []

	parameters.idestado = +idestado

  var response = {
    status : 0
  }

  // console.log('empresa:>>> ', empresa)
  // console.log('query:>>> ', query)
  // console.log('parameters:>>> ', parameters)

	api.sql.seg_usuarios.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
		if (err) {
			res.send({ status: 0, message: err.message})
			return
		}

    for (let i = 0; i < lista.length; i++) {
      if (lista[i].foto) {
        lista[i].foto = lista[i].foto.toString()
      }
    }

    response.status   = 1
    response.cantidad = cantidad
    response.lista    = lista
    res.send(response)
		
	})
}

var usuariosListaIdUsuario = function(req, res) {
  var usuarioLogueado   = req.decoded ? req.decoded.usuario : 'undefined'
  var empresa           = req.query.empresa           || 'soa'
  var idusuario         = req.query.idusuario         || 2
  var sortByName        = req.query.sortByName        || 'idusuario'
  var sortByType        = req.query.sortByType        || 'ASC'
  var ultimoRecnum      = req.query.ultimoRecnum      || 0
  var cantidadRegistros = req.query.limit
  var pagination        = req.query.pagination        || 1
  var textSearch        = req.query.textSearch
  var isExcel           = false

  var query      = ` EXEC USP_seg_usuarios_lista_idusuario @idusuario `

	var parameters = {}
	var isWhere    = false
	var aux        = ''
	var where      = []

	parameters.idusuario = +idusuario

  var response = {
    status : 0
  }

  // console.log('empresa:>>> ', empresa)
  // console.log('query:>>> ', query)
  // console.log('parameters:>>> ', parameters)

	api.sql.seg_usuarios.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
		if (err) {
			res.send({ status: 0, message: err.message})
			return
		}

    for (let i = 0; i < lista.length; i++) {
      if (lista[i].foto) {
        lista[i].foto = lista[i].foto.toString()
      }
    }

    response.status   = 1
    response.cantidad = cantidad
    response.lista    = lista
    res.send(response)
		
	})
}

var usuariosempresaLista = function(req, res) {
  var usuarioLogueado   = req.decoded ? req.decoded.usuario : 'undefined'
  var empresa           = req.query.empresa           || 'soa'
  var idestado          = req.query.idestado          || 2
  var sortByName        = req.query.sortByName        || 'idusuario'
  var sortByType        = req.query.sortByType        || 'ASC'
  var ultimoRecnum      = req.query.ultimoRecnum      || 0
  var cantidadRegistros = req.query.limit
  var pagination        = req.query.pagination        || 1
  var textSearch        = req.query.textSearch
  var isExcel           = false

  var query      = ` EXEC USP_seg_usuarios_empresa_lista `

	var parameters = {}
	var isWhere    = false
	var aux        = ''
	var where      = []

  var response = {
    status : 0
  }

  // console.log('empresa:>>> ', empresa)
  // console.log('query:>>> ', query)
  // console.log('parameters:>>> ', parameters)

	api.sql.seg_usuarios.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
		if (err) {
			res.send({ status: 0, message: err.message})
			return
		}

    response.status   = 1
    response.cantidad = cantidad
    response.lista    = lista
    res.send(response)
		
	})
}

var handlerusuariosempresaListaIdEmpresa = function(empresa, idempresa, callback) {
  
 var query           = ` EXEC USP_seg_usuarios_empresa_lista_idempresa @idempresa `
 var parameters      = {}
 var isWhere         = false
 var aux             = ''
 var where           = []
 var arregloAuxiliar = []
  
  var response = {
    status : 0
  }

  parameters.idempresa = idempresa

  console.log('empresa:>>> ', empresa)
  console.log('query:>>> ', query)
  console.log('parameters:>>> ', parameters)

	api.sql.seg_usuarios.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
    if (err) {
      callback(new Error(err.message));
      return;
    }

    callback(null, lista)
	})
}

var handlerusuariosempresaListaIdUsuario = function(empresa, idusuario, callback) {
    
 var query           = ` EXEC USP_seg_usuarios_empresa_lista_idusuario @idusuario `
 var parameters      = {}
 var isWhere         = false
 var aux             = ''
 var where           = []
 var arregloAuxiliar = []

  parameters.idusuario = idusuario

  // console.log('empresa:>>> ', empresa)
  // console.log('query:>>> ', query)
  // console.log('parameters:>>> ', parameters)

	api.sql.seg_usuarios.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
    if (err) {
      callback(new Error(err.message));
      return;
    } else {

      // console.log('lista:>>> ', lista)
  
      if (lista && lista.length > 0) {
        for (let i = 0; i < lista.length; i++) {
          if (lista[i].logo) {
            lista[i].logo = lista[i].logo.toString()
          }
          if (lista[i].isotipo) {
            lista[i].isotipo = lista[i].isotipo.toString()
          }
        }
      }
  
      // console.log('lista:>>> ', lista)
  
      callback(null, lista)
    }
	})
}

var handlerserviciosempresaListaIdServicio = function(empresa, idservicio, callback) {
    
 var query           = ` EXEC USP_adm_servicios_empresa_lista_idservicio @idservicio `
 var parameters      = {}
 var isWhere         = false
 var aux             = ''
 var where           = []
 var arregloAuxiliar = []
  
  parameters.idservicio = idservicio

  // console.log('empresa:>>> ', empresa)
  // console.log('query:>>> ', query)
  // console.log('parameters:>>> ', parameters)

	api.sql.adm_servicios_empresa.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
    if (err) {
      callback(new Error(err.message));
      return;
    }

    callback(null, lista)
	})
}

var handlerserviciosempresaListaIdUsuario = function(empresa, idusuario, callback) {
    
 var query           = ` EXEC USP_adm_servicios_empresa_lista_idusuario @idusuario `
 var parameters      = {}
 var isWhere         = false
 var aux             = ''
 var where           = []
 var arregloAuxiliar = []
  
  parameters.idusuario = idusuario

  // console.log('empresa:>>> ', empresa)
  // console.log('query:>>> ', query)
  // console.log('parameters:>>> ', parameters)

	api.sql.adm_servicios_empresa.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
    if (err) {
      callback(new Error(err.message));
      return;
    }

    // console.log('lista:>>> ', lista)

    if (lista && lista.length > 0) {
      for (let i = 0; i < lista.length; i++) {
        if (lista[i].isotipo) {
          lista[i].isotipo = lista[i].isotipo.toString()
        }
      }
    }

    // console.log('lista:>>> ', lista)

    callback(null, lista)
	})
}

var handlerserviciosempresaListaIdEmpresa = function(empresa, idempresa, callback) {
    
 var query           = ` EXEC USP_adm_servicios_empresa_lista_idempresa @idempresa `
 var parameters      = {}
 var isWhere         = false
 var aux             = ''
 var where           = []
 var arregloAuxiliar = []

  parameters.idempresa = idempresa

  // console.log('empresa:>>> ', empresa)
  // console.log('query:>>> ', query)
  // console.log('parameters:>>> ', parameters)

	api.sql.adm_servicios_empresa.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
    if (err) {
      callback(new Error(err.message));
      return;
    }

    // console.log('lista:>>> ', lista)

    if (lista && lista.length > 0) {
      for (let i = 0; i < lista.length; i++) {
        if (lista[i].isotipo) {
          lista[i].isotipo = lista[i].isotipo.toString()
        }
      }
    }

    // console.log('lista:>>> ', lista)

    callback(null, lista)
	})
}

var handlersegusuariosUltimoingresoCambiar = function(empresa, idusuario, callback) {
  var query      = ` EXEC USP_seg_usuarios_ultimoingreso_cambiar @idusuario `
  var parameters = {}
  var isWhere    = false
  var aux        = ''
  var where      = []

  parameters.idusuario  = idusuario

  api.sql.seg_usuarios_password.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
    if (err) {
      callback(err, null)
      return
    } else {
      callback(null, null)
    }
  })
}

var usuariosMantenimiento = function(req, res) {
  var usuarioLogueado   = req.decoded ? req.decoded.usuario : 'undefined'
  var username          = req.body.username                  || 'soa'
  var empresa           = req.body.empresa                   || 'soa'
  var idestado          = req.body.idestado                  || 2
  var arreglousuario    = req.body.arreglousuario             || []
  var tipoaccion        = req.body.tipoaccion                || []
  var sortByName        = req.body.sortByName                || 'idusuario'
  var sortByType        = req.body.sortByType                || 'ASC'
  var ultimoRecnum      = req.body.ultimoRecnum              || 0
  var cantidadRegistros = req.body.limit || 50
  var pagination        = req.body.pagination                || 1
  var textSearch        = req.body.textSearch
  var isExcel           = false

  var response = {
    status : 0
  }

  if (tipoaccion === 1) {

    var obj = {
      tipo           : +tipoaccion,
      idusuario      : arreglousuario.idusuario,
      paterno        : arreglousuario.paterno,
      materno        : arreglousuario.materno,
      nombre         : arreglousuario.nombre,
      idtipodocumento: arreglousuario.idtipodocumento,
      documento      : arreglousuario.documento,
      login          : arreglousuario.login,
      password       : arreglousuario.password,
      email          : arreglousuario.email,
      movil          : arreglousuario.movil,
      ultimoingreso  : arreglousuario.ultimoingreso,
      cambioclave    : arreglousuario.cambioclave,
      administrador  : arreglousuario.administrador,
      activo         : arreglousuario.activo,
      foto           : arreglousuario.foto,
      usuarioregistro: arreglousuario.usuarioregistro,
      fecharegistro  : arreglousuario.fecharegistro
    }
  
    // console.log('obj:>>> ', obj)

    var query      = ` EXEC USP_seg_usuarios_mantenimiento @tipo, @idusuario, @paterno, @materno, @nombre, @idtipodocumento, @documento, @login, @password, @email, @administrador, @movil, @activo, @usuarioregistro, @foto `
    var parameters = {}
    var isWhere    = false
    var aux        = ''
    var where      = []
  
    parameters.tipo            = obj.tipo
    parameters.idusuario       = obj.idusuario        || 0
    parameters.paterno         = obj.paterno          || ''
    parameters.materno         = obj.materno          || ''
    parameters.nombre          = obj.nombre           || ''
    parameters.idtipodocumento = obj.idtipodocumento  || ''
    parameters.documento       = obj.documento        || ''
    parameters.email           = obj.email            || ''
    parameters.movil           = obj.movil            || ''
    parameters.administrador   = obj.administrador === false ? 0 : 1
    parameters.activo          = obj.activo        === false ? 0 : 1
    parameters.usuarioregistro = obj.usuarioregistro  || username
    parameters.foto            = Buffer.from(obj.foto || '', 'utf8')
    
    if (tipoaccion === 1) {
      parameters.login           = obj.login            || ''
      parameters.password        = obj.password         || ''
    }
    
    // const toBytes = (string) => Array.from(Buffer.from(string, 'utf8'));
    // const bytes = toBytes('pepito');
    // const buffer = Buffer.from(string, 'utf8'); 
    // const buffer = Buffer.from(string, 'utf16le');
    // parameters.foto            = Buffer.from(obj.foto || '', 'ascii')
    // parameters.foto            = Buffer.from(obj.foto || '', 'utf16le')
    // parameters.foto            = Buffer.from(obj.foto || '', 'utf8')
    // parameters.foto            = Buffer.from(obj.foto || '', 'binary')

    console.log('parameters:>>> ', parameters)

    api.sql.seg_usuarios.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
      if (err) {
        res.send({ status: 0, message: err.message})
        return
      }

      response.status   = 1
      response.cantidad = cantidad
      response.lista    = lista
      res.send(response)
    })

  } else if (tipoaccion === 2) {

    // console.log('<>>>>>>>')

    var obj = {
      tipo           : +tipoaccion,
      idusuario      : arreglousuario.idusuario,
      paterno        : arreglousuario.paterno,
      materno        : arreglousuario.materno,
      nombre         : arreglousuario.nombre,
      idtipodocumento: arreglousuario.idtipodocumento,
      documento      : arreglousuario.documento,
      login          : arreglousuario.login,
      password       : arreglousuario.password,
      email          : arreglousuario.email,
      movil          : arreglousuario.movil,
      ultimoingreso  : arreglousuario.ultimoingreso,
      cambioclave    : arreglousuario.cambioclave,
      administrador  : arreglousuario.administrador,
      activo         : arreglousuario.activo,
      foto           : arreglousuario.foto,
      usuarioregistro: arreglousuario.usuarioregistro,
      fecharegistro  : arreglousuario.fecharegistro
    }
  
    console.log('obj:>>> ', obj)

    var query      = ` EXEC USP_seg_usuarios_mantenimiento @tipo, @idusuario, @paterno, @materno, @nombre, @idtipodocumento, @documento, @login, @password, @email, @movil, @administrador, @activo, @usuarioregistro, @foto `
    var parameters = {}
    var isWhere    = false
    var aux        = ''
    var where      = []
  
    parameters.tipo            = obj.tipo
    parameters.idusuario       = obj.idusuario        || 0
    parameters.paterno         = obj.paterno          || ''
    parameters.materno         = obj.materno          || ''
    parameters.nombre          = obj.nombre           || ''
    parameters.idtipodocumento = obj.idtipodocumento  || ''
    parameters.documento       = obj.documento        || ''
    parameters.login           = ''
    parameters.password        = ''
    parameters.email           = obj.email            || ''
    parameters.movil           = obj.movil            || ''
    parameters.administrador   = obj.administrador === false ? 0 : 1
    parameters.activo          = obj.activo        === false ? 0 : 1
    parameters.usuarioregistro = ''
    parameters.foto            = Buffer.from(obj.foto || '', 'utf8')
    
    
    // const toBytes = (string) => Array.from(Buffer.from(string, 'utf8'));
    // const bytes = toBytes('pepito');
    // const buffer = Buffer.from(string, 'utf8'); 
    // const buffer = Buffer.from(string, 'utf16le');
    // parameters.foto            = Buffer.from(obj.foto || '', 'ascii')
    // parameters.foto            = Buffer.from(obj.foto || '', 'utf16le')
    // parameters.foto            = Buffer.from(obj.foto || '', 'utf8')
    // parameters.foto            = Buffer.from(obj.foto || '', 'binary')

    console.log('query:>>> ', query)
    console.log('parameters:>>> ', parameters)

    api.sql.seg_usuarios.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
      if (err) {
        res.send({ status: 0, message: err.message})
        return
      }

      response.status   = 1
      response.cantidad = cantidad
      response.lista    = lista
      res.send(response)
    })

  } else if (tipoaccion === 3) {
    async.eachSeries(arreglousuario, function(usuario, cb) {
      api.sql.seg_usuarios.getOne(empresa, usuario.idusuario, function(err, found, usuarioEncontrado) {
        if (err) cb(err)
        else {
          if (usuarioEncontrado && usuarioEncontrado.idusuario) {
            var query             = ` EXEC USP_seg_usuarios_mantenimiento @tipo, @idusuario `
            var parameters        = {}
            parameters.tipo       = tipoaccion
            parameters.idusuario  = usuarioEncontrado.idusuario        
            // console.log('parameters:>>> ', parameters)
            api.sql.seg_usuarios.builtGet(empresa, query, parameters, function(error, cantidad, lista) {
              if (err) cb(err)
              else {
                cb()
              }
            })
          }
        }
      })
    }, function (err) {
      if (err) {
        console.error('err.message', err.message)
        response.message = err.message
        res.send(response)
      } else {
        response.status = 1
        res.send(response)
      }
    })
  } else {
    res.send({ status: 0, message: 'Seleccione el tipo de accion correspondiente.'})
    return
  }
}

var sendEmailNotificacionUsuario = function(empresa, obj) {
  var mailObj = {
    template: 'notificacion_enviar',
    subject : obj.subject,
    data    : obj,
    to      : obj.to,
    bcc     : '',
    prefix  : '[soa]'
  }
  mail.send(empresa, mailObj)
}

exports.obtener                = obtener
exports.login                  = login
exports.getInfo                = getInfo
exports.postLogout             = postLogout
exports.getMenu                = getMenu

exports.usuariosLista          = usuariosLista
exports.usuariosListaCompleto  = usuariosListaCompleto
exports.usuariosListaIdUsuario = usuariosListaIdUsuario
exports.usuariosempresaLista   = usuariosempresaLista
exports.usuariosMantenimiento  = usuariosMantenimiento