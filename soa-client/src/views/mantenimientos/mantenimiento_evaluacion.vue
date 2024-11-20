<template lang="pug">
div
  .filters
    el-row(:gutter="10")
      el-col(:xs="24" :sm="8" :md="8" :lg="8" :xl="8")
        el-input(size="mini" placeholder="Buscar..." v-model="listQuery.search" @keyup.enter.native="handleFilter" clearable prefix-icon="el-icon-search")
      el-col(:xs="24" :sm="8" :md="8" :lg="8" :xl="8")
        el-select(v-model="listQuery.proveedor_id" placeholder="Proveedor" clearable style="width: 100%" size="mini" @change="handleFilter")
          el-option(v-for="item in proveedores" :key="item.id" :label="item.nombre" :value="item.id")
      el-col(:xs="24" :sm="8" :md="8" :lg="8" :xl="8")
        el-select(v-model="listQuery.evento_id" placeholder="Evento" clearable style="width: 100%" size="mini" @change="handleFilter")
          el-option(v-for="item in eventos" :key="item.id" :label="item.nombre" :value="item.id")

    el-row.margin-top-10
      el-col(:span="24")
        el-button(size='mini' type="primary" icon="el-icon-plus" @click="handleCreate") Nueva Evaluación

  el-table.margin-top-10(
    v-loading="listLoading"
    :data="list"
    border
    fit
    highlight-current-row
    size="mini"
    style="width: 100%"
  )
    el-table-column(label="Proveedor" prop="proveedor_nombre" min-width="120")
    el-table-column(label="Evento" prop="evento_nombre" min-width="120")
    el-table-column(label="Puntuación" align="center" width="150")
      template(slot-scope="{row}")
        el-rate(v-model="row.puntuacion" disabled show-score text-color="#ff9900")
    el-table-column(label="Comentario" prop="comentario" min-width="180")
    el-table-column(label="Usuario" prop="usuarioregistro" min-width="100")
    el-table-column(label="Fecha" width="150" align="center")
      template(slot-scope="{row}")
        span {{ row.creado_en }}
    el-table-column(label="Acciones" align="center" width="120" fixed="right")
      template(slot-scope="{row}")
        el-button(size="mini" type="primary" icon="el-icon-edit" @click="handleUpdate(row)")
        el-button(size="mini" type="danger" icon="el-icon-delete" @click="handleDelete(row)")

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

  // Dialog para crear/editar evaluación
  el-dialog(
    :title="textDialog"
    :visible.sync="dialogFormVisible"
    :close-on-click-modal="false"
    width="600px"
  )
    form-evaluacion(
      :title="textDialog"
      :tipoaccion="tipoaccion"
      :model="temp"
      @save="getList"
      @close="dialogFormVisible = false"
    )

</template>

<script>
import { evaluacionLista, evaluacionMantenimiento } from '@/api/evaluacion'
import { getProveedores, getEventos } from '@/api/evaluacion'
import FormEvaluacion from '@/components/evaluacion/'
import { parseTime } from '@/utils'
import { notify } from '@/utils/general'

export default {
  name: 'MantenimientoEvaluacion',
  components: {
    FormEvaluacion
  },
  filters: {
    parseTime
  },
  data() {
    return {
      list: null,
      total: 0,
      listLoading: true,
      listQuery: {
        page: 1,
        limit: 10,
        search: undefined,
        proveedor_id: undefined,
        evento_id: undefined,
        sort: '+id'
      },
      proveedores: [],
      eventos: [],
      dialogFormVisible: false,
      textDialog: '',
      tipoaccion: 0,
      temp: {}
    }
  },
  created() {
    this.getList()
    this.getProveedores()
    this.getEventos()
  },
  methods: {
    getList() {
      this.listLoading = true
      evaluacionLista(this.listQuery).then(response => {
        console.log('response: ', response)
        this.list = response.lista
        this.total = response.cantidad
        this.listLoading = false
      }).catch(error => {
        notify(this, 'error', 'Error', error.message)
        this.listLoading = false
      })
    },
    getProveedores() {
      getProveedores().then(response => {
        this.proveedores = response.lista
      })
    },
    getEventos() {
      getEventos().then(response => {
        this.eventos = response.lista
      })
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
        proveedor_id: undefined,
        evento_id: undefined,
        puntuacion: 0,
        comentario: '',
        usuarioregistro: undefined,
        fecharegistro: undefined
      }
    },
    handleCreate() {
      this.resetTemp()
      this.dialogFormVisible = true
      this.textDialog = 'Crear Evaluación'
      this.tipoaccion = 1
    },
    handleUpdate(row) {
      this.temp = Object.assign({}, row)
      this.dialogFormVisible = true
      this.textDialog = 'Editar Evaluación'
      this.tipoaccion = 2
    },
    handleDelete(row) {
      this.$confirm('¿Está seguro de eliminar esta evaluación?', 'Advertencia', {
        confirmButtonText: 'OK',
        cancelButtonText: 'Cancelar',
        type: 'warning'
      }).then(() => {
        this.temp = Object.assign({}, row)
        evaluacionMantenimiento({
          tipoaccion: 3,
          evaluacion: this.temp
        }).then(() => {
          this.getList()
          notify(this, 'success', 'Éxito', 'Registro eliminado correctamente')
        }).catch(error => {
          notify(this, 'error', 'Error', error.message)
        })
      }).catch(() => {
        this.$message({
          type: 'info',
          message: 'Operación cancelada'
        })
      })
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
  .el-select {
    width: 100%;
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
</style>
