<template lang="pug">
  .app-container
    .filter-container.text-align-right
      el-row(:gutter="10")
        el-col(:xs="24" :sm="8" :md="8" :lg="8" :xl="8")
          el-input(
            size="mini"
            placeholder="Buscar..."
            v-model="listQuery.search"
            @keyup.enter.native="handleFilter"
            clearable
            prefix-icon="el-icon-search"
          )
        el-col(:xs="24" :sm="8" :md="8" :lg="8" :xl="8")
          el-select(
            v-model="listQuery.idcategoria"
            placeholder="Categoría"
            clearable
            style="width: 100%"
            size="mini"
            @change="handleFilter"
          )
            el-option(
              v-for="item in categorias"
              :key="item.idcategoria"
              :label="item.nombre"
              :value="item.idcategoria"
            )
      el-row.margin-top-10
        el-col(:span="24")
          el-button(
            style="margin-left: 10px;"
            type="primary"
            icon="el-icon-plus"
            size="mini"
            @click="handleCreate"
          ) Nuevo
          el-button(
            style="margin-left: 10px;"
            type="primary"
            icon="el-icon-edit"
            size="mini"
            @click="handleUpdate"
          ) Editar
          el-button(
            style="margin-left: 10px;"
            type="danger"
            icon="el-icon-delete"
            size="mini"
            @click="handleDelete"
          ) Eliminar
          el-button(
            style="margin-left: 10px;"
            type="success"
            icon="el-icon-refresh"
            size="mini"
            @click="getList"
            :loading="listLoading"
          ) Actualizar
    el-table(
      ref="proveedoresTable"
      v-loading="listLoading"
      :data="list"
      border
      fit
      highlight-current-row
      size="mini"
      style="width: 100%"
      @selection-change="handleSelectionChange"
      @current-change="handleCurrentChange"
      @row-dblclick="handleRowDblClick"
    )
      el-table-column(type="selection" width="45")
      el-table-column(label="Nombre" prop="nombre" min-width="200")
      el-table-column(label="Email" prop="email" min-width="200")
      el-table-column(label="Teléfono" prop="telefono" width="120" align="center")
      el-table-column(label="Categoría" min-width="120")
        template(slot-scope="{row}")
          span {{ row.categoria_nombre }}
      el-table-column(label="Reputación" width="150" align="center")
        template(slot-scope="{row}")
          el-rate(
            v-model="row.reputacion"
            disabled
            show-score
            text-color="#ff9900"
          )
      el-table-column(label="Verificado" width="100" align="center")
        template(slot-scope="{row}")
          el-tag(:type="row.verificado ? 'success' : 'info'")
            | {{ row.verificado ? 'Sí' : 'No' }}
      el-table-column(label="Activo" width="80" align="center")
        template(slot-scope="{row}")
          el-tag(:type="row.activo ? 'success' : 'danger'")
            | {{ row.activo ? 'Sí' : 'No' }}
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
      form-proveedor(
        v-if="dialogFormVisible"
        :title="textDialog"
        :tipoaccion="tipoaccion"
        :model="temp"
        @save="getList"
        @close="closeDialog"
      )
    el-dialog(
      title="Eliminar Proveedor"
      :visible.sync="dialogDeleteVisible"
      :close-on-click-modal="false"
      width="400px"
    )
      p ¿Está seguro de eliminar {{ selectedItems.length > 1 ? 'los proveedores seleccionados' : 'este proveedor' }}?
      .dialog-footer(slot="footer")
        el-button(@click="dialogDeleteVisible = false") Cancelar
        el-button(type="danger" @click="confirmDelete") Eliminar
  </template>

<script>
import { proveedoresLista, proveedoresMantenimiento } from '@/api/proveedores'
import { getCategoriasSelect } from '@/api/proveedores'
import FormProveedor from '@/components/proveedores/form'
import { notify } from '@/utils/general'
import { mapState } from 'vuex'

export default {
  name: 'MantenimientoProveedores',
  components: {
    FormProveedor
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
        idcategoria: undefined,
        idestado: 2
      },
      categorias: [],
      dialogFormVisible: false,
      dialogDeleteVisible: false,
      textDialog: '',
      tipoaccion: 0,
      temp: {},
      selectedItems: [],
      isMovil: JSON.parse(localStorage.getItem('isMovil'))
    }
  },
  computed: {
    ...mapState('loading', ['isLoading'])
  },
  created() {
    this.getList()
    this.getCategorias()
  },
  methods: {
    async getList() {
      this.listLoading = true
      try {
        const response = await proveedoresLista(this.listQuery)
        this.list = response.lista
        this.total = response.cantidad
      } catch (error) {
        notify(this, 'error', 'Error', error.message)
      } finally {
        this.listLoading = false
      }
    },
    async getCategorias() {
      try {
        const response = await getCategoriasSelect()
        this.categorias = response.lista
      } catch (error) {
        notify(this, 'error', 'Error', 'Error al cargar categorías')
      }
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
      if (typeof val === 'number') {
        this.listQuery.page = val
      } else {
        this.temp = val || {}
      }
      this.getList()
    },
    handleSelectionChange(val) {
      this.selectedItems = val
    },
    handleRowDblClick(row) {
      this.temp = Object.assign({}, row)
      this.handleUpdate()
    },
    handleCreate() {
      this.temp = {}
      this.tipoaccion = 1
      this.textDialog = 'Nuevo Proveedor'
      this.dialogFormVisible = true
    },
    handleUpdate() {
      if (this.selectedItems.length !== 1 && !this.temp.id) {
        notify(this, 'warning', 'Advertencia', 'Por favor seleccione un proveedor')
        return
      }
      this.temp = Object.assign({}, this.selectedItems[0] || this.temp)
      this.tipoaccion = 2
      this.textDialog = 'Editar Proveedor'
      this.dialogFormVisible = true
    },
    handleDelete() {
      if (this.selectedItems.length === 0) {
        notify(this, 'warning', 'Advertencia', 'Por favor seleccione al menos un proveedor')
        return
      }
      this.dialogDeleteVisible = true
    },
    async confirmDelete() {
      this.listLoading = true
      try {
        for (const item of this.selectedItems) {
          await proveedoresMantenimiento({
            tipoaccion: 3,
            arreglo: item
          })
        }
        notify(this, 'success', 'Éxito', 'Proveedor(es) eliminado(s) correctamente')
        this.dialogDeleteVisible = false
        this.getList()
      } catch (error) {
        notify(this, 'error', 'Error', error.message)
      } finally {
        this.listLoading = false
      }
    },
    closeDialog() {
      this.dialogFormVisible = false
      this.temp = {}
      this.$refs.proveedoresTable.clearSelection()
    }
  }
}
</script>

  <style lang="scss" scoped>
  .filter-container {
    padding: 15px;
    background-color: #fff;
    border-radius: 4px;
    box-shadow: 0 1px 4px rgba(0,21,41,.08);
    margin-bottom: 20px;
  }
  .pagination-container {
    margin-top: 20px;
    text-align: center;
  }
  .margin-top-10 {
    margin-top: 10px;
  }
  </style>
