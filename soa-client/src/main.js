import Vue        from 'vue'

import Cookies from 'js-cookie'
import axios   from  'axios'

import 'normalize.css/normalize.css' // a modern alternative to CSS resets

import Element  from  'element-ui'
import                './styles/element-variables.scss'
import enLang   from  'element-ui/lib/locale/lang/en'// Si usa el paquete de idioma chino, apóyelo de forma predeterminada, sin importación adicional, elimine esta dependencia

import                '@/styles/index.scss' // global css

import App        from './App'
import store      from './store'
// import stores     from './store/modules/stores'
import router     from './router'

import './icons'            // icon
import './permission'       // permission control
import './utils/error-log'  // error log

import * as filters from './filters' // global filters

import lodash from 'lodash'
import moment from 'moment'
import              'moment/locale/es'
moment.locale('es')

/* import the fontawesome core */
import { library } from '@fortawesome/fontawesome-svg-core'

/* import font awesome icon component */
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'

/* import specific icons */
import { faUserSecret } from '@fortawesome/free-solid-svg-icons'
import { faCar }        from '@fortawesome/free-solid-svg-icons'

// import VueCameraLib from 'vue-camera-lib'

/* add icons to the library */
library.add(faUserSecret, faCar)

/* add font awesome icon component */
Vue.component('font-awesome-icon', FontAwesomeIcon)

Vue.config.productionTip = false

/**
  * Si no desea utilizar un servidor simulado
  * quieres usar MockJs para la API simulada
  * puedes ejecutar: mockXHR()
  *
  * Actualmente MockJs se utilizará en el entorno de producción,
  * ¡Elimínelo antes de conectarse! ! !
 */
if (process.env.NODE_ENV === 'production') {
  const { mockXHR } = require('../mock')
  mockXHR()
}

// Vue.use(VueCameraLib)

Vue.use(Element, {
  // size: Cookies.get('size') || 'small' || 'mini',  // set element-ui default size
  size: Cookies.get('size') || 'medium' || 'mini' || 'small',  // set element-ui default size
  locale: enLang                          // Si usa chino, no es necesario configurar, elimine
})

// register global utility filters
Object.keys(filters).forEach(key => {
  Vue.filter(key, filters[key])
})

// moment
Vue.filter('twoDecimals', function (value) {
  return value.toFixed(2)
})

Vue.filter('fromNow', function (value) {
  return moment(value).fromNow()
})

Vue.filter('formatDate', function (value) {
  return moment(value).format('DD/MM/YYYY HH:mm:ss')
})

Vue.filter('formatDateComplete', function (value) {
  return moment(value).format('DD/MM/YYYY HH:mm:ss a')
})

Vue.filter('formatDateDay', function (value) {
  return moment(value).format('DD/MM/YYYY')
})

Vue.filter('formatDateHourComplete', function (value) {
  return moment(value).format('HH:mm:ss a')
})

Vue.filter('formatDateHour', function (value) {
  return moment(value).format('HH:mm:ss')
})

window._ = lodash
window.moment = moment

// var token  = localStorage.getItem('token')
// Vue.axios.defaults.baseURL                                   = process.env.VUE_APP_BASE_API
Vue.axios.defaults.baseURL                                   = process.env.VUE_APP_API_ROUTE
axios.defaults.headers.common['Access-Control-Allow-Origin'] = '*'

new Vue({
  el: '#app',
  router: router,
  store,
  components: { App },
  template  : '<App/>',
  render    : h => h(App)
})
