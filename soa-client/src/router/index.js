import Vue      from 'vue'
import Router   from 'vue-router'

Vue.use(Router)

/* MasterPage */
import MasterPage from '@/masterpage'

import axios                  from 'axios'
import VueAxios               from 'vue-axios'
import Notifications          from 'vue-notification'
import { mixin as clickaway } from 'vue-clickaway'
import store                  from '@/store'

import VueUpload     from '@websanova/vue-upload'
import VueUploadHttp from '@websanova/vue-upload/dist/drivers/http/axios.esm.js'
Vue.use(VueUpload, {
  http: VueUploadHttp
})

Vue.use(Router)
Vue.use(VueAxios, axios)
Vue.use(Notifications)
Vue.mixin(clickaway)
// Vue.axios.defaults.baseURL = process.env.VUE_APP_BASE_API
// console.log(process.env.VUE_APP_BASE_API)
Vue.axios.defaults.baseURL = process.env.VUE_APP_API_ROUTE
// console.log(process.env.VUE_APP_API_ROUTE)

/* Router Modules */
// import componentsRouter from './modules/components'
// import chartsRouter from './modules/charts'
// import tableRouter from './modules/table'
// import nestedRouter from './modules/nested'

/**
 * Note: sub-menu only appear when route children.length >= 1
 * Detail see: https://panjiachen.github.io/vue-element-admin-site/guide/essentials/router-and-nav.html
 *
 * hidden: true                   if set true, item will not show in the sidebar(default is false)
 * alwaysShow: true               if set true, will always show the root menu
 *                                if not set alwaysShow, when item has more than one children route,
 *                                it will becomes nested mode, otherwise not show the root menu
 * redirect: noRedirect           if set noRedirect will no redirect in the breadcrumb
 * name:'router-name'             the name is used by <keep-alive> (must set!!!)
 * meta : {
    roles: ['ADMINISTRADOR','SUPERVISOR']    control the page roles (you can set multiple roles)
    title: 'title'               the name show in sidebar and breadcrumb (recommend set)
    icon: 'svg-name'/'el-icon-x' the icon show in the sidebar
    noCache: true                if set true, the page will no be cached(default is false)
    affix: true                  if set true, the tag will affix in the tags-view
    breadcrumb: false            if set false, the item will hidden in breadcrumb(default is true)
    activeMenu: '/example/list'  if set path, the sidebar will highlight the path you set
  }
 */

/**
  * rutas constantes
  * una página base que no tiene requisitos de permisos
  * se puede acceder a todos los roles
 */
export const constantRoutes = [
  {
    path: '/redirect',
    component: MasterPage,
    hidden: true,
    children: [
      {
        path: '/redirect/:path(.*)',
        component: () => import('@/views/redirect/index')
      }
    ]
  },
  {
    path: '/login',
    component: () => import('@/views/login/index'),
    hidden: true,
    meta: {
      requireAuth: false,
      middleware : 'guest',
      title      : `Login`
    }
  },
  {
    path: '/auth-redirect',
    component: () => import('@/views/login/auth-redirect'),
    hidden: true
  },
  {
    path: '/404',
    component: () => import('@/views/error-page/404'),
    hidden: true
  },
  {
    path: '/401',
    component: () => import('@/views/error-page/401'),
    hidden: true
  },
  // {
  //   path: '/',
  //   component: () => import('@/views/dashboard/index'),
  //   hidden: true,
  //   props: true,
  //   meta     : {
  //     requireAuth: true,
  //     middleware : 'auth',
  //     adminAuth  : false,
  //     userAuth   : true
  //   }
  // },
  {
    path: '/',
    component: MasterPage,
    redirect: '/dashboard',
    props: true,
    hidden: false,
    roles: ['ADMINISTRADOR', 'SUPERVISOR', 'USUARIO'],
    children: [
      {
        path: '/dashboard',
        component: () => import('@/views/dashboard/index'),
        name: 'Dashboard',
        meta: {
          title      : 'Dashboard',
          icon       : 'dashboard',
          affix      : true,
          noCache    : false,
          requireAuth: true,
          middleware : 'auth',
          adminAuth  : true,
          userAuth   : false,
          roles      : ['ADMINISTRADOR', 'SUPERVISOR', 'USUARIO']
        },
        props: true
      }
    ]
  },
  // {
  //   path: '/documentation',
  //   component: MasterPage,
  //   children: [
  //     {
  //       path: 'index',
  //       component: () => import('@/views/documentation/index'),
  //       name: 'Documentation',
  //       meta: { title: 'Documentation', icon: 'documentation', affix: false }
  //     }
  //   ]
  // },
  // {
  //   path: '/guide',
  //   component: MasterPage,
  //   redirect: '/guide/index',
  //   children: [
  //     {
  //       path: 'index',
  //       component: () => import('@/views/guide/index'),
  //       name: 'Guide',
  //       meta: { title: 'Guide', icon: 'guide', noCache: true }
  //     }
  //   ]
  // },
  {
    path: '/profile',
    component: MasterPage,
    redirect: '/profile/index',
    props: true,
    hidden: true,
    children: [
      {
        path: 'index',
        component: () => import('@/views/profile/index'),
        name: 'Profile',
        meta: { title: 'Perfil', icon: 'user', affix: false, noCache: true },
        props: true
      }
    ]
  }
]

