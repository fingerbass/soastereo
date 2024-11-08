import axios                    from 'axios'
// import { Message }              from 'element-ui'
import { MessageBox, Message }  from 'element-ui'
import store                    from '@/store'
import { getToken }             from '@/utils/auth'

// crear una instancia de axios
const service = axios.create({
  baseURL: process.env.VUE_APP_API_ROUTE, // url = base url + request url
  // withCredentials: true, // enviar cookies cuando se solicite entre dominios
  timeout: 150000 // request timeout
})

// request interceptor
service.interceptors.request.use((config) => {
  // hacer algo antes de que se envíe la solicitud => request
  if (store.getters.token) {
    // dejar que cada solicitud lleve token
    // ['X-Token'] es una clave de encabezado personalizada
    // por favor modifíquelo de acuerdo a la situación actual
    config.headers['X-Token']                          = getToken()
    config.headers['Accept']                           = 'application/json'
    config.headers['Content-Type']                     = 'application/json'
    config.headers['Access-Control-Allow-Origin']      = '*'
    config.headers['Access-Control-Allow-Credentials'] = 'true'
    config.headers['Access-Control-Max-Age']           = '1800'
    config.headers['Access-Control-Allow-Headers']     = 'content-type'
    config.headers['Access-Control-Allow-Methods']     = 'PUT, POST, GET, DELETE, PATCH, OPTIONS'
  }
  store.commit('loading/setLoading', true)
  return config
}, (error) => {
  // hacer algo con el error de solicitud => request error
  console.log(error) // para depurar
  store.commit('loading/setLoading', true)
  return Promise.reject(error)
})

// response interceptor
service.interceptors.response.use(

  /**
    * Si desea obtener información http como encabezados o status
    * Por favor devuelva la response  => response
  */

  /**
    * Determinar el estado de la solicitud por código personalizado
    * Aquí es sólo un ejemplo
    * También puede juzgar el estado por el código de estado HTTP
  */
  (response) => {
    // console.log('response:>>>', response)

    const res   = response.data
    res.status = +res.status

    // console.log('res:>>>', res)

    if (res.status !== 1) {
      Message({
        message : res.message || 'Error',
        type    : 'error',
        duration: 5 * 1000
      })

      // 50008: Illegal token; 50012: Other clients logged in; 50014: Token expired;
      if (res.status === -1 || res.status === 50008 || res.status === 50012 || res.status === 50014) {
        // to re-login
        MessageBox.confirm('Se ha cerrado la sesión, puede cancelar para permanecer en esta página o iniciar sesión de nuevo.', 'Confirmar cierre de sesión', {
          confirmButtonText: 'Volver a iniciar sesión',
          cancelButtonText : 'Cancelar',
          type             : 'warning'
        }).then(() => {
          store.dispatch('user/resetToken').then(() => {
            location.reload()
          })
        })
      }
      store.commit('loading/setLoading', false)
      return Promise.reject(new Error(res.message || 'Error'))
    } else {
      store.commit('loading/setLoading', false)
      return res
    }

    // if (res.status === 0) {
    //   Message({
    //     message : res.message || 'Error',
    //     type    : 'error',
    //     duration: 5 * 1000
    //   })
    // }
    // store.commit('loading/setLoading', false)
    // return res

    // si el código personalizado no es 200, se considera un error.
    // if (res.status !== 1) {
    //   Message({
    //     message : res.message || 'Error',
    //     type    : 'error',
    //     duration: 5 * 1000
    //   })

    //   // 50008: Illegal token; 50012: Other clients logged in; 50014: Token expired;
    //   if (res.status === 50008 || res.status === 50012 || res.status === 50014) {
    //     // to re-login
    //     MessageBox.confirm('Se ha cerrado la sesión, puede cancelar para permanecer en esta página o iniciar sesión de nuevo.', 'Confirmar cierre de sesión', {
    //       confirmButtonText: 'Volver a iniciar sesión',
    //       cancelButtonText : 'Cancelar',
    //       type             : 'warning'
    //     }).then(() => {
    //       store.dispatch('user/resetToken').then(() => {
    //         location.reload()
    //       })
    //     })
    //   }
    //   return Promise.reject(new Error(res.message || 'Error'))
    // } else {
    //   return res
    // }
  }, (error) => {
    console.log('err' + error) // para depurar
    // Message({
    //   message : 'Error en la conexión de red.', // error.message,
    //   type    : 'error',
    //   duration: 5 * 1000
    // })
    if (error) {
      MessageBox.alert('No se puede iniciar sesion, error de comunicacion con el servidor.', 'Inicio de Sesion', {
        confirmButtonText: 'Continuar',
        callback: action => {
          console.log('action:>>> ', action)
          // Message({
          //   type   : 'error',
          //   message: `Accion: ${action === 'confirm' ? 'confirmada' : ''}`
          // })
        }
      })
    }
    store.commit('loading/setLoading', false)
    return Promise.reject(error)
  }
)

export default service
