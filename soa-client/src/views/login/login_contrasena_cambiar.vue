<template lang="pug">
el-dialog(title='Cambiar contraseña' :modal="false" style="width: 100%;" :visible.sync='modalAux' :width="isMovil ? '90%' : '50%'" center='' :close-on-click-modal='false' :close-on-press-escape='false' :show-close='false')
  div.text-align-center
    p.bold {{ nombre}}
    p.bold {{ login }}
  p(v-if="proviniente === 1") En necesario cambiar su contraseña.
  p(v-if="proviniente === 1") Ingrese nueva contraseña para cambiar.
  el-form(ref='form' status-icon :model='form' size="mini" :rules="rules" :show-message="false" class="demo-form")
    el-form-item(prop="passwordActual")
      el-input.margin-top-30(:type="passwordType" :key='passwordType' v-model='form.passwordActual' ref='passwordActual' size='mini' placeholder='Contraseña Actual' @keyup.enter.native='continuar(tipoaccion)' :disabled="cargandoInformacion" show-password)
    el-form-item(prop="passwordNueva")
      el-input.margin-top-30(:type="passwordType" :key='passwordType' v-model='form.passwordNueva' ref='password' size='mini' placeholder='Nueva Contraseña' @keyup.enter.native='continuar(tipoaccion)' :disabled="cargandoInformacion" show-password)
    el-form-item(prop="password")
      el-input.margin-top-30(:type="passwordType" :key='passwordType' v-model='form.password' ref='password' size='mini' placeholder='Reingrese contraseña nueva' @keyup.enter.native='continuar(tipoaccion)' :disabled="cargandoInformacion" show-password)
  span.dialog-footer(slot='footer')
    el-row
      el-col(:xs='24' :sm='12' :md='12' :lg='12' :xl='12')
        el-button(type='primary' size='mini' @click="continuar(tipoaccion)" :loading='cargandoInformacion' style='width: 95%;' :disabled="cargandoInformacion || !form.password || form.password === null || form.password === undefined") Aceptar
      el-col(:xs='24' :sm='12' :md='12' :lg='12' :xl='12')
        el-button(size='mini' @click="cancelar()" style='width: 95%;' :disabled="cargandoInformacion") Cancelar
</template>

<script>
import { usuariospasswordCambiar }  from '@/api/usuarios-password'
import { notify }                   from '@/utils/general'
import { mapState }                 from 'vuex'

export default {
  name: 'LoginContrasenaCambiar',
  components: {},
  props: {
    modal: {
      type: Boolean,
      default: true
    },
    tipoaccion: {
      type   : Number,
      default: 1
    },
    proviniente: {
      type   : Number,
      default: 1
    }
  },
  data() {
    var validate = (rule, value, callback) => {
      var vm              = this
      value               = value ? value.trim() : value
      vm.passwordTemporal = vm.passwordTemporal ? vm.passwordTemporal.trim() : ''
      if (value !== vm.passwordTemporal) {
        callback(new Error('Contraseña incorrecta.'))
      } else {
        callback()
      }
    }
    var validate2 = (rule, value, callback) => {
      var vm                = this
      value                 = value ? value.trim() : value
      vm.form.passwordNueva = vm.form.passwordNueva ? vm.form.passwordNueva.trim() : ''
      if (value !== vm.form.passwordNueva) {
        callback(new Error('Contraseña es incorrecta al nuevo.'))
      } else {
        callback()
      }
    }
    return {
      centerDialogVisible: true,
      form:{
        passwordActual: '',
        passwordNueva : '',
        password      : ''
      },
      passwordTemporal   : localStorage.getItem('passwordTemporal'),
      nombre             : localStorage.getItem('nombre'),
      login              : localStorage.getItem('login'),
      passwordType       : 'password',
      modalAux           : this.modal,
      cargandoInformacion: false,
      rules              : {
        passwordActual: [
          { validator: validate, trigger: 'blur' }
        ],
        password: [
          { validator: validate2, trigger: 'blur' }
        ]
      },
      isMovil: JSON.parse(localStorage.getItem('isMovil'))
    }
  },
  computed: {
    ...mapState('loading', ['isLoading'])
  },
  crated() {
    var vm = this
    vm.passwordTemporal = localStorage.getItem('passwordTemporal')
    // console.log(vm.passwordTemporal)
  },
  mounted() {
    var vm = this
    vm.modalAux = true
    vm.passwordTemporal = localStorage.getItem('passwordTemporal')
    // console.log(vm.passwordTemporal)
  },
  methods: {
    showPwd() {
      var vm = this
      if (vm.passwordType === 'password') {
        vm.passwordType = ''
      } else {
        vm.passwordType = 'password'
      }
      vm.$nextTick(() => {
        vm.$refs.password.focus()
      })
    },
    // validarContrasena () {
    //   var vm = this
    //   var passwordTemporal = localStorage.getItem('passwordTemporal')
    //   if (vm.passwordActual === passwordTemporal) {

    //   }
    // },
    continuar(tipoaccion) {
      var vm = this
      vm.form.password = vm.form.password ? vm.form.password.trim() : ''
      if (!vm.form.password || vm.form.password === null || vm.form.password === undefined) {
        notify(vm, 'error', 'Error', 'No puede estar vacio, Debe ingresar una contraseña.')
        return
      }
      if (vm.form.password) {
        if (vm.form.password.length < 6) {
          notify(vm, 'error', 'Error', 'Debe ingresar una contraseña mas de 6 digitos.')
          return
        }
      }
      vm.cargandoInformacion  = true
      var obj                 = {
        tipoaccion       : tipoaccion,
        idusuario        : localStorage.getItem('idusuario'),
        idusuario2       : localStorage.getItem('idusuario'),
        idusuariopassword: localStorage.getItem('idusuario'),
        password         : vm.form.password ? vm.form.password.trim() : '',
        restablece       : 0
      }
      console.log(obj)
      usuariospasswordCambiar(obj).then(data => {
        vm.cargandoInformacion  = vm.isLoading
        var texto               = 'Se ha cambiado la contraseña correctamente.'
        vm.modalAux           = false
        notify(vm, 'success', 'Éxito', texto)
        vm.$emit('close')
      }, function (err) {
        vm.cargandoInformacion = vm.isLoading
        notify(vm, 'error', 'Error', err.message)
      }, function () {
        vm.cargandoInformacion = false
      })
    },
    cancelar () {
      var vm = this
      if (vm.proviniente  === 1) {
        vm.logout()
      } else {
        vm.$emit('close')
      }
    },
    async logout() {
      await this.$store.dispatch('user/logout')
      this.$router.push(`/login?redirect=${this.$route.fullPath}`)
    }
  }
}
</script>

<style lang="scss" scoped>
$bg        : #283443;
$cursor    : #fff;
$dark_gray : #889aa4;
$light_gray: #fff;
.margin-top-30 {
  margin-top: 30px !important;
}
.margin-left-5 {
  margin-left: 5px !important;
}
.width-100 {
  width: 100% !important;
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

.v-modal {
    position: unset;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    opacity: 0.5;
    background: #000000;
}
</style>
