import request from '@/utils/request'
import { getToken } from '@/utils/auth'

function getQuery() {
  return {
    token: getToken(),
    empresa: process.env.VUE_APP_EMPRESA,
    username: localStorage.getItem('username'),
    idusuario: localStorage.getItem('idusuario'),
    latitud: localStorage.getItem('latitud'),
    longitud: localStorage.getItem('longitud'),
    dispositivo: localStorage.getItem('dispositivo'),
    ip: localStorage.getItem('ip')
  }
}

// Funciones existentes del dashboard anterior
export function dashboardListaPersonas(query) {
  return request({
    url: '/api/dashboard/lista-personas',
    method: 'get',
    params: {
      ...getQuery(),
      ...query
    }
  }, function(err) {
    return err
  }, function() {
    return false
  })
}

export function dashboardListaActivos(query) {
  return request({
    url: '/api/dashboard/lista-activos',
    method: 'get',
    params: {
      ...getQuery(),
      ...query
    }
  }, function(err) {
    return err
  }, function() {
    return false
  })
}

export function dashboardListaCorrespondencia(query) {
  return request({
    url: '/api/dashboard/lista-correspondencia',
    method: 'get',
    params: {
      ...getQuery(),
      ...query
    }
  }, function(err) {
    return err
  }, function() {
    return false
  })
}

export function dashboardListaIncidencias(query) {
  return request({
    url: '/api/dashboard/lista-incidencias',
    method: 'get',
    params: {
      ...getQuery(),
      ...query
    }
  }, function(err) {
    return err
  }, function() {
    return false
  })
}

// Nuevas funciones para el dashboard de eventos
export function getDashboardKpis() {
  return request({
    url: '/api/dashboard/eventos/kpis',
    method: 'get',
    params: getQuery()
  }, function(err) {
    return err
  }, function() {
    return false
  })
}

export function getDashboardTendencia(fecha) {
  return request({
    url: '/api/dashboard/eventos/tendencia',
    method: 'get',
    params: {
      ...getQuery(),
      fecha: fecha
    }
  }, function(err) {
    return err
  }, function() {
    return false
  })
}

export function getDashboardRadar() {
  return request({
    url: '/api/dashboard/eventos/radar',
    method: 'get',
    params: getQuery()
  }, function(err) {
    return err
  }, function() {
    return false
  })
}

export function getDashboardDistribucion() {
  return request({
    url: '/api/dashboard/eventos/distribucion',
    method: 'get',
    params: getQuery()
  }, function(err) {
    return err
  }, function() {
    return false
  })
}

export function getDashboardCostos(año) {
  return request({
    url: '/api/dashboard/eventos/costos',
    method: 'get',
    params: {
      ...getQuery(),
      año: año || new Date().getFullYear()
    }
  }, function(err) {
    return err
  }, function() {
    return false
  })
}

export function getDashboardGeneral() {
  return request({
    url: '/api/dashboard/eventos/general',
    method: 'get',
    params: getQuery()
  }, function(err) {
    return err
  }, function() {
    return false
  })
}
