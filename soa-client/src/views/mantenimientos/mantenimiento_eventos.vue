<template lang="pug">
  div
    .filters
      el-row(:gutter="10")
        el-col(:xs="24" :sm="8" :md="8" :lg="8" :xl="8")
          el-input(
            size="mini"
            placeholder="Buscar por nombre, lugar o descripción..."
            v-model="listQuery.search"
            @keyup.enter.native="handleFilter"
            clearable
            prefix-icon="el-icon-search"
          )
        el-col(:xs="24" :sm="8" :md="8" :lg="8" :xl="8")
          el-date-picker(
            v-model="listQuery.fecha"
            type="date"
            size="mini"
            style="width: 100%"
            placeholder="Seleccione fecha"
            value-format="yyyy-MM-dd"
            @change="handleFilter"
            clearable
          )
        el-col(:xs="24" :sm="8" :md="8" :lg="8" :xl="8")
          el-select(
            v-model="listQuery.idestado"
            placeholder="Estado"
            clearable
            style="width: 100%"
            size="mini"
            @change="handleFilter"
          )
            el-option(
              v-for="item in estadosEvento"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            )

      el-row.margin-top-10
        el-col(:span="24")
          el-button(
            size="mini"
            type="primary"
            icon="el-icon-plus"
            @click="handleCreate"
          ) Nuevo Evento

    el-table.margin-top-10(
      v-loading="listLoading"
      :data="list"
      border
      fit
      highlight-current-row
      size="mini"
      style="width: 100%"
    )
      el-table-column(label="Nombre" prop="nombre" min-width="200")
      el-table-column(label="Fecha" width="120" align="center")
        template(slot-scope="{row}")
          span {{ row.fecha_formato }}
      el-table-column(label="Lugar" prop="lugar" min-width="150")
      el-table-column(label="Descripción" prop="descripcion" min-width="200")
      el-table-column(label="Estado" width="120" align="center")
        template(slot-scope="{row}")
          el-tag(:type="getEstadoTag(row.estado)") {{ row.estado }}
      el-table-column(label="Costo Total" width="120" align="right")
        template(slot-scope="{row}")
          span {{ formatCurrency(row.costo_total) }}
      el-table-column(label="Usuario" prop="usuarioregistro" min-width="100")
      el-table-column(label="Acciones" align="center" width="120" fixed="right")
        template(slot-scope="{row}")
          el-button(
            size="mini"
            type="primary"
            icon="el-icon-edit"
            @click="handleUpdate(row)"
          )
          el-button(
            size="mini"
            type="danger"
            icon="el-icon-delete"
            @click="handleDelete(row)"
          )

    el-pagination.pagination-container(
      background
      layout="total, sizes, prev, pager, next"
      :total="total"
      :page-size="listQuery.limit"
      :page-sizes="[10,20,30,50]"
      :current-page.sync="listQuery.page"
      @size-change="handleSizeChange"
      @current-change="handleCurrentChange"
    )

    el-dialog(
      :title="textDialog"
      :visible.sync="dialogFormVisible"
      :close-on-click-modal="false"
      width="600px"
    )
      form-eventos(
        v-if="dialogFormVisible"
        :title="textDialog"
        :tipoaccion="tipoaccion"
        :model="temp"
        @save="getList"
        @close="dialogFormVisible = false"
      )
  </template>

<script>
import { eventosLista, eventosMantenimiento } from '@/api/eventos'
import FormEventos from '@/components/eventos/form'
import { parseTime } from '@/utils'
import { notify } from '@/utils/general'

export default {
  name: 'MantenimientoEventos',
  components: {
    FormEventos
  },
  filters: {
    parseTime
  },
  data() {
    return {
      list: [],
      total: 0,
      listLoading: true,
      listQuery: {
        page: 1,
        limit: 10,
        search: undefined,
        fecha: undefined,
        idestado: 2,  // Por defecto mostrará todos
        sort: '+id'
      },
      estadosEvento: [
        { value: 1, label: 'Pendiente' },
        { value: 2, label: 'Todos' },
        { value: 3, label: 'En Proceso' },
        { value: 4, label: 'Completado' },
        { value: 5, label: 'Cancelado' }
      ],
      dialogFormVisible: false,
      textDialog: '',
      tipoaccion: 0,
      temp: {}
    }
  },
  created() {
    this.getList()
  },
  methods: {
    async getList() {
      try {
        console.log('Enviando query:', this.listQuery)
        this.listLoading = true
        const response = await eventosLista(this.listQuery)
        console.log('Respuesta:', response)
        this.list = response.lista
        this.total = response.cantidad
      } catch (error) {
        console.error('Error:', error)
        notify(this, 'error', 'Error', error.message || 'Error al cargar la lista')
      } finally {
        this.listLoading = false
      }
    },
    formatCurrency(value) {
      return value ? `S/ ${parseFloat(value).toFixed(2)}` : 'S/ 0.00'
    },
    getEstadoTag(estado) {
      const tags = {
        'Pendiente': 'warning',
        'En Proceso': 'primary',
        'Completado': 'success',
        'Cancelado': 'danger'
      }
      return tags[estado] || 'info'
    },
    handleFilter() {
      this.listQuery.page = 1
      this.getList()
    },
    handleSizeChange(val) {
      this.listQuery.limit = val
      this.getList()
    },
    handleCurrentChange(val) {
      this.listQuery.page = val
      this.getList()
    },
    resetTemp() {
      this.temp = {
        id: undefined,
        nombre: '',
        fecha: '',
        lugar: '',
        descripcion: '',
        estado: 'Pendiente',
        costo_total: 0,
        usuarioregistro: localStorage.getItem('username')
      }
    },
    handleCreate() {
      this.resetTemp()
      this.dialogFormVisible = true
      this.textDialog = 'Crear Evento'
      this.tipoaccion = 1
    },
    handleUpdate(row) {
      this.temp = Object.assign({}, row)
      this.dialogFormVisible = true
      this.textDialog = 'Editar Evento'
      this.tipoaccion = 2
    },
    async handleDelete(row) {
      try {
        await this.$confirm('¿Está seguro de eliminar este evento?', 'Advertencia', {
          confirmButtonText: 'OK',
          cancelButtonText: 'Cancelar',
          type: 'warning'
        })
        await eventosMantenimiento({
          tipoaccion: 3,
          evento: row
        })
        await this.getList()
        notify(this, 'success', 'Éxito', 'Evento eliminado correctamente')
      } catch (error) {
        if (error !== 'cancel') {
          notify(this, 'error', 'Error', error.message || 'Error al eliminar el evento')
        }
      }
    }
  }
}
</script>

  <style lang="scss" scoped>
  .filters {
    padding: 15px;
    border-radius: 4px;
    background-color: #fff;
    box-shadow: 0 1px 4px rgba(0,21,41,.08);
    margin-bottom: 20px;

    .el-select, .el-date-picker {
      width: 100%;
    }

    .el-input {
      margin-bottom: 10px;
    }
  }

  .pagination-container {
    margin-top: 20px;
    text-align: center;
  }

  .el-table {
    .el-button + .el-button {
      margin-left: 5px;
    }
  }

  .margin-top-10 {
    margin-top: 10px;
  }

  .el-dialog {
    .el-dialog__body {
      padding: 20px;
    }
  }
  </style>
