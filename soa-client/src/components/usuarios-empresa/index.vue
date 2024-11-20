<template lang="pug">
el-form(ref='form' :model='form' label-width='100px' size="mini" :label-position="isMovil ? 'top' : 'right'" :rules="rules" class="demo-formusuario")
  //- el-input.is-uppercase(v-if="tipoaccion === 2" size='mini' placeholder='ID' v-model='idusuarioempresa')
  el-row.margin-bottom-20px
    el-col(:xs="24" :sm="24" :md="24" :lg="24" :xl="24")
      el-form-item(label='Empresa' prop='idempresa' align='left' size='mini')
        el-select.width-total(v-model='form.idempresa' clearable='' placeholder='Seleccione empresa' size='mini' :disabled="cargandoInformacion || isLoadingEmpresas || tipoaccion === 2")
          el-option(v-for='item in listaEmpresas' :key='item.idempresa' :label='item.nombre' :value='item.idempresa')
    el-col(:xs="24" :sm="24" :md="24" :lg="24" :xl="24")
      el-form-item(label='Usuario' prop='idusuario' align='left' size='mini')
        el-select.width-total(v-model='form.idusuario' clearable='' placeholder='Seleccione usuario' size='mini' :disabled="cargandoInformacion || isLoadingUsuarios || tipoaccion === 2")
          el-option(v-for='item in listaUsuarios' :key='item.idusuario' :label='item.nombre' :value='item.idusuario')
            span(style='float: left') {{ item.paterno }} {{ item.materno }} {{ item.nombre }}
            span(style='float: right; color: #8492a6; font-size: 12px') {{ item.login }}
    el-col(:xs="24" :sm="24" :md="24" :lg="24" :xl="24")
      el-form-item(label='Rol' prop='idrol' align='left' size='mini')
        el-select.width-total(v-model='form.idrol' clearable='' placeholder='Seleccione rol' size='mini' :disabled="cargandoInformacion || isLoadingRoles")
          el-option(v-for='item in listaRoles' :key='item.idrol' :label='item.nombre' :value='item.idrol')
  el-form-item
    el-row
      el-col(:span='12')
        el-button(type='primary' size='mini' @click='onSubmit' style='width: 99%;' :disabled="cargandoInformacion") Aceptar
      el-col(:span='12')
        el-button(size='mini' @click="close()" style='width: 99%;' :disabled="cargandoInformacion") Cancelar
</template>

<script>

import { usuariosempresaMantenimiento } from '@/api/usuarios-empresa'
import { empresasLista }                from '@/api/empresas'
import { usuariosLista }                from '@/api/usuarios'
import { rolesLista }                   from '@/api/roles'
import { notify }                       from '@/utils/general.js'
import { mapState }                     from 'vuex'
export default {
  name: 'FormTiposPersonal',
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
        tipo            : -1,
        idusuarioempresa: null,
        idempresa       : null,
        idusuario       : null,
        idrol           : null,
        usuarioregistro : '',
        fecharegistro   : new Date()
      },
      tableKey           : 0,
      objAux             : {},
      listaEmpresas      : [],
      listaUsuarios      : [],
      listaRoles         : [],
      isLoadingEmpresas  : false,
      isLoadingUsuarios  : false,
      isLoadingRoles     : false,
      cargandoInformacion: false,
      isTrue             : false,
      rules              : {},
      isMovil            : JSON.parse(localStorage.getItem('isMovil'))
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
    vm.fetchEmpresa()
    vm.fetchUsuarios()
    vm.fetchRoles()
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
    fetchEmpresa () {
      var vm                = this
      vm.listaEmpresas      = []
      vm.isLoadingEmpresas  = true
      var obj               = {
        idestado: 2
      }
      empresasLista(obj).then(data => {
        console.log('data empresas:  ', data)
        for (let i = 0; i < data.lista.length; i++) {
          vm.listaEmpresas.push(data.lista[i])
        }
        vm.isLoadingEmpresas = vm.isLoading
      }, function (err) {
        vm.isLoadingEmpresas = vm.isLoading
        notify(vm, 'error', 'Error', err.message)
      }, function () {
        vm.isLoadingEmpresas = false
      })
    },
    fetchUsuarios () {
      var vm                = this
      vm.listaUsuarios      = []
      vm.isLoadingUsuarios  = true
      var obj               = {
        idestado: 2
      }
      usuariosLista(obj).then(data => {
        console.log('data usuarios:  ', data)
        for (let i = 0; i < data.lista.length; i++) {
          vm.listaUsuarios.push(data.lista[i])
        }
        vm.isLoadingUsuarios = vm.isLoading
      }, function (err) {
        vm.isLoadingUsuarios = vm.isLoading
        notify(vm, 'error', 'Error', err.message)
      }, function () {
        vm.isLoadingUsuarios = false
      })
    },
    fetchRoles () {
      var vm                = this
      vm.listaRoles      = []
      vm.isLoadingRoles  = true
      var obj               = {}
      rolesLista(obj).then(data => {
        console.log('data roles:  ', data)
        for (let i = 0; i < data.lista.length; i++) {
          vm.listaRoles.push(data.lista[i])
        }
        vm.isLoadingRoles = vm.isLoading
      }, function (err) {
        vm.isLoadingRoles = vm.isLoading
        notify(vm, 'error', 'Error', err.message)
      }, function () {
        vm.isLoadingRoles = false
      })
    },
    cargarDatosVacios () {
      var vm          = this
      vm.form = {
        idusuarioempresa: null,
        idempresa        : '',
        idusuario        : '',
        idrol            : '',
        usuarioregistro  : '',
        fecharegistro    : ''
      }
    },
    cargarDatos () {
      var vm = this
      vm.cargarDatosVacios()
      if (vm.tipoaccion === 1) {
        vm.cargarDatosVacios()
      } else {
        vm.form = {
          idusuarioempresa: vm.model.idusuarioempresa,
          idempresa       : vm.model.idempresa,
          idusuario       : vm.model.idusuario,
          idrol           : vm.model.idrol,
          usuarioregistro : vm.model.usuarioregistro,
          fecharegistro   : vm.model.fecharegistro
        }
      }
    },
    onSubmit() {
      var vm          = this
      if (!vm.form.idempresa || vm.form.idusuario === null || vm.form.idrol === undefined) {
        notify(vm, 'error', 'Error', 'No puede estar vacio, Debe ingresar los campos.')
        return
      }
      vm.cargandoInformacion  = true
      var arreglo          = {
        idusuarioempresa: vm.form.idusuarioempresa,
        idempresa       : vm.form.idempresa,
        idusuario       : vm.form.idusuario,
        idrol           : vm.form.idrol,
        usuarioregistro : vm.form.usuarioregistro,
        fecharegistro   : vm.form.fecharegistro
      }
      var obj = {
        tipoaccion: vm.tipoaccion,
        arreglo   : arreglo
      }
      usuariosempresaMantenimiento(obj).then(data => {
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
