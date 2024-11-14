<template lang="pug">
.login-container
  .background-image-login
    el-row(:gutter='10')
      el-col(:xs='24' :sm='12' :md='12' :lg='12' :xl='12')
        .div.text-align-center.margin-top-40
          //- img.sidebar-logo.logo-img(v-if='logo' :src='logo')
          h1.bold(style="color: #FFFFFF") EVENTOS PERÚ
      el-col(:xs='24' :sm='12' :md='12' :lg='12' :xl='12')
        el-form.login-form(ref='loginForm' :model='loginForm' :rules='loginRules' autocomplete='on' label-position='left')
          el-card.box-card.padding-10(shadow="always")
            .title-container
              h2.bold Bienvenidos
              h5.font-weight-500.text-align-justify EVENTOS PERU permite a los clientes solicitar servicios a través de llamadas o WhatsApp. Los clientes reciben una lista de proveedores, pero la falta de seguimiento de la experiencia y estatus de los trabajadores ha generado insatisfacción debido a la mala calidad del servicio.
              h5.font-weight-500.text-align-justify En ese sentido, SOA Stereo propone desarrollar una solución tecnológica que permita mejorar los procesos del cliente que desee contratar algún tipo de evento; por ejemplo: cumpleaños, aniversario, matrimonio, integración, etc.
            el-form-item.margin-top-20(prop='username')
              span.svg-container
                svg-icon(icon-class='user')
              el-input.color-text(ref='username' v-model='loginForm.username' placeholder='Usuario' name='username' type='text' tabindex='1' autocomplete='on' size="mini" @blur="onblurInput()" :disabled='loading')
            el-tooltip(v-model='capsTooltip' content='Bloqueo de mayúsculas está activado' placement='right' manual='')
              el-form-item.margin-top-20(prop='password')
                span.svg-container
                  svg-icon(icon-class='password')
                el-input.color-text(:key='passwordType' ref='password' v-model='loginForm.password' :type='passwordType' placeholder='Contraseña' name='password' tabindex='2' autocomplete='on' @keyup.native='checkCapslock' @blur='capsTooltip = false' @keyup.enter.native='handleLogin' size="mini" show-password :disabled='loading')
                //- span.show-pwd(@click='showPwd')
                //-   svg-icon(:icon-class="passwordType === 'password' ? 'eye' : 'eye-open'")
            el-link(type='primary' @click="openModalRestablecerContraseña()") Restablecer mi contraseña
            el-row.contenedor.margin-top-20(:gutter='10')
              el-col.text-align-center(:xs='24' :sm='24' :md='24' :lg='24' :xl='24')
                el-button(:loading='loading' type='info' style='width:100%;' @click='handleLogin' :disabled='loading') Ingresar
          div.margin-top-10
            el-card.box-card(shadow="always")
              h5.font-weight-500.text-align-justify.margin-5 Si todavía no tienes una cuenta de acceso a la nube de soa, descubre todos los detalles aquí.
              div.text-align-center
                el-link.bold(type='primary') DESCUBRE SOA

    LoginContrasenaRestablecer(v-if="showModalContraseñaRestablecer" :modal='true' @close="closeModalRestablecerContraseña()")
</template>

<script>
import { notify }                 from '@/utils/general'
import LoginContrasenaRestablecer from './login_contrasena_restablecer.vue'

