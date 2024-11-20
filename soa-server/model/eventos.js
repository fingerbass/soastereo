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

// MANTENIMIENTO DE EVENTOS
var eventosLista = function(req, res) {
  var usuarioLogueado   = req.decoded ? req.decoded.usuario : 'undefined'
  var empresa           = req.query.empresa           || 'soa'
  var idestado         = req.query.idestado          || 2
  var sortByName       = req.query.sortByName        || 'id'
  var sortByType       = req.query.sortByType        || 'ASC'
  var ultimoRecnum     = req.query.ultimoRecnum      || 0
  var cantidadRegistros = req.query.limit
  var pagination       = req.query.pagination        || 1
  var textSearch       = req.query.textSearch
  var isExcel         = false

  var query = ` EXEC USP_adm_eventos_lista @idestado`

  var parameters = {}
  var isWhere = false
  var aux = ''
  var where = []

  parameters.idestado = +idestado

  var response = {
    status: 0
  }

  api.sql.adm_eventos.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
    if (err) {
      res.send({ status: 0, message: err.message})
      return
    }
    console.log('lista', lista)
    if (lista.length < cantidadRegistros) response.noMore = true
    else {
      if (ultimoRecnum === lista[lista.length -1].ultimoRecnum) response.noMore = true
      else response.ultimoRecnum = +ultimoRecnum + +cantidadRegistros
    }

    let mockList = lista
    if (sortByName === '-id') {
      mockList = mockList.reverse()
    }

    var pageList = []
    if (cantidadRegistros) {
      pageList = mockList.filter((item, index) => index < cantidadRegistros * pagination && index >= cantidadRegistros * (pagination - 1))
    }

    response.status = 1
    response.cantidad = cantidad
    response.lista = cantidadRegistros ? pageList : lista
    res.send(response)
  })
}

var eventosMantenimiento = function(req, res) {
  var usuarioLogueado = req.decoded ? req.decoded.usuario : 'undefined'
  var username        = req.body.username || 'soa'
  var idusuario       = req.body.idusuario || 'soa'
  var empresa         = req.body.empresa || 'soa'
  var tipoaccion      = req.body.tipoaccion
  var evento          = req.body.evento || {}

  var response = {
    status: 0
  }

  if (tipoaccion === 1 || tipoaccion === 2) {
    var obj = {
      tipo: +tipoaccion,
      id: evento.id,
      nombre: evento.nombre,
      fecha: evento.fecha,
      lugar: evento.lugar,
      descripcion: evento.descripcion,
      estado: evento.estado || 'PENDIENTE',
      costo_total: evento.costo_total || 0,
      usuarioregistro: evento.usuarioregistro || username
    }

    var query = ` EXEC USP_adm_eventos_mantenimiento 
      @tipo, @id, @nombre, @fecha, @lugar, @descripcion, 
      @estado, @costo_total, @usuarioregistro`

    var parameters = {}
    parameters.tipo = obj.tipo
    parameters.id = obj.id
    parameters.nombre = obj.nombre
    parameters.fecha = obj.fecha
    parameters.lugar = obj.lugar
    parameters.descripcion = obj.descripcion
    parameters.estado = obj.estado
    parameters.costo_total = obj.costo_total
    parameters.usuarioregistro = obj.usuarioregistro

    api.sql.adm_eventos.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
      if (err) {
        res.send({ status: 0, message: err.message})
        return
      }

      if (+tipoaccion === 1) {
        handlerValidarAdministradores(empresa, idusuario, function(err, data) {
          if (err) {
            res.send({ status: 0, message: err.message})
            return
          }
  
  
        })
      }

      response.status = 1
      response.cantidad = cantidad
      response.lista = lista
      res.send(response)
    })
  } 
  else if (tipoaccion === 3) {
    var query = ` EXEC USP_adm_eventos_mantenimiento @tipo, @id `
    var parameters = {}
    parameters.tipo = tipoaccion
    parameters.id = evento.id

    api.sql.adm_eventos.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
      if (err) {
        res.send({ status: 0, message: err.message})
        return
      }
      response.status = 1
      res.send(response)
    })
  } 
  else {
    res.send({ status: 0, message: 'Seleccione el tipo de acción correspondiente.'})
    return
  }
}

var handlerValidarAdministradores = function(empresa, idusuario, callback) {
  
  var query      = ` SELECT * FROM seg_usuarios WHERE administrador = @administrador`
  var parameters = {}
  var isWhere    = false
  var aux        = ''
  var where      = []

  parameters.administrador = 1

  api.sql.seg_usuarios.builtGet(empresa, query, parameters, function(err, cantidad, lista) {
    if (err) {
      callback(err)
    } else {
      console.log('lista', lista)
      for (let i = 0; i < lista.length; i++) {
        sendEmailNotificacionAdministrador(empresa, lista[i], function(err, data) {
          if (err) {
            callback(err)
          }
        })

      }
    }
  })
}

var sendEmailNotificacionAdministrador = function(empresa, obj, callback) {
  var plataforma_link_aqui = '<bold><a href="http://localhost:8065/#/login">Aqui</a></bold>'
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
                        <h1 style="color: #FFFFFF">SOASTEREO<h1>
                      </td>
                    </tr>
                    <tr>
                      <td style="padding:0cm 0cm 18.75pt 0cm"><p><br /></p><p>Hola, ${obj.nombre}:
                        <br />
                        <br />
                        Hemos recibido la creacion de un evento.
                        <br />
                        <br />
                        <strong>
                          El evento esTu contraseña temporal es:
                          <br />
                          <div style="border:double; background:#2f3fb6; color:white; text-align:center;padding: 10px; font-size:20px; font-weight:700;border-radius:10px;">
                            <span> ${obj.email} </span>
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
                        © SOASTEREO S.A.C. 2024. Todos los derechos reservados.
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
    // usuario: soastereoutp@gmail.com
    // pwd: Insanos*2024
    // service: 'hotmail',
    // host: 'smtp.gmail.com',
    // host  : 'smtp-mail.outlook.com',
    // port  : 587,                  // 143, 110
    // secure: false,
    // auth  : {
    //   user: 'soastereo@outlook.com',
    //   pass: 'hmeulfwyozjwrtmk'
    // },
    // tls: {
    //   rejectUnauthorized: false, // Acepta certificados auto-firmados o no verificados
    // },
    host: 'smtp.gmail.com',
    port  : 587,
    secure: false,
    auth  : {
      user: 'soastereoutp@gmail.com',
      pass: 'kvix ucuw wrru npld'
    },
    // tls: {
    //   rejectUnauthorized: false, // Acepta certificados auto-firmados o no verificados
    // },
  })

  let mailOptions = {
    from       : 'Soporte SOA <soastereoutp@gmail.com>',
    to         : obj.email,
    subject    : 'Se ah creeado un evento',
    html       : html,
    // attachments: [
    //   {
    //     filename: logoAux,
    //     path    : `./logo/${logoAux}`,
    //     cid     : 'unique@openjavascript.info'
    //   }
    // ]
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



exports.eventosLista = eventosLista
exports.eventosMantenimiento = eventosMantenimiento