var moment     = require('moment')
  , api        = require('../api/index')
  , _          = require('lodash')
  , jwt        = require('jsonwebtoken')
  , config     = require('../util/config')
  , mail       = require('../util/mail')
  , async      = require('async')
  , fs         = require('fs')
  , path       = require('path')
  , nodemailer = require('nodemailer')
	;
  
var usuariospasswordCambiar = function(req, res) {
  var usuarioLogueado   = req.decoded ? req.decoded.usuario : 'undefined'
  var username          = req.body.username                  || 'soa'
  var empresa           = req.body.empresa                   || 'soa'
  var idusuario         = req.body.idusuario                 || ''
  var password          = req.body.password                  || ''
  var restablece        = req.body.restablece                || 0

  var response = {
    status : 0
  }

  if (!idusuario || idusuario === null || idusuario === undefined) {
    res.send({ status: 0, message: 'No esta mandando el usuario'})
    return
  }

  if (!password || password === null || password === undefined) {
    res.send({ status: 0, message: 'No esta mandando el usuario'})
    return
  }

  var query      = ` EXEC USP_seg_usuarios_password_cambiar @idusuario, @password, @restablece `
  var parameters = {}
  var isWhere    = false
  var aux        = ''
  var where      = []

  parameters.idusuario  = idusuario  || ''
  parameters.password   = password   || ''
  parameters.restablece = restablece || 0

  console.log('parameters:>>> ', parameters)

  api.sql.seg_usuarios_password.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
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

var usuariospasswordRestablecer = function(req, res) {
  var usuarioLogueado = req.decoded ? req.decoded.usuario : 'undefined'
  var username        = req.body.username                  || 'soa'
  var empresa         = req.body.empresa                   || 'soa'
  var usuario         = req.body.usuario                   || ''
  var restablece      = req.body.restablece                || 0

  var response = {
    status : 0
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
      console.log('data:>>> ', data)
      handlerusuariospasswordRestablecer(empresa, usuario, restablece, data, function(err, data) {
        if (err) {
          console.error('Error : ', err.message)
          response.message = err.message
          res.send(response)
          return
        } else {
          response.status = 1
          res.send(response)
        }
      })

      // NOTIFICACIONES EMAIL
      // var subject    = `${usuario}, Envio la solicitud con numero #${usuario}.`
      // var envioEmail = {
      //   nombreCreador: usuario,
      //   fecha        : moment(new Date()).format('DD/MM/YYYY HH:mm'),
      //   accion       : 'enviado a Almacen',
      //   motivoRechazo: '',
      //   empresa      : empresa,
      //   // image        : `${config.apiRoute}/statics/svg/aprobado.svg`,
      //   subject      : subject,
      //   bcc          : '',
      //   to           : 'desarrollador@patrol.com.pe, auditoria@patrol.com.pe'
      //   // to           : `${config[empresa].mails.sil.controldepedidos2}, ${dataUser.correo}`
      // }
      // sendEmailNotificacionUsuario(empresa, envioEmail)
    } else {
      response.message = 'El usuario no se encuentra en la base de datos.'
      res.send(response)
      return
    }

  })

}