export default {
  name: 'Login',
  components: {
    'LoginContrasenaRestablecer': LoginContrasenaRestablecer
  },
  data() {
    return {
      loginForm: {
        username: '', // jromero
        password: ''  // 123456
      },
      loginRules                    : {},
      passwordType                  : 'password',
      capsTooltip                   : false,
      loading                       : false,
      showDialog                    : false,
      redirect                      : undefined,
      otherQuery                    : {},
      title                         : 'soa',
      logo                          : require('@/assets/lib_imagenes/logo_soa.svg'),
      showModalContraseñaRestablecer: false,
      window                        : { width : 0, height: 0 },
      minWidthMedia                 : 700,
      minHeightMedia                : 550,
      isMovil                       : null
    }
  },
  watch: {
    $route: {
      handler: function(route) {
        const query = route.query
        if (query) {
          this.redirect = query.redirect
          this.otherQuery = this.getOtherQuery(query)
        }
      },
      immediate: true
    }
  },
  created() {
    var vm = this
    window.addEventListener('resize', vm.handleResize)
    vm.handleResize()
    // window.addEventListener('storage', this.afterQRScan)
    // this.loginForm.username = this.loginForm.username ? this.loginForm.username.trim() : ''
    // this.loginForm.password = this.loginForm.password ? this.loginForm.password.trim() : ''
    // if (this.loginForm.username === '') {
    //   this.$refs.username.focus()
    // } else if (this.loginForm.password === '') {
    //   this.$refs.password.focus()
    // }
  },
  mounted() {
    // this.loginForm.username = this.loginForm.username ? this.loginForm.username.trim() : ''
    // this.loginForm.password = this.loginForm.password ? this.loginForm.password.trim() : ''
    // if (this.loginForm.username === '') {
    //   this.$refs.username.focus()
    // } else if (this.loginForm.password === '') {
    //   this.$refs.password.focus()
    // }
  },
  destroyed () {
    var vm = this
    window.removeEventListener('resize', vm.handleResize)
  },
  methods: {
    handleResize () {
      // console.log('cambio tamaño de la pantalla.. ')
      var  vm                                                     = this
      vm.window.width                                             = window.innerWidth
      vm.window.height                                            = window.innerHeight
      if   (vm.window.width < vm.minWidthMedia)       vm.isMovil  = true
      else if (vm.window.height < vm.minHeightMedia)  vm.isMovil  = true
      else vm.isMovil                                             = false
      localStorage.setItem('isMovil', vm.isMovil)
      // console.log('vm.isMovil.. ', vm.isMovil)
    },
    checkCapslock(e) {
      const { key } = e
      this.capsTooltip = key && key.length === 1 && (key >= 'A' && key <= 'Z')
    },
    showPwd() {
      if (this.passwordType === 'password') {
        this.passwordType = ''
      } else {
        this.passwordType = 'password'
      }
      this.$nextTick(() => {
        this.$refs.password.focus()
      })
    },
    handleLogin() {
      var vm = this
      this.$refs.loginForm.validate(valid => {
        if (valid) {
          this.loading = true
          this.$store.dispatch('user/login', this.loginForm)
            .then((data) => {
              // console.log('data:>>> ', data)
              localStorage.setItem('usuarioTemporal', vm.loginForm.username)
              localStorage.setItem('passwordTemporal', vm.loginForm.password)
              localStorage.setItem('username', data.username)
              localStorage.setItem('idusuario', data.idusuario)
              localStorage.setItem('login', data.login)
              localStorage.setItem('paterno', data.paterno)
              localStorage.setItem('materno', data.materno)
              localStorage.setItem('nombre', data.nombre)
              localStorage.setItem('foto', data.foto)
              localStorage.setItem('email', data.email)
              localStorage.setItem('documento', data.documento)
              localStorage.setItem('cambioclave', data.cambioclave)
              localStorage.setItem('administrador', data.administrador)
              var administrador = JSON.parse(localStorage.getItem('administrador'))
              if (administrador) {
                this.$router.push({ path: '/' })
              } else {
                this.$router.push({ path: '/' })
              }
              this.loading = false
            })
            .catch(() => {
              this.loginForm.username = this.loginForm.username ? this.loginForm.username.trim() : ''
              this.loginForm.password = this.loginForm.password ? this.loginForm.password.trim() : ''
              if (this.loginForm.username === '') {
                this.$refs.username.focus()
              } else if (this.loginForm.password === '') {
                this.$refs.password.focus()
              }
              this.loading = false
            })
        } else {
          notify(vm, 'error', 'Error', 'Los campos usuario y contraseña estan vacias.')
          this.loginForm.username = this.loginForm.username ? this.loginForm.username.trim() : ''
          this.loginForm.password = this.loginForm.password ? this.loginForm.password.trim() : ''
          if (this.loginForm.username === '') {
            this.$refs.username.focus()
          } else if (this.loginForm.password === '') {
            this.$refs.password.focus()
          }
          return false
        }
      })
      // this.$store.dispatch('auth/LOGIN', this.loginForm)
      //   .then((data) => {
      //     console.log('data', data)
      //     localStorage.setItem('token', data.data.token)
      //     localStorage.setItem('username', data.data.login)
      //     this.$router.push({ path: this.redirect || '/', query: this.otherQuery })
      //     this.loading = false
      //   })
      //   .catch(() => {
      //     this.loading = false
      //   })
    },
    openModalRestablecerContraseña() {
      var vm                            = this
      vm.showModalContraseñaRestablecer = true
    },
    closeModalRestablecerContraseña() {
      var vm                            = this
      vm.showModalContraseñaRestablecer = false
    },
    getOtherQuery(query) {
      return Object.keys(query).reduce((acc, cur) => {
        if (cur !== 'redirect') {
          acc[cur] = query[cur]
        }
        return acc
      }, {})
    },
    onblurInput () {
      this.loginForm.username = this.loginForm.username ? this.loginForm.username.trim() : ''
      this.loginForm.password = this.loginForm.password ? this.loginForm.password.trim() : ''
      if (this.loginForm.username === '') {
        this.$refs.username.focus()
      } else if (this.loginForm.password === '') {
        this.$refs.password.focus()
      }
    }
    // afterQRScan() {
    //   if (e.key === 'x-admin-oauth-code') {
    //     const code = getQueryObject(e.newValue)
    //     const codeMap = {
    //       wechat: 'code',
    //       tencent: 'code'
    //     }
    //     const type = codeMap[this.auth_type]
    //     const codeName = code[type]
    //     if (codeName) {
    //       this.$store.dispatch('LoginByThirdparty', codeName).then(() => {
    //         this.$router.push({ path: this.redirect || '/' })
    //       })
    //     } else {
    //       alert('第三方登录失败')
    //     }
    //   }
    // }
  }
}
</script>

