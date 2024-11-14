import request        from '@/utils/request'
import { getToken }   from '@/utils/auth'

export function tiposdocumentosLista(query) {
  query.token    = getToken()
  query.empresa  = process.env.VUE_APP_EMPRESA
  query.username = localStorage.getItem('username')
  query.idusuario = localStorage.getItem('idusuario')
  query.latitud = localStorage.getItem('latitud')
  query.longitud = localStorage.getItem('longitud')
  query.dispositivo = localStorage.getItem('dispositivo')
  query.ip = localStorage.getItem('ip')
  // console.log('query', query)
  return request({
    url   : process.env.VUE_APP_API_RUTA_TIPOS_DOCUMENTOS + '/lista',
    method: 'get',
    params: query
  }, function (err) {
    return err
  }, function () {
    return false
  })
}

export function tiposdocumentosMantenimiento(data) {
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
    url   : process.env.VUE_APP_API_RUTA_TIPOS_DOCUMENTOS + '/mantenimiento',
    method: 'post',
    data
  }, function (err) {
    return err
  }, function () {
    return false
  })
}
