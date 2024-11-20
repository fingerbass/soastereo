<template lang="pug">
el-form(ref="form" :model="form" label-width="120px" size="mini" :label-position="isMovil ? 'top' : 'right'" :rules="rules" class="demo-formusuario")
  el-row(:gutter="20")
    el-col(:xs="24" :sm="24" :md="24" :lg="24" :xl="24")
      el-form-item(label="Proveedor" size="mini" prop="proveedor_id")
        el-select(
          v-model="form.proveedor_id"
          placeholder="Seleccione Proveedor"
          style="width: 100%"
          clearable
        )
          el-option(
            v-for="item in proveedores"
            :key="item.id"
            :label="item.nombre"
            :value="item.id"
          )
    el-col(:xs="24" :sm="24" :md="24" :lg="24" :xl="24")
      el-form-item(label="Evento" size="mini" prop="evento_id")
        el-select(
          v-model="form.evento_id"
          placeholder="Seleccione Evento"
          style="width: 100%"
          clearable
        )
          el-option(
            v-for="item in eventos"
            :key="item.id"
            :label="item.nombre"
            :value="item.id"
          )
    el-col(:xs="24" :sm="24" :md="24" :lg="24" :xl="24")
      el-form-item(label="Puntuación" size="mini" prop="puntuacion")
        el-rate(
          v-model="form.puntuacion"
          :colors="rateColors"
          show-text
          :texts="rateTexts"
          style="margin-top: 8px"
        )
    el-col(:xs="24" :sm="24" :md="24" :lg="24" :xl="24")
      el-form-item(label="Comentario" size="mini" prop="comentario")
        el-input(
          type="textarea"
          :rows="3"
          v-model="form.comentario"
          placeholder="Ingrese un comentario sobre la evaluación"
        )
  el-form-item(class="dialog-footer")
    el-row(:gutter="20")
      el-col(:xs="12" :sm="12" :md="12" :lg="12" :xl="12")
        el-button(
          type="primary"
          size="mini"
          @click="onSubmit"
          style="width: 100%"
          :disabled="cargandoInformacion"
        ) Aceptar
      el-col(:xs="12" :sm="12" :md="12" :lg="12" :xl="12")
        el-button(
          size="mini"
          @click="close"
          style="width: 100%"
          :disabled="cargandoInformacion"
        ) Cancelar
</template>

<script>
import { evaluacionMantenimiento } from '@/api/evaluacion'
import { getProveedores, getEventos } from '@/api/evaluacion'
import { notify } from '@/utils/general.js'
import { mapState } from 'vuex'

export default {
  name: 'FormEvaluacion',
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
        proveedor_id: null,
        evento_id: null,
        puntuacion: 0,
        comentario: '',
        usuarioregistro: localStorage.getItem('username'),
        fecharegistro: ''
      },
      proveedores: [],
      eventos: [],
      cargandoInformacion: false,
      rateColors: ['#99A9BF', '#F7BA2A', '#FF9900'],
      rateTexts: ['Malo', 'Regular', 'Bueno', 'Muy Bueno', 'Excelente'],
      rules: {
        proveedor_id: [
          { required: true, message: 'Por favor seleccione un proveedor', trigger: 'change' }
        ],
        evento_id: [
          { required: true, message: 'Por favor seleccione un evento', trigger: 'change' }
        ],
        puntuacion: [
          { required: true, message: 'Por favor ingrese una puntuación', trigger: 'change' }
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
    this.cargarProveedores()
    this.cargarEventos()
  },
  methods: {
    cargarProveedores() {
      getProveedores().then(response => {
        this.proveedores = response.lista
      }).catch(error => {
        notify(this, 'error', 'Error', error.message)
      })
    },
    cargarEventos() {
      getEventos().then(response => {
        this.eventos = response.lista
      }).catch(error => {
        notify(this, 'error', 'Error', error.message)
      })
    },
    cargarDatosVacios() {
      this.form = {
        id: null,
        proveedor_id: null,
        evento_id: null,
        puntuacion: 0,
        comentario: '',
        usuarioregistro: localStorage.getItem('username'),
        fecharegistro: ''
      }
    },
    cargarDatos() {
      this.cargarDatosVacios()
      if (this.tipoaccion === 2) {
        this.form = {
          id: this.model.id,
          proveedor_id: this.model.proveedor_id,
          evento_id: this.model.evento_id,
          puntuacion: this.model.puntuacion,
          comentario: this.model.comentario,
          usuarioregistro: this.model.usuarioregistro,
          fecharegistro: this.model.fecharegistro
        }
      }
    },
    onSubmit() {
      if (!this.form.proveedor_id) {
        notify(this, 'error', 'Error', 'Debe seleccionar un proveedor.')
        return
      }
      if (!this.form.evento_id) {
        notify(this, 'error', 'Error', 'Debe seleccionar un evento.')
        return
      }
      if (!this.form.puntuacion) {
        notify(this, 'error', 'Error', 'Debe ingresar una puntuación.')
        return
      }

      this.cargandoInformacion = true
      const evaluacion = {
        id: this.form.id,
        proveedor_id: this.form.proveedor_id,
        evento_id: this.form.evento_id,
        puntuacion: this.form.puntuacion,
        comentario: this.form.comentario,
        usuarioregistro: this.form.usuarioregistro,
        fecharegistro: this.form.fecharegistro
      }

      evaluacionMantenimiento({
        tipoaccion: this.tipoaccion,
        evaluacion
      }).then(() => {
        this.cargandoInformacion = this.isLoading
        this.save()
        this.close()
        notify(this, 'success', 'Éxito', 'El registro se ha guardado satisfactoriamente.')
      }).catch(err => {
        console.log(err)
        this.cargandoInformacion = this.isLoading
        notify(this, 'error', 'Error', err.message)
      }).finally(() => {
        this.cargandoInformacion = false
      })
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
.text-align-center {
  text-align: center;
}
.margin-bottom-20px {
  margin-bottom: 20px;
}
.margin-bottom-10px {
  margin-bottom: 10px;
}
.el-dialog__header {
  text-align: center;
}
.el-rate {
  margin-top: 8px;
  &.is-disabled {
    cursor: not-allowed;
  }
}
.el-select {
  width: 100%;
}
.dialog-footer {
  margin-top: 20px;
  margin-bottom: 0;
}
.el-form-item {
  margin-bottom: 18px;
  &:last-child {
    margin-bottom: 0;
  }
}
.el-form {
  padding: 20px;
}
</style>
