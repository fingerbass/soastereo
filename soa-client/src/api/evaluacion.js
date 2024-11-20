import request from '@/utils/request'
import { getToken } from '@/utils/auth'

export function evaluacionLista(query = {}) {
  const params = {
    token: getToken(),
    empresa: process.env.VUE_APP_EMPRESA,
    username: localStorage.getItem('username'),
    idusuario: localStorage.getItem('idusuario'),
    latitud: localStorage.getItem('latitud'),
    longitud: localStorage.getItem('longitud'),
    dispositivo: localStorage.getItem('dispositivo'),
    ip: localStorage.getItem('ip'),
    ...query
  }

  return request({
    url: process.env.VUE_APP_API_RUTA_EVALUACION + '/lista',
    method: 'get',
    params
  })
}

export function evaluacionMantenimiento(data) {
  const params = {
    token: getToken(),
    empresa: process.env.VUE_APP_EMPRESA,
    username: localStorage.getItem('username'),
    idusuario: localStorage.getItem('idusuario'),
    latitud: localStorage.getItem('latitud'),
    longitud: localStorage.getItem('longitud'),
    dispositivo: localStorage.getItem('dispositivo'),
    ip: localStorage.getItem('ip'),
    ...data
  }

  return request({
    url: process.env.VUE_APP_API_RUTA_EVALUACION + '/mantenimiento',
    method: 'post',
    data: params
  })
}

export function getProveedores() {
  const params = {
    token: getToken(),
    empresa: process.env.VUE_APP_EMPRESA,
    username: localStorage.getItem('username'),
    idusuario: localStorage.getItem('idusuario'),
    latitud: localStorage.getItem('latitud'),
    longitud: localStorage.getItem('longitud'),
    dispositivo: localStorage.getItem('dispositivo'),
    ip: localStorage.getItem('ip')
  }

  return request({
    url: process.env.VUE_APP_API_RUTA_PROVEEDORES + '/lista',
    method: 'get',
    params
  })
}

export function getEventos() {
  const params = {
    token: getToken(),
    empresa: process.env.VUE_APP_EMPRESA,
    username: localStorage.getItem('username'),
    idusuario: localStorage.getItem('idusuario'),
    latitud: localStorage.getItem('latitud'),
    longitud: localStorage.getItem('longitud'),
    dispositivo: localStorage.getItem('dispositivo'),
    ip: localStorage.getItem('ip')
  }

  return request({
    url: process.env.VUE_APP_API_RUTA_EVENTOS + '/lista',
    method: 'get',
    params
  })
}
