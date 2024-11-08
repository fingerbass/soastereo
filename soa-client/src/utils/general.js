import Cookies      from 'js-cookie'
import { getToken } from '@/utils/auth'

const TokenKey = 'Admin-Token'

export function apiGet(vm, url, params, onSuccess, onError, onFinish) {
  var obj = {
    params: params
  }

  params.token       = getToken()
  // params.empresa     = process.env.VUE_APP_EMPRESA
  params.username    = localStorage.getItem('username')
  params.idusuario   = localStorage.getItem('idusuario')
  params.latitud     = localStorage.getItem('latitud')
  params.longitud    = localStorage.getItem('longitud')
  params.dispositivo = localStorage.getItem('dispositivo')
  params.ip          = localStorage.getItem('ip')

  params.empresa = process.env.VUE_APP_EMPRESA
  // params.token   = localStorage.getItem('token')
  // params.empresa = process.env.VUE_APP_EMPRESA.toLowerCase()
  // params.app     = process.env.VUE_APP_EMPRESA_FULL.toLowerCase()

  vm.axios.get(url, obj).then((response) => {
    console.log('response: ', response)
    var data    = response.data
    data.status = +data.status

    if (data.status === -1) {
      // No se ha logueado
      sessionStorage.setItem('token', '')
      window.location.href = '/'
    } else if (data.status === 0) {
      onError(data)
      if (onFinish) onFinish()
    } else {
      onSuccess(data)
      if (onFinish) onFinish()
    }
  }).catch((error) => {
    onError(error)
    if (onFinish) onFinish()
  })
}

export function apiGetExcel(vm, url, params, onSuccess, onError, onFinish) {
  var obj = {
    responseType: 'arraybuffer',
    params: params
  }

  obj.params.empresa = process.env.VUE_APP_EMPRESA
  obj.params.token   = sessionStorage.getItem('token') || Cookies.get(TokenKey)

  vm.axios.get(url, obj).then((response) => {
    var data = response.data
    onSuccess(data)
    if (onFinish) onFinish()
  }).catch((error) => {
    onError(error)
    if (onFinish) onFinish()
  })
}

export function apiUpload(vm, url, params, onSuccess, onError, onFinish) {
  var obj = params

  params.empresa = process.env.VUE_APP_EMPRESA
  params.token   = sessionStorage.getItem('token') || Cookies.get(TokenKey)

  vm.axios.post(url, obj).then((response) => {
    var data = response.data
    data.status = +data.status
    console.log('response:', response)
    if (data.status === -1) {
      // No se ha logueado
      sessionStorage.setItem('token', '')
      window.location.href = '/'
    } else if (data.status === 0) {
      onError(data)
      if (onFinish) onFinish()
    } else {
      onSuccess(data)
      if (onFinish) onFinish()
    }
  }).catch((error) => {
    onError(error)
    if (onFinish) onFinish()
  })
}

export function apiPost(vm, url, params, onSuccess, onError, onFinish) {
  var obj = params

  params.token       = getToken()
  // params.empresa     = process.env.VUE_APP_EMPRESA
  params.username    = localStorage.getItem('username')
  params.idusuario   = localStorage.getItem('idusuario')
  params.latitud     = localStorage.getItem('latitud')
  params.longitud    = localStorage.getItem('longitud')
  params.dispositivo = localStorage.getItem('dispositivo')
  params.ip          = localStorage.getItem('ip')

  params.empresa = process.env.VUE_APP_EMPRESA
  // params.token   = sessionStorage.getItem('token') || Cookies.get(TokenKey)

  vm.axios.post(url, obj).then((response) => {
    var data = response.data
    data.status = +data.status
    console.log('response:', response)
    if (data.status === -1) {
      // No se ha logueado
      sessionStorage.setItem('token', '')
      window.location.href = '/'
    } else if (data.status === 0) {
      onError(data)
      if (onFinish) onFinish()
    } else {
      onSuccess(data)
      if (onFinish) onFinish()
    }
  }).catch((error) => {
    onError(error)
    if (onFinish) onFinish()
  })
}

export function apiPut(vm, url, params, onSuccess, onError, onFinish) {
  var obj = params

  params.empresa = process.env.VUE_APP_EMPRESA
  params.token   = sessionStorage.getItem('token') || Cookies.get(TokenKey)

  vm.axios.put(url, obj).then((response) => {
    var data = response.data
    data.status = +data.status
    console.log('response:', response)
    if (data.status === -1) {
      // No se ha logueado
      sessionStorage.setItem('token', '')
      window.location.href = '/'
    } else if (data.status === 0) {
      onError(data)
      if (onFinish) onFinish()
    } else {
      onSuccess(data)
      if (onFinish) onFinish()
    }
  }).catch((error) => {
    onError(error)
    if (onFinish) onFinish()
  })
}

export function apiDelete(vm, url, params, onSuccess, onError, onFinish) {
  var obj = {
    params: params
  }

  params.empresa = process.env.VUE_APP_EMPRESA
  params.token   = sessionStorage.getItem('token') || Cookies.get(TokenKey)

  vm.axios.delete(url, obj).then((response) => {
    var data = response.data
    data.status = +data.status
    console.log('response:', response)
    if (data.status === -1) {
      // No se ha logueado
      sessionStorage.setItem('token', '')
      window.location.href = '/'
    } else if (data.status === 0) {
      onError(data)
      if (onFinish) onFinish()
    } else {
      onSuccess(data)
      if (onFinish) onFinish()
    }
  }).catch((error) => {
    onError(error)
    if (onFinish) onFinish()
  })
}

export function notify(vm, type, title, message) {
  vm.$notify({
    title   : title,
    message : message,
    // position: 'bottom right',
    type    : type
  })
}

export function apiUploadWithParams (vm, url, body, params, onSuccess, onError, onFinish) {
  var obj = body

  body.empresa    = process.env.VUE_APP_EMPRESA
  body.token      = localStorage.getItem('token')
  params.empresa  = process.env.VUE_APP_EMPRESA.toLowerCase()
  params.app      = process.env.VUE_APP_EMPRESA_FULL.toLowerCase()
  console.log('params ', params)
  vm.axios.post(url, obj, { params }).then((response) => {
    console.Console
    var data = response.data
    data.status = +data.status
    if (data.status === -1) {
      // No se ha logueado
      localStorage.setItem('token', '')
      window.location.href = '/'
    } else if (data.status === 0) {
      onError(data)
      if (onFinish) onFinish()
    } else {
      onSuccess(data)
      if (onFinish) onFinish()
    }
  }).catch((error) => {
    onError(error)
    if (onFinish) onFinish()
  })
}
