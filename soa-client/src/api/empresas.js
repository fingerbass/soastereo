import request        from '@/utils/request'
import { getToken }   from '@/utils/auth'

export function empresasLista(query) {
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
    url   : process.env.VUE_APP_API_RUTA_EMPRESAS + '/lista',
    method: 'get',
    params: query
  }, function (err) {
    return err
  }, function () {
    return false
  })
}

export function empresasMantenimiento(data) {
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
    url   : process.env.VUE_APP_API_RUTA_EMPRESAS + '/mantenimiento',
    method: 'post',
    data
  }, function (err) {
    return err
  }, function () {
    return false
  })
}

export function empresasUUID(data) {
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
    url   : process.env.VUE_APP_API_RUTA_EMPRESAS + '/uuid',
    method: 'post',
    data
  }, function (err) {
    return err
  }, function () {
    return false
  })
}

export function empresasUploadPlantillaCargaMasiva(data) {
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
    url   : process.env.VUE_APP_API_RUTA_EMPRESAS + '/upload-plantilla-carga-masiva',
    method: 'post',
    data
  }, function (err) {
    return err
  }, function () {
    return false
  })
}
