<template lang="pug">
el-form(
  ref="form"
  :model="form"
  label-width="120px"
  size="mini"
  :label-position="isMovil ? 'top' : 'right'"
  :rules="rules"
)
  el-row(:gutter="20")
    el-col(:xs="24" :sm="24" :md="24" :lg="24" :xl="24")
      el-form-item(label="Nombre" prop="nombre")
        el-input(
          v-model="form.nombre"
          placeholder="Ingrese el nombre del evento"
          clearable
        )

    el-col(:xs="24" :sm="12" :md="12" :lg="12" :xl="12")
      el-form-item(label="Fecha" prop="fecha")
        el-date-picker(
          v-model="form.fecha"
          type="date"
          placeholder="Seleccione fecha"
          style="width: 100%"
          value-format="yyyy-MM-dd"
          :picker-options="pickerOptions"
        )

    el-col(:xs="24" :sm="12" :md="12" :lg="12" :xl="12")
      el-form-item(label="Estado" prop="estado")
        el-select(
          v-model="form.estado"
          placeholder="Seleccione estado"
          style="width: 100%"
        )
          el-option(
            v-for="item in estadosEvento"
            :key="item.value"
            :label="item.label"
            :value="item.value"
          )

    el-col(:xs="24" :sm="24" :md="24" :lg="24" :xl="24")
      el-form-item(label="Lugar" prop="lugar")
        el-input(
          v-model="form.lugar"
          placeholder="Ingrese el lugar del evento"
          clearable
        )

    el-col(:xs="24" :sm="24" :md="24" :lg="24" :xl="24")
      el-form-item(label="Costo Total" prop="costo_total")
        el-input-number(
          v-model="form.costo_total"
          :precision="2"
          :step="0.01"
          :min="0"
          controls-position="right"
          style="width: 100%"
        )

    el-col(:xs="24" :sm="24" :md="24" :lg="24" :xl="24")
      el-form-item(label="Descripción" prop="descripcion")
        el-input(
          type="textarea"
          :rows="3"
          v-model="form.descripcion"
          placeholder="Ingrese una descripción del evento"
        )

  el-form-item(class="dialog-footer")
    el-row(:gutter="20")
      el-col(:xs="12" :sm="12" :md="12" :lg="12" :xl="12")
        el-button(
          type="primary"
          size="mini"
          @click="onSubmit"
          style="width: 100%"
          :loading="cargandoInformacion"
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
import { eventosMantenimiento } from '@/api/eventos'
import { notify } from '@/utils/general.js'
import { mapState } from 'vuex'

export default {
  name: 'FormEventos',
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
        fecha: '',
        lugar: '',
        descripcion: '',
        estado: 'PENDIENTE',
        costo_total: 0,
        usuarioregistro: localStorage.getItem('username')
      },
      cargandoInformacion: false,
      estadosEvento: [
        { value: 'PENDIENTE', label: 'Pendiente' },
        { value: 'EN_PROCESO', label: 'En Proceso' },
        { value: 'COMPLETADO', label: 'Completado' },
        { value: 'CANCELADO', label: 'Cancelado' }
      ],
      rules: {
        nombre: [
          { required: true, message: 'Por favor ingrese el nombre del evento', trigger: 'blur' },
          { min: 3, message: 'El nombre debe tener al menos 3 caracteres', trigger: 'blur' }
        ],
        fecha: [
          { required: true, message: 'Por favor seleccione la fecha', trigger: 'change' }
        ],
        lugar: [
          { required: true, message: 'Por favor ingrese el lugar del evento', trigger: 'blur' }
        ],
        estado: [
          { required: true, message: 'Por favor seleccione el estado', trigger: 'change' }
        ]
      },
      pickerOptions: {
        disabledDate(time) {
          return time.getTime() < Date.now() - 8.64e7
        }
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
    cargarDatos() {
      this.cargarDatosVacios()
      if (this.tipoaccion === 2 && !this.isObjEmpty(this.model)) {
        this.form = {
          id: this.model.id,
          nombre: this.model.nombre,
          fecha: this.model.fecha_formato,
          lugar: this.model.lugar,
          descripcion: this.model.descripcion,
          estado: this.model.estado,
          costo_total: this.model.costo_total,
          usuarioregistro: this.model.usuarioregistro
        }
      }
    },
    cargarDatosVacios() {
      this.form = {
        id: null,
        nombre: '',
        fecha: '',
        lugar: '',
        descripcion: '',
        estado: 'PENDIENTE',
        costo_total: 0,
        usuarioregistro: localStorage.getItem('username')
      }
    },
    isObjEmpty(obj) {
      return Object.keys(obj).length === 0
    },
    async onSubmit() {
      try {
        await this.$refs.form.validate()
      } catch (error) {
        return
      }

      this.cargandoInformacion = true

      try {
        await eventosMantenimiento({
          tipoaccion: this.tipoaccion,
          evento: this.form
        })

        this.save()
        this.close()
        notify(this, 'success', 'Éxito', 'Evento guardado correctamente')
      } catch (error) {
        notify(this, 'error', 'Error', error.message || 'Error al guardar el evento')
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

.el-select {
  width: 100%;
}

.el-input-number {
  width: 100%;
}
</style>