<style lang="scss">
// /* 修复input 背景不协调 和光标变色 */
// /* Detail see https://github.com/PanJiaChen/vue-element-admin/pull/927 */

// $bg:#283443;
// $light_gray:#fff;
// $cursor: #fff;

// @supports (-webkit-mask: none) and (not (cater-color: $cursor)) {
//   .login-container .el-input input {
//     color: $cursor;
//   }
// }

// /* reset element-ui css */
// .login-container {
//   .el-input {
//     display: inline-block;
//     height: 47px;
//     width: 85%;

//     input {
//       background: transparent;
//       border: 0px;
//       -webkit-appearance: none;
//       border-radius: 0px;
//       padding: 12px 5px 12px 15px;
//       color: $light_gray;
//       height: 47px;
//       caret-color: $cursor;

//       &:-webkit-autofill {
//         box-shadow: 0 0 0px 1000px $bg inset !important;
//         -webkit-text-fill-color: $cursor !important;
//       }
//     }
//   }

//   .el-form-item {
//     border: 1px solid rgba(255, 255, 255, 0.1);
//     background: rgba(0, 0, 0, 0.1);
//     border-radius: 5px;
//     color: #454545;
//   }
// }
// </style>

// <style lang="scss" scoped>
// $bg:#2d3a4b;
// $dark_gray:#889aa4;
// $light_gray:#eee;

// .login-container {
//   // min-height: 100%;
//   height: 100vh;
//   width: 100vw;
//   background-color: $bg;
//   overflow: hidden;

//   .login-form {
//     position: relative;
//     width: 520px;
//     max-width: 100%;
//     padding: 160px 35px 0;
//     margin: 0 auto;
//     overflow: hidden;
//   }

//   .tips {
//     font-size: 14px;
//     color: #fff;
//     margin-bottom: 10px;

//     span {
//       &:first-of-type {
//         margin-right: 16px;
//       }
//     }
//   }

//   .svg-container {
//     padding: 6px 5px 6px 15px;
//     color: $dark_gray;
//     vertical-align: middle;
//     width: 30px;
//     display: inline-block;
//   }

//   .title-container {
//     position: relative;

//     .title {
//       font-size: 26px;
//       color: $light_gray;
//       margin: 0px auto 40px auto;
//       text-align: center;
//       font-weight: bold;
//     }
//   }

