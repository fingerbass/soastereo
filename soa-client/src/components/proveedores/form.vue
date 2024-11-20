<template lang="pug">
  el-form(
    ref="form"
    :model="form"
    label-width="120px"
    size="mini"
    :label-position="isMovil ? 'top' : 'right'"
    :rules="rules"
    class="demo-formusuario"
  )
    el-row
      el-col(:xs="24" :sm="24" :md="24" :lg="24" :xl="24")
        el-form-item(label="Nombre" prop="nombre")
          el-input(
            v-model="form.nombre"
            placeholder="Ingrese nombre del proveedor"
            clearable
          )

      el-col(:xs="24" :sm="24" :md="24" :lg="24" :xl="24")
        el-form-item(label="Email" prop="email")
          el-input(
            v-model="form.email"
            placeholder="Ingrese email"
            clearable
          )

      el-col(:xs="24" :sm="12" :md="12" :lg="12" :xl="12")
        el-form-item(label="Teléfono" prop="telefono")
          el-input(
            v-model="form.telefono"
            placeholder="Ingrese teléfono"
            clearable
          )

      el-col(:xs="24" :sm="12" :md="12" :lg="12" :xl="12")
        el-form-item(label="Categoría" prop="idcategoria")
          el-select(
            v-model="form.idcategoria"
            placeholder="Seleccione categoría"
            style="width: 100%"
            clearable
          )
            el-option(
              v-for="item in categorias"
              :key="item.idcategoria"
              :label="item.nombre"
              :value="item.idcategoria"
            )

      el-col(:xs="24" :sm="24" :md="24" :lg="24" :xl="24")
        el-form-item(label="Dirección" prop="direccion")
          el-input(
            type="textarea"
            :rows="2"
            v-model="form.direccion"
            placeholder="Ingrese dirección"
          )

      el-col(:xs="24" :sm="8" :md="8" :lg="8" :xl="8")
        el-form-item(label="Reputación")
          el-rate(
            v-model="form.reputacion"
            :max="5"
            disabled
            show-score
            text-color="#ff9900"
          )

      el-col(:xs="24" :sm="8" :md="8" :lg="8" :xl="8")
        el-form-item(label="Verificado")
          el-switch(
            v-model="form.verificado"
            active-color="#13ce66"
            inactive-color="#ff4949"
          )

      el-col(:xs="24" :sm="8" :md="8" :lg="8" :xl="8")
        el-form-item(label="Activo")
          el-switch(
            v-model="form.activo"
            active-color="#13ce66"
            inactive-color="#ff4949"
          )

    el-form-item
      el-row
        el-col(:xs="12" :sm="12" :md="12" :lg="12" :xl="12")
          el-button(
            type="primary"
            size="mini"
            @click="onSubmit"
            style="width: 95%"
            :disabled="cargandoInformacion"
          ) Aceptar
        el-col(:xs="12" :sm="12" :md="12" :lg="12" :xl="12")
          el-button(
            size="mini"
            @click="close"
            style="width: 95%"
            :disabled="cargandoInformacion"
          ) Cancelar
  </template>

<script>
import { proveedoresMantenimiento } from '@/api/proveedores'
import { getCategoriasSelect } from '@/api/proveedores'
import { notify } from '@/utils/general.js'
import { mapState } from 'vuex'

export default {
  name: 'FormProveedor',
  props: {
    title: {
      type: String,
      required: true,
      default: ''
    },
    tipoaccion: {
      type: Number,
      required: true,
      default: 1
    },
    model: {
      type: Object,
      required: false,
      default() {
        return {}
      }
    }
  },
  data() {
    return {
      form: {
        id: null,
        nombre: '',
        email: '',
        telefono: '',
        direccion: '',
        reputacion: 0,
        verificado: false,
        activo: true,
        idcategoria: null,
        usuarioregistro: localStorage.getItem('username')
      },
      categorias: [],
      cargandoInformacion: false,
      rules: {
        nombre: [
          { required: true, message: 'Por favor ingrese el nombre', trigger: 'blur' },
          { min: 3, message: 'El nombre debe tener al menos 3 caracteres', trigger: 'blur' }
        ],
        email: [
          { required: true, message: 'Por favor ingrese el email', trigger: 'blur' },
          { type: 'email', message: 'Por favor ingrese un email válido', trigger: 'blur' }
        ],
        idcategoria: [
          { required: true, message: 'Por favor seleccione una categoría', trigger: 'change' }
        ]
      },
      isMovil: JSON.parse(localStorage.getItem('isMovil'))
    }
  },
  computed: {
    ...mapState('loading', ['isLoading'])
  },
  created() {
    this.cargarDatos()
  },
  methods: {
    cargarCategorias() {
      getCategoriasSelect().then(response => {
        console.log(response)
        this.categorias = response.lista
      }).catch(error => {
        console.log(error)
        notify(this, 'error', 'Error', 'Error al cargar categorías')
      })
    },
    cargarDatos() {
      this.cargarDatosVacios()
      if (this.tipoaccion === 2 && !this.isObjEmpty(this.model)) {
        this.form = {
          id: this.model.id,
          nombre: this.model.nombre,
          email: this.model.email,
          telefono: this.model.telefono,
          direccion: this.model.direccion,
          reputacion: this.model.reputacion || 0,
          verificado: this.model.verificado,
          activo: this.model.activo,
          idcategoria: this.model.idcategoria,
          usuarioregistro: this.model.usuarioregistro
        }
      }
      this.cargarCategorias()
    },
    cargarDatosVacios() {
      this.form = {
        id: null,
        nombre: '',
        email: '',
        telefono: '',
        direccion: '',
        reputacion: 0,
        verificado: false,
        activo: true,
        idcategoria: null,
        usuarioregistro: localStorage.getItem('username')
      }
    },
    isObjEmpty(obj) {
      return !obj || Object.keys(obj).length === 0
    },
    async onSubmit() {
      try {
        await this.$refs.form.validate()
      } catch (error) {
        return
      }

      this.cargandoInformacion = true

      try {
        await proveedoresMantenimiento({
          tipoaccion: this.tipoaccion,
          arreglo: this.form
        })

        this.save()
        this.close()
        notify(this, 'success', 'Éxito', 'Proveedor guardado correctamente')
      } catch (error) {
        notify(this, 'error', 'Error', error.message || 'Error al guardar el proveedor')
      } finally {
        this.cargandoInformacion = false
      }
    },
    save() {
      this.$emit('save')
    },
    close() {
      this.$emit('close')
    }
  }
}
</script>

  <style lang="scss" scoped>
  .el-rate {
    margin-top: 8px;
  }
  .el-switch {
    margin-top: 8px;
  }
  </style>
