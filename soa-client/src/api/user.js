import request        from '@/utils/request'
// import { getToken }   from '@/utils/auth'

// export function login(data) {
//   return request({
//     url   : '/vue-element-admin/user/login',
//     method: 'post',
//     data
//   })
// }

export function login(data) {
  data.empresa  = process.env.VUE_APP_EMPRESA
  return request({
    url   : '/login',
    method: 'post',
    data
  })
}

// export function getInfo(token) {
//   return request({
//     url   : '/vue-element-admin/user/info',
//     method: 'get',
//     params: { token }
//   })
// }

export function getInfo(token) {
  var query         = {}
  query.token       = token
  query.empresa     = process.env.VUE_APP_EMPRESA
  query.username    = localStorage.getItem('username')
  query.idusuario   = localStorage.getItem('idusuario')
  return request({
    url   : '/info',
    method: 'get',
    params: query
  })
}

// export function getInfo(token) {
//   var query         = {}
//   query.token       = token
//   query.empresa     = process.env.VUE_APP_EMPRESA
//   query.username    = localStorage.getItem('username')
//   query.idusuario   = localStorage.getItem('idusuario')
//   return request({
//     url   : process.env.VUE_APP_API_RUTA_USUARIOS + '/info',
//     method: 'get',
//     params: query
//   })
// }

// export function logout() {
//   return request({
//     url   : '/vue-element-admin/user/logout',
//     method: 'post'
//   })
// }

export function logout() {
  return request({
    url   : '/logout',
    method: 'post'
  })
}