/**
  * rutas asincrónicas
  * las rutas que deben cargarse dinámicamente en función de los roles de los usuarios
 */
export const asyncRoutes = [

  // ADMINISTRADOR
  // SUPERVISOR
  // USUARIO

  // SEGURIDAD
  {
    path: '/seguridad',
    component: MasterPage,
    redirect: '/seguridad/mantenimiento-usuarios',
    alwaysShow: true, // siempre mostrará el menú raíz
    name: 'Seguridad',
    meta: {
      title: 'Seguridad',
      icon: 'lock',
      roles: ['ADMINISTRADOR'] // puedes establecer roles en la navegación raíz
    },
    children: [
      {
        path: 'matenimiento-roles',
        component: () => import('@/views/login/mantenimiento_roles'),
        name: 'MantenimientoRoles',
        meta: {
          title: 'Roles',
          icon : 'el-icon-user-solid',
          roles: ['ADMINISTRADOR', 'USUARIO', 'CONSULTOR'] // o solo puede establecer roles en la navegación secundaria
        }
      },
      {
        path: 'matenimiento-usuarios',
        component: () => import('@/views/login/mantenimiento_usuarios'),
        name: 'MantenimientoUsuarios',
        meta: {
          title: 'Usuarios',
          icon : 'el-icon-user-solid',
          roles: ['ADMINISTRADOR', 'USUARIO', 'CONSULTOR'] // o solo puede establecer roles en la navegación secundaria
        }
      },
      {
        path: 'matenimiento-usuarios-empresa',
        component: () => import('@/views/login/mantenimiento_usuarios_empresa'),
        name: 'MantenimientoUsuariosEmpresa',
        meta: {
          title: 'Usuarios Por Empresas',
          icon : 'el-icon-user-solid',
          roles: ['ADMINISTRADOR', 'USUARIO', 'CONSULTOR'] // o solo puede establecer roles en la navegación secundaria
        }
      }
    ]
  },
  // MANTENIMIENTO
  {
    path: '/mantenimiento',
    component: MasterPage,
    redirect: '/mantenimiento/clientes',
    alwaysShow: true, // siempre mostrará el menú raíz
    name: 'Mantenimientos',
    meta: {
      title: 'Mantenimientos',
      icon: 'el-icon-setting',
      roles: ['ADMINISTRADOR', 'USUARIO', 'CONSULTOR', 'SUPERVISOR'] // puedes establecer roles en la navegación raíz
    },
    children: [
      {
        path: 'categorias',
        component: () => import('@/views/mantenimientos/mantenimiento_categorias'),
        name: 'MantenimientoCategorias',
        meta: {
          icon : 'el-icon-office-building',
          title: 'Categorias',
          roles: ['ADMINISTRADOR', 'SUPERVISOR', 'USUARIO']  // o solo puede establecer roles en la navegación secundaria
        }
      },
      {
        path: 'clientes',
        component: () => import('@/views/mantenimientos/mantenimiento_clientes'),
        name: 'MantenimientoClientes',
        meta: {
          icon : 'el-icon-office-building',
          title: 'Clientes',
          roles: ['ADMINISTRADOR', 'SUPERVISOR', 'USUARIO']  // o solo puede establecer roles en la navegación secundaria
        }
      },
      {
        path: 'eventos',
        component: () => import('@/views/mantenimientos/mantenimiento_eventos'),
        name: 'MantenimientoEventos',
        meta: {
          icon : 'el-icon-office-building',
          title: 'Eventos',
          roles: ['ADMINISTRADOR', 'SUPERVISOR', 'USUARIO']  // o solo puede establecer roles en la navegación secundaria
        }
      },
      {
        path: 'proveedores',
        component: () => import('@/views/mantenimientos/mantenimiento_proveedores'),
        name: 'MantenimientoProveedores',
        meta: {
          icon : 'el-icon-office-building',
          title: 'Proveedores',
          roles: ['ADMINISTRADOR', 'SUPERVISOR', 'USUARIO']  // o solo puede establecer roles en la navegación secundaria
        }
      },
      {
        path: 'evaluacion',
        component: () => import('@/views/mantenimientos/mantenimiento_evaluacion'),
        name: 'MantenimientoEvaluacion',
        meta: {
          icon: 'el-icon-office-building',
          title: 'Evaluación de Proveedores',
          roles: ['ADMINISTRADOR', 'SUPERVISOR', 'USUARIO']
        }
      }
    ]
  },

  // {
  //   path: '/permission',
  //   component: MasterPage,
  //   redirect: '/permission/page',
  //   alwaysShow: true, // will always show the root menu
  //   name: 'Permission',
  //   meta: {
  //     title: 'Permission',
  //     icon: 'lock',
  //     roles: ['ADMINISTRADOR', 'SUPERVISOR'] // you can set roles in root nav
  //   },
  //   children: [
  //     {
  //       path: 'page',
  //       component: () => import('@/views/permission/page'),
  //       name: 'PagePermission',
  //       meta: {
  //         title: 'Page Permission',
  //         roles: ['ADMINISTRADOR'] // or you can only set roles in sub nav
  //       }
  //     },
  //     {
  //       path: 'directive',
  //       component: () => import('@/views/permission/directive'),
  //       name: 'DirectivePermission',
  //       meta: {
  //         title: 'Directive Permission'
  //         // if do not set roles, means: this page does not require permission
  //       }
  //     },
  //     {
  //       path: 'role',
  //       component: () => import('@/views/permission/role'),
  //       name: 'RolePermission',
  //       meta: {
  //         title: 'Role Permission',
  //         roles: ['ADMINISTRADOR']
  //       }
  //     }
  //   ]
  // },

  // {
  //   path: '/icon',
  //   component: MasterPage,
  //   children: [
  //     {
  //       path: 'index',
  //       component: () => import('@/views/icons/index'),
  //       name: 'Icons',
  //       meta: { title: 'Icons', icon: 'icon', noCache: true }
  //     }
  //   ]
  // },

  // /** when your routing map is too long, you can split it into small modules **/
  // componentsRouter,
  // chartsRouter,
  // nestedRouter,
  // tableRouter,

  // {
  //   path: '/example',
  //   component: MasterPage,
  //   redirect: '/example/list',
  //   name: 'Example',
  //   meta: {
  //     title: 'Example',
  //     icon: 'el-icon-s-help'
  //   },
  //   children: [
  //     {
  //       path: 'create',
  //       component: () => import('@/views/example/create'),
  //       name: 'CreateArticle',
  //       meta: { title: 'Create Article', icon: 'edit' }
  //     },
  //     {
  //       path: 'edit/:id(\\d+)',
  //       component: () => import('@/views/example/edit'),
  //       name: 'EditArticle',
  //       meta: { title: 'Edit Article', noCache: true, activeMenu: '/example/list' },
  //       hidden: true
  //     },
  //     {
  //       path: 'list',
  //       component: () => import('@/views/example/list'),
  //       name: 'ArticleList',
  //       meta: { title: 'Article List', icon: 'list' }
  //     }
  //   ]
  // },

  // {
  //   path: '/tab',
  //   component: MasterPage,
  //   children: [
  //     {
  //       path: 'index',
  //       component: () => import('@/views/tab/index'),
  //       name: 'Tab',
  //       meta: { title: 'Tab', icon: 'tab' }
  //     }
  //   ]
  // },

  // {
  //   path: '/error',
  //   component: MasterPage,
  //   redirect: 'noRedirect',
  //   name: 'ErrorPages',
  //   meta: {
  //     title: 'Error Pages',
  //     icon: '404'
  //   },
  //   children: [
  //     {
  //       path: '401',
  //       component: () => import('@/views/error-page/401'),
  //       name: 'Page401',
  //       meta: { title: '401', noCache: true }
  //     },
  //     {
  //       path: '404',
  //       component: () => import('@/views/error-page/404'),
  //       name: 'Page404',
  //       meta: { title: '404', noCache: true }
  //     }
  //   ]
  // },

  // {
  //   path: '/error-log',
  //   component: MasterPage,
  //   children: [
  //     {
  //       path: 'log',
  //       component: () => import('@/views/error-log/index'),
  //       name: 'ErrorLog',
  //       meta: { title: 'Registro de Errores', icon: 'bug' }
  //     }
  //   ]
  // },

  // {
  //   path: '/excel',
  //   component: MasterPage,
  //   redirect: '/excel/export-excel',
  //   name: 'Excel',
  //   meta: {
  //     title: 'Excel',
  //     icon: 'excel'
  //   },
  //   children: [
  //     {
  //       path: 'export-excel',
  //       component: () => import('@/views/excel/export-excel'),
  //       name: 'ExportExcel',
  //       meta: { title: 'Export Excel' }
  //     },
  //     {
  //       path: 'export-selected-excel',
  //       component: () => import('@/views/excel/select-excel'),
  //       name: 'SelectExcel',
  //       meta: { title: 'Export Selected' }
  //     },
  //     {
  //       path: 'export-merge-header',
  //       component: () => import('@/views/excel/merge-header'),
  //       name: 'MergeHeader',
  //       meta: { title: 'Merge Header' }
  //     },
  //     {
  //       path: 'upload-excel',
  //       component: () => import('@/views/excel/upload-excel'),
  //       name: 'UploadExcel',
  //       meta: { title: 'Upload Excel' }
  //     }
  //   ]
  // },

  // {
  //   path: '/zip',
  //   component: MasterPage,
  //   redirect: '/zip/download',
  //   alwaysShow: true,
  //   name: 'Zip',
  //   meta: { title: 'Zip', icon: 'zip' },
  //   children: [
  //     {
  //       path: 'download',
  //       component: () => import('@/views/zip/index'),
  //       name: 'ExportZip',
  //       meta: { title: 'Export Zip' }
  //     }
  //   ]
  // },

  // {
  //   path: '/pdf',
  //   component: MasterPage,
  //   redirect: '/pdf/index',
  //   children: [
  //     {
  //       path: 'index',
  //       component: () => import('@/views/pdf/index'),
  //       name: 'PDF',
  //       meta: { title: 'PDF', icon: 'pdf' }
  //     }
  //   ]
  // },
  // {
  //   path: '/pdf/download',
  //   component: () => import('@/views/pdf/download'),
  //   hidden: true
  // },

  // {
  //   path: '/theme',
  //   component: MasterPage,
  //   children: [
  //     {
  //       path: 'index',
  //       component: () => import('@/views/theme/index'),
  //       name: 'Theme',
  //       meta: { title: 'Theme', icon: 'theme' }
  //     }
  //   ]
  // },

  // {
  //   path: '/clipboard',
  //   component: MasterPage,
  //   children: [
  //     {
  //       path: 'index',
  //       component: () => import('@/views/clipboard/index'),
  //       name: 'ClipboardDemo',
  //       meta: { title: 'Clipboard', icon: 'clipboard' }
  //     }
  //   ]
  // },

  // {
  //   path: 'external-link',
  //   component: MasterPage,
  //   children: [
  //     {
  //       path: 'https://github.com/PanJiaChen/vue-element-ADMINISTRADOR',
  //       meta: { title: 'External Link', icon: 'link' }
  //     }
  //   ]
  // },

  // 404 page must be placed at the end !!!
  { path: '*', redirect: '/404', hidden: true }
]