//   .show-pwd {
//     position: absolute;
//     right: 10px;
//     top: 7px;
//     font-size: 16px;
//     color: $dark_gray;
//     cursor: pointer;
//     user-select: none;
//   }

//   .thirdparty-button {
//     position: absolute;
//     right: 0;
//     bottom: 6px;
//   }

//   @media only screen and (max-width: 470px) {
//     .thirdparty-button {
//       display: none;
//     }
//   }
// }
$bg        : #283443;
$cursor    : #fff;
$dark_gray : #889aa4;
$light_gray: #fff;

@supports (-webkit-mask: none) and (not (cater-color: $cursor)) {
  .login-container .el-input input {
    color: $bg;
  }
}

/* reset element-ui css */
.login-container {
  .el-input {
    display: inline-block;
    height : 40px;
    width  : 86%;

    input {
      background        : transparent;
      border            : 0px;
      -webkit-appearance: none;
      border-radius     : 0px;
      padding           : 12px 5px 12px 15px;
      color             : $bg;
      height            : 40px;
      caret-color       : $bg;

      &:-webkit-autofill {
        // box-shadow: 0 0 0px 1000px $cursor inset !important;
        -webkit-text-fill-color: $bg !important;
      }
    }
  }

  .el-form-item {
    border       : 1px solid rgba(255, 255, 255, 0.1);
    background   : rgba(0, 0, 0, 0.1);
    border-radius: 5px;
    color        : #454545;
  }
}

.login-container {
  min-height: 100%;
  width     : 100%;
  // background-color: $bg;
  overflow  : hidden;

  .login-form {
    position : relative;
    width    : 500px;
    max-width: 100%;
    padding  : 20px 50px 0;
    // padding  : 60px 50px 0;
    margin   : 0 auto;
    overflow : hidden;
  }

  .tips {
    font-size    : 14px;
    color        : #fff;
    margin-bottom: 10px;

    span {
      &:first-of-type {
        margin-right: 16px;
      }
    }
  }

  .el-input input {
    color: #000000 !important;
  }

  .svg-container {
    padding       : 5px 5px 5px 8px;
    color         : $dark_gray;
    vertical-align: middle;
    width         : 30px;
    display       : inline-block;
  }

  .title-container {
    position: relative;

    .title {
      font-size  : 26px;
      color      : $light_gray;
      margin     : 0px auto 40px auto;
      text-align : center;
      font-weight: bold;
    }
  }

  .show-pwd {
    position   : absolute;
    right      : 2px;
    top        : 7px;
    font-size  : 16px;
    color      : $dark_gray;
    cursor     : pointer;
    user-select: none;
  }

  .thirdparty-button {
    position: absolute;
    right   : 0;
    bottom  : 6px;
  }

  @media only screen and (max-width: 470px) {
    .thirdparty-button {
      display: none;
    }
  }
}
.background-image-login {
  min-height       : 100%;
  width            : 100%;
  height           : 100vh;
  background-color : $bg;
  overflow         : hidden;
  background-repeat: no-repeat;
  background-size  : 100% 100%;
  --opacidad-negro : 0.6;
  background-image : linear-gradient(rgba(0, 0, 0, var(--opacidad-negro)), rgba(0, 0, 0, var(--opacidad-negro))), url("~@/assets/lib_imagenes/soa_persona_feliz.png");
}

.contenedor {
  position       : relative;
  display        : flex;
  justify-content: center;
  align-items    : center;
}

.logo-img {
  // width             : 50%;
  width             : min(60vw, 260px);
  // -moz-box-shadow   : 0px 0px 30px #ffffff;
  // -webkit-box-shadow: 0px 0px 30px #ffffff;
  // box-shadow        : 0px 0px 30px #ffffff;
}

.card-box {
  margin-right    : auto;
  margin-left     : auto;
  width           : 100%;
  box-shadow      : 0 15px 25px rgba(129, 124, 124, 0.2);
  height          : 100%;
  border-radius   : 5px;
  backdrop-filter : blur(5px);
  background-color: rgba(255, 255, 255, 0.1);
  padding         : 5px;
  text-align      : center;
  border-color    : transparent;
}

.color-text {
  color: #000000 !important;
}
</style>