var usuariospasswordMantenimiento = function(req, res) {
  var usuarioLogueado   = req.decoded ? req.decoded.usuario : 'undefined'
  var username          = req.body.username                  || 'soa'
  var empresa           = req.body.empresa                   || 'soa'
  var tipoaccion        = req.body.tipoaccion                || ''
  var idusuario         = req.body.idusuario                 || ''
  var password          = req.body.password                  || ''
  var restablece        = req.body.restablece                || 0

  var response = {
    status : 0
  }

  if (tipoaccion === 1 || tipoaccion === 2) {

    var obj = {
      tipo      : +tipoaccion,
      idusuario : idusuario,
      password  : password,
      restablece: restablece
    }
  
    console.log('obj:>>> ', obj)

    var query      = ` EXEC USP_seg_usuarios_password_mantenimiento @tipo, @idusuario, @password, @restablece `
    var parameters = {}
    var isWhere    = false
    var aux        = ''
    var where      = []
  
    parameters.tipo       = obj.tipo
    parameters.idusuario  = idusuario  || ''
    parameters.password   = password   || ''
    parameters.restablece = restablece || 0

    console.log('parameters:>>> ', parameters)

    api.sql.seg_usuarios_password.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
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
      api.sql.seg_usuarios_password.getOne(empresa, usuario.idusuario, function(err, found, usuarioEncontrado) {
        if (err) cb(err)
        else {
          if (usuarioEncontrado && usuarioEncontrado.idusuario) {
            var query             = ` EXEC USP_seg_usuarios_mantenimiento @tipo, @idusuario `
            var parameters        = {}
            parameters.tipo       = tipoaccion
            parameters.idusuario  = usuarioEncontrado.idusuario        
            // console.log('parameters:>>> ', parameters)
            api.sql.seg_usuarios_password.builtGet(empresa, query, parameters, function(error, cantidad, lista) {
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

var handlerusuariospasswordRestablecer = function(empresa, usuario, restablece, obj, callback) {
  var passwordTemporal = claveRandom(6)

  var query      = ` EXEC USP_seg_usuarios_password_cambiar @idusuario, @password, @restablece `
  var parameters = {}
  var isWhere    = false
  var aux        = ''
  var where      = []

  parameters.idusuario  = obj.idusuario
  parameters.password   = passwordTemporal
  parameters.restablece = restablece || 1

  api.sql.seg_usuarios_password.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
    if (err) {
      callback(err, null)
      return
    } else {
      sendEmailNotificacionUsuarioRestablecer(empresa, obj, passwordTemporal, function(err, data) {
        if (err) {
          callback(err, null)
          return
        } else {
          callback(null, null)
        }
      })
    }
  })
}

var sendEmailNotificacionUsuarioRestablecer = function(empresa, obj, passwordTemporal, callback) {
  var plataforma_link_aqui = '<bold><a href="https://localhost:8062/#/login">Aqui</a></bold>'
  var logoAux              = 'logo_soa.png'
  var logotipo             = ''
  if  (empresa) logotipo   = path.join(process.cwd(),'logo', logoAux)


  // ENVIO DE EMAIL
  var html = `
    <table border="0" cellspacing="0" cellpadding="0" width="100%" style="width:100.0%; background:#DFE5E9;">
      <tbody>
        <tr>
          <td style="padding:0cm 0cm 0cm 0cm;height:37.5pt"></td>
        </tr>
        <tr>
          <td style="padding:0cm 0cm 0cm 0cm">
            <table border="0" cellpadding="0" width="100%" style="width:100.0%;">
              <tbody>
                <tr>
                  <td style="padding:.75pt .75pt .75pt .75pt"></td>
                  <td width="468" style="width:351.0pt; padding:37.5pt 49.5pt 24.0pt 49.5pt; background:white;">
                <table border="0" cellspacing="0" cellpadding="0" width="100%" style="width:100.0%; word-wrap: break-word">
                  <tbody>
                    <tr>
                      <td style="background: #000e36; padding: 0cm; height: 45pt; text-align: center;">
                        <img src="cid:unique@openjavascript.info" width="200" alt="soa" />
                      </td>
                    </tr>
                    <tr>
                      <td style="padding:0cm 0cm 18.75pt 0cm"><p><br /></p><p>Hola, ${obj.nombre}:
                        <br />
                        <br />
                        Hemos recibido tu solicitud para restablecer la contraseña de inicio para la plataforma soa.
                        <br />
                        <br />
                        <strong>
                          Tu contraseña temporal es:
                          <br />
                          <div style="border:double; background:#2f3fb6; color:white; text-align:center;padding: 10px; font-size:20px; font-weight:700;border-radius:10px;">
                            <span> ${passwordTemporal} </span>
                          </div>
                        </strong>
                        <br />
                        Ingresa este código como contraseña en la pantalla de inicio de sesión de la plataforma, puedes hacerlo&nbsp; ${plataforma_link_aqui}.&nbsp;</p><p>
                        Seguidamente tendrás que especificar una nueva contraseña para poder continuar.</p>
                        <p>
                        </p><p>Atentamente,</p><p> Plataforma soa
                        <br /></p><p><br />
                        <span style="font-size: 10pt;"><span style="color: #ff0000;">Por favor no responder a este email. El buzón que generó este correo electrónico no se supervisa en busca de respuestas.</span></span>
                        <br />
                        <br />
                        <br />
                        <br />
                        <br />
                                  </p></td>
                              </tr>
                          </tbody></table>
                      </td>
                      <td style="padding:.75pt .75pt .75pt .75pt"></td>
                  </tr>
            </tbody>
          </table>
        </td>
      </tr>
      <tr>
        <td style="padding:0cm 0cm 0cm 0cm">
          <table border="0" cellspacing="0" cellpadding="0" width="100%" style="width:100.0%">
            <tbody>
              <tr>
              <!-- <td style='padding:12.0pt 0cm 0cm 0cm'> -->
                 <td>
                    <p align="center" style="text-align:center">
                      <span style="font-size:9.0pt">
                        © PATROL INNOVATIONS S.A.C. 2023. Todos los derechos reservados.
                      </span>
                    </p>
                  </td>
                </tr>
              <tr>
                <td style="padding:0cm 0cm 0cm 0cm;height:22.5pt"></td>
              </tr>
            </tbody>
          </table>
        </td>
      </tr>
    </tbody>
    </table>
`
  const transporter = nodemailer.createTransport({
    // usuario: soastereo@outlook.com
    // pwd: Insanos*2024
    // service: 'hotmail',
    // host: 'smtp.gmail.com',
    host  : 'smtp-mail.outlook.com',
    port  : 587,                  // 143, 110
    secure: false,
    auth  : {
      user: 'soastereo@outlook.com',
      pass: 'epqsrgibugqntuhx'
    },
    // tls: {
    //   rejectUnauthorized: false, // Acepta certificados auto-firmados o no verificados
    // },
  })

  let mailOptions = {
    from       : 'Soporte SOA <soastereo@outlook.com>',
    to         : obj.email,
    subject    : 'Se restablecio su contraseña',
    html       : html,
    attachments: [
      {
        filename: logoAux,
        path    : `./logo/${logoAux}`,
        cid     : 'unique@openjavascript.info'
      }
    ]
  };

   // Enviar el correo
   transporter.sendMail(mailOptions, function (error, info) {
    if (error) {
      console.log('Error al enviar el correo:', error);
    } else {
      console.log('Correo enviado con éxito:', info.response);
      console.log("Mensaje enviado: " + info.messageId)
      console.log("accepted enviado: " + info.accepted)
      console.log("rejected enviado: " + info.rejected)
    }
  });

  callback(null, null)
}

function claveRandom(length) {
  let   result           = ''
  const characters       = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
  const charactersLength = characters.length
  let   counter          = 0;
  while (counter < length) {
    result  += characters.charAt(Math.floor(Math.random() * charactersLength));
    counter += 1;
  }
  return result;
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

exports.usuariospasswordCambiar       = usuariospasswordCambiar
exports.usuariospasswordRestablecer   = usuariospasswordRestablecer
exports.usuariospasswordMantenimiento = usuariospasswordMantenimiento