const createRouter = () => new Router({
  // mode: 'history', // require service support
  scrollBehavior: () => ({ y: 0 }),
  routes: constantRoutes
})

const router = createRouter()

// Detail see: https://github.com/vuejs/vue-router/issues/1234#issuecomment-357941465
export function resetRouter() {
  const newRouter = createRouter()
  router.matcher = newRouter.matcher // reset router
}

router.beforeEach((to, from, next) => {
  document.title    = to.meta.title
  // var ADMINISTRADOR = localStorage.getItem('ADMINISTRADOR')
  // console.log('ADMINISTRADOR:>>> ', ADMINISTRADOR)
  if (to.meta.middleware === 'guest') {
    if (store.getters.token) {
      next({ path: '/login' })
    }
    next()
  } else {
    if (store.getters.token) {
      next()
    } else {
      next({ path: '/login' })
    }
  }

  // if (to.meta.requireAuth) {
  //   if (store.getters.token) {
  //     next()
  //   } else {
  //     next('/login')
  //   }
  // } else {
  //   next()
  // }

  // if (to.meta.requireAuth) {
  //   if (!ADMINISTRADOR || !store.getters.token) {
  //     router.push({ path: '/login' })
  //   } else {
  //     if (to.meta.adminAuth) {
  //       if (ADMINISTRADOR) {
  //         return next('/')
  //       } else {
  //         router.push({ path: '/login' })
  //       }
  //     } else if (to.meta.userAuth) {
  //       if (!ADMINISTRADOR) {
  //         return next({ path: '/' })
  //       } else {
  //         router.push({ path: '/login' })
  //       }
  //     }
  //   }
  //   return
  // }

  // console.log('ADMINISTRADOR:>>> ', ADMINISTRADOR)
  // if (to.meta.middleware === 'guest') {
  //   console.log('1')
  //   if (store.getters.token) {
  //     next({ path: '/' })
  //   }
  //   next()
  // } else {
  //   console.log('2')
  //   if (store.getters.token) {
  //     if (ADMINISTRADOR) {
  //       console.log('ADMINISTRADOR si:')
  //       next('/')
  //     } else {
  //       console.log('ADMINISTRADOR no:')
  //     }
  //     // if (ADMINISTRADOR) {
  //     //   next('/')
  //     // } else {
  //     //   next({ path: '/login' })
  //     // }
  //   } else {
  //     next({ path: '/login' })
  //   }
  // }

  //   // if (ADMINISTRADOR) {
  //   //   console.log('2.1')
  //   //   if (store.getters.token) {
  //   //     console.log('2.2')
  //   //     next({ path: '/' })
  //   //   } else {
  //   //     console.log('2.3')
  //   //     next({ path: '/login' })
  //   //   }
  //   // } else {
  //   //   console.log('2.4')
  //   //   if (store.getters.token) {
  //   //     console.log('2.5')
  //   //     next()
  //   //   } else {
  //   //     console.log('2.6')
  //   //     next({ path: '/login' })
  //   //   }
  //   // }
  // }

  // if (to.meta.requireAuth) {
  //   const token = localStorage.getItem('token');
  //   if (token && token !== 'null') {
  //    next()
  //   } else {
  //    next('/login')
  //   }
  //  } else {
  //   next()
  //  }
  // }
})

export default router
