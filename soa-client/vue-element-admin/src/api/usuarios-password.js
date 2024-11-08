import request        from '@/utils/request'
import { getToken }   from '@/utils/auth'

export function usuariospasswordCambiar(data) {
  data.token    = getToken()
  data.empresa  = process.env.VUE_APP_EMPRESA
  data.username = localStorage.getItem('username')
  data.idusuario = localStorage.getItem('idusuario')
  data.latitud = localStorage.getItem('latitud')
  data.longitud = localStorage.getItem('longitud')
  data.dispositivo = localStorage.getItem('dispositivo')
  data.ip = localStorage.getItem('ip')
  // console.log('data', data)
  return request({
    url   : process.env.VUE_APP_API_RUTA_USUARIOS_PASSWORD + '/password-cambiar',
    method: 'post',
    data
  }, function (err) {
    return err
  }, function () {
    return false
  })
}

export function usuariospasswordRestablecer(data) {
  data.empresa  = process.env.VUE_APP_EMPRESA
  // data.username = localStorage.getItem('username')
  // console.log('data', data)
  return request({
    url   : process.env.VUE_APP_API_RUTA_USUARIOS_PASSWORD + '/password-restablecer',
    method: 'post',
    data
  })
}

export function usuariospasswordMantenimiento(data) {
  data.token    = getToken()
  data.empresa  = process.env.VUE_APP_EMPRESA
  data.username = localStorage.getItem('username')
  data.idusuario = localStorage.getItem('idusuario')
  data.latitud = localStorage.getItem('latitud')
  data.longitud = localStorage.getItem('longitud')
  data.dispositivo = localStorage.getItem('dispositivo')
  data.ip = localStorage.getItem('ip')
  // console.log('data', data)
  return request({
    url   : process.env.VUE_APP_API_RUTA_USUARIOS_PASSWORD + '/password-mantenimiento',
    method: 'post',
    data
  }, function (err) {
    return err
  }, function () {
    return false
  })
}
