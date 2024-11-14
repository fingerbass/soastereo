<template lang="pug">
el-form(ref='form' :model='form' label-width='120px' size="mini" label-position="top" :rules="rules" class="demo-formusuario")
  //- el-input.is-uppercase(v-if="tipoaccion === 2" size='mini' placeholder='ID' v-model='idrol')
  el-row
    el-col(:xs="24" :sm="24" :md="24" :lg="24" :xl="24")
      el-form-item(label='Nombre' size='mini')
        el-input.is-uppercase(size='mini' placeholder='Nombre' v-model='form.nombre' maxlength="50" show-word-limit)
    el-col(:xs="24" :sm="24" :md="24" :lg="24" :xl="24")
      el-form-item(label='Activo' size='mini')
        el-switch(size='mini' placeholder='Activo' v-model='form.activo' active-color="#1890ff" inactive-color="#ff4949")
  el-form-item
    el-row
      el-col(:xs="12" :sm="12" :md="12" :lg="12" :xl="12")
        el-button(type='primary' size='mini' @click='onSubmit' style='width: 95%;' :disabled="cargandoInformacion") Aceptar
      el-col(:xs="12" :sm="12" :md="12" :lg="12" :xl="12")
        el-button(size='mini' @click="close()" style='width: 100%;' :disabled="cargandoInformacion") Cancelar
</template>

<script>
import { rolesMantenimiento } from '@/api/roles'
import { notify }             from '@/utils/general.js'
import { mapState }           from 'vuex'
export default {
  name: 'FormRol',
  props: {
    title: {
      type    : String,
      required: true,
      default : ''
    },
    tipoaccion: {
      type    : Number,
      required: true,
      default : 1
    },
    model: {
      type    : Object,
      required: false,
      default() {
        return {}
      }
    }
  },
  data() {
    return {
      form: {
        idrol          : null,
        nombre         : '',
        activo         : true,
        usuarioregistro: localStorage.getItem('username'),
        fecharegistro  : ''
      },
      cargandoInformacion: false,
      rules: {
        name: [
          { required: true, message: 'Please input Activity name', trigger: 'blur' },
          { min: 3, max: 5, message: 'Length should be 3 to 5', trigger: 'blur' }
        ],
        region: [
          { required: true, message: 'Please select Activity zone', trigger: 'change' }
        ],
        date1: [
          { type: 'date', required: true, message: 'Please pick a date', trigger: 'change' }
        ],
        date2: [
          { type: 'date', required: true, message: 'Please pick a time', trigger: 'change' }
        ],
        type: [
          { type: 'array', required: true, message: 'Please select at least one activity type', trigger: 'change' }
        ],
        resource: [
          { required: true, message: 'Please select activity resource', trigger: 'change' }
        ],
        desc: [
          { required: true, message: 'Please input activity form', trigger: 'blur' }
        ]
      }
    }
  },
  computed: {
    ...mapState('loading', ['isLoading'])
  },
  created () {
    var vm = this
    console.log('vm.title', vm.title)
    console.log('vm.tipoaccion', vm.tipoaccion)
    console.log('vm.model', vm.model)
    vm.cargarDatos()
  },
  methods: {
    isObjEmpty (obj) {
      // console.log('obj:>>> ', obj)
      // var verificar = Object.keys(obj).length === 0
      // console.log('verificar:>>> ', verificar)
      // return verificar
      if (JSON.stringify(obj) === '{}' || obj === null || obj === undefined) {
        return true
      }
    },
    cargarDatosVacios () {
      var vm          = this
      vm.form = {
        idrol          : null,
        nombre         : '',
        activo         : true,
        usuarioregistro: localStorage.getItem('username'),
        fecharegistro  : ''
      }
    },
    cargarDatos () {
      var vm = this
      vm.cargarDatosVacios()
      if (vm.tipoaccion === 1) {
        vm.cargarDatosVacios()
      } else {
        vm.form = {
          idrol          : vm.model.idrol,
          nombre         : vm.model.nombre,
          activo         : vm.model.activo,
          usuarioregistro: vm.model.usuarioregistro,
          fecharegistro  : vm.model.fecharegistro
        }
      }
    },
    onSubmit() {
      var vm                  = this
      vm.cargandoInformacion  = true
      var arreglo          = {
        idrol          : vm.form.idrol,
        nombre         : vm.form.nombre,
        activo         : vm.form.activo,
        usuarioregistro: vm.form.usuarioregistro,
        fecharegistro  : vm.form.fecharegistro
      }
      var obj = {
        tipoaccion: vm.tipoaccion,
        arreglo: arreglo
      }
      rolesMantenimiento(obj).then(data => {
        console.log('data: ', data)
        vm.cargandoInformacion = vm.isLoading
        vm.save()
        vm.close()
        notify(vm, 'success', 'Éxito', 'El registro se ah guardado satisfactoriamente.')
      }, function (err) {
        console.log(err)
        vm.cargandoInformacion = vm.isLoading
        notify(vm, 'error', 'Error', err.message)
      }, function () {
        vm.cargandoInformacion = false
      })
    },
    save () {
      this.$emit('save')
    },
    close () {
      this.$emit('close')
    },
    submitForm(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          alert('submit!')
        } else {
          console.log('error submit!!')
          return false
        }
      })
    },
    resetForm(formName) {
      this.$refs[formName].resetFields()
    }
  }
}
</script>

<style lang="scss" scoped>
.text-align-center {
  text-align: center
}
.margin-bottom-20px {
  margin-bottom: 20px
}
.el-dialog__header {
  text-align: center
}
</style>
