<template lang="pug">
el-dialog(title='Restablecer Contraseña' :visible.sync='modal' :width="isMovil ? '90%' : '50%'" center='' :close-on-click-modal='false' :close-on-press-escape='false' :show-close='false')
  span Para restablecer tu contraseña es necesario que indiques el nombre de usuario, te remitiremos un mensaje a tu correo electronico con una clave temporal que podras utilizar.
  el-form(ref='loginForm' :model='loginForm' autocomplete='on' label-position='left')
    el-form-item.margin-top-20(prop='password')
      el-input.margin-top-35(ref='usuario' size='mini' placeholder='Ingrese usuario' v-model='usuario' :disabled="isLoading" :max="50" clearable show-word-limit)
  span.dialog-footer(slot='footer')
    el-row
      el-col(:xs='24' :sm='12' :md='12' :lg='12' :xl='12')
        el-button.margin-left-5(type='primary' size='small' style="width: 95%" @click="restablecercontrasena()" :loading='isLoading' :disabled="isLoading") Aceptar
      el-col(:xs='24' :sm='12' :md='12' :lg='12' :xl='12')
        el-button(size='small' style="width: 95%" @click="cancelar()" :disabled="isLoading") Cancelar
</template>

<script>
import { usuariospasswordRestablecer }  from '@/api/usuarios-password'
import { notify }                       from '@/utils/general'

export default {
  name: 'LoginContrasenaRestablecer',
  components: {},
  props: {
    modal: {
      type: Boolean
    }
  },
  data() {
    return {
      centerDialogVisible: true,
      usuario            : '',
      isLoading          : false,
      loginForm: {
        usuario:''
      },
      isMovil: JSON.parse(localStorage.getItem('isMovil'))
    }
  },
  computed: {
  },
  created() {
  },
  mounted() {
    var vm = this
    vm.$nextTick(function () {
      vm.usuario = vm.usuario ? vm.usuario.trim() : ''
      if (vm.usuario === '') {
        vm.$refs.usuario.focus()
      }
    })
  },
  methods: {
    cancelar() {
      var vm     = this
      vm.modal = false
      vm.$emit('close')
    },
    restablecercontrasena() {
      var vm = this
      // vm.$emit('close')
      if (!vm.usuario || vm.usuario === null || vm.usuario === undefined) {
        notify(vm, 'error', 'Error', 'No puede estar vacio, Debe ingresar una contraseña.')
        return
      }
      vm.cargandoInformacion  = true
      var obj                 = {
        usuario   : vm.usuario,
        restablece: 1
      }
      console.log('obj:>>> ', obj)
      usuariospasswordRestablecer(obj).then(data => {
        vm.cargandoInformacion  = false
        vm.modal              = false
        if (data.status === 1) {
          var texto               = 'Se ah enviado un correo con la contraseña.'
          notify(vm, 'success', 'Éxito', texto)
        }
        vm.$emit('close')
      }, function (err) {
        vm.cargandoInformacion = false
        notify(vm, 'error', 'Error', err.message)
      }, function () {
        vm.cargandoInformacion = false
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.margin-top-35 {
  margin-top: 35px !important;
}
.margin-left-5 {
  margin-left: 5px !important;
}
.width-100 {
  width: 100% !important;
}
</style>
