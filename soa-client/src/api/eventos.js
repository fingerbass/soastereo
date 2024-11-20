import request from '@/utils/request'
import { getToken } from '@/utils/auth'

export function eventosLista(query) {
  query.token = getToken()
  query.empresa = process.env.VUE_APP_EMPRESA
  query.username = localStorage.getItem('username')
  query.idusuario = localStorage.getItem('idusuario')
  query.latitud = localStorage.getItem('latitud')
  query.longitud = localStorage.getItem('longitud')
  query.dispositivo = localStorage.getItem('dispositivo')
  query.ip = localStorage.getItem('ip')

  return request({
    url: process.env.VUE_APP_API_RUTA_EVENTOS + '/lista',
    method: 'get',
    params: query
  }, function(err) {
    return err
  }, function() {
    return false
  })
}

export function eventosMantenimiento(data) {
  data.token = getToken()
  data.empresa = process.env.VUE_APP_EMPRESA
  data.username = localStorage.getItem('username')
  data.idusuario = localStorage.getItem('idusuario')
  data.latitud = localStorage.getItem('latitud')
  data.longitud = localStorage.getItem('longitud')
  data.dispositivo = localStorage.getItem('dispositivo')
  data.ip = localStorage.getItem('ip')

  return request({
    url: process.env.VUE_APP_API_RUTA_EVENTOS + '/mantenimiento',
    method: 'post',
    data
  }, function(err) {
    return err
  }, function() {
    return false
  })
}

export function getEventosSelect() {
  const query = {
    token: getToken(),
    empresa: process.env.VUE_APP_EMPRESA
  }

  return request({
    url: process.env.VUE_APP_API_RUTA_EVENTOS + '/select',
    method: 'get',
    params: query
  }, function(err) {
    return err
  }, function() {
    return false
  })
}