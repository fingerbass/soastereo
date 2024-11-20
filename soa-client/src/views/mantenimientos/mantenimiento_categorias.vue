<template lang="pug">
.app-container
  .filter-container.text-align-right
    //- el-input.filter-item.margin-right-5(v-model='textSearch' placeholder='Texto a buscar' style='width: 200px;' size='mini' @keyup.enter.native='handleFilter')
    //- el-select.filter-item.margin-right-5(v-model='sortByName' style='width: 140px' size='mini' @change='handleFilter')
      el-option(v-for='item in sortOptions' :key='item.key' :label='item.label' :value='item.key')
    //- el-button.filter-item(v-waves='' type='primary' icon='el-icon-search' size='mini' @click='handleFilter')
    //-   | Buscar
    el-button.filter-item(style='margin-left: 10px;' type='primary' icon='el-icon-plus' size='mini' @click='openModalMantenimiento(1)')
      | Nuevo
    el-button.filter-item(style='margin-left: 10px;' type='primary' icon='el-icon-edit' size='mini' @click='openModalMantenimiento(2)')
      | Editar
    el-button.filter-item(style='margin-left: 10px;' type='danger' icon='el-icon-delete' size='mini' @click='openModalEliminar(3)')
      | Eliminar
    //- el-button.filter-item(v-waves='' :loading='downloadLoading' type='success' icon='el-icon-download' size='mini' @click='handleDownload' :disabled="downloadLoading")
    //-   | Exportar
    //- el-button.filter-item(v-waves='' :loading='cargandoInformacion' type='success' icon='el-icon-download' size='mini' @click='handleDownload')
    //-   | Limpiar
    el-button.filter-item(v-waves='' :loading='cargandoInformacion' type='success' icon='el-icon-refresh' size='mini' @click='fetch()' :disabled="cargandoInformacion")
      | Actualizar
  el-table(ref="tblcategorias" @selection-change="handleSelectionChange" :key='tableKey' v-loading='cargandoInformacion' :data='listacategorias'  :border='false' fit='' highlight-current-row='' height="calc(100vh - 220px)" max-height="calc(100vh - 220px)" style="width: 100%;" size='mini' @sortByName-change='sortChange' @current-change="handleCurrentChange" :row-class-name="tableRowClassName" @cell-dblclick= "dblhandlecurrentchange" @row-click="rowClicked" @row-dblclick="rowDblClicked" empty-text="No existen Registros")
    el-table-column(type='selection' width='30')
    //- el-table-column(label='ID' prop='idcategoria' sortable='custom' align='center' width='60' :class-name="getSortClass('idcategoria')")
    //-   template(slot-scope='{row}')
    //-     span {{ row.idcategoria }}
    el-table-column(label='Nombre' prop='nombre' align='left')
      template(slot-scope='{row}')
        span {{ row.nombre }}
    el-table-column(label='Descripcion' prop='descripcion' align='left')
      template(slot-scope='{row}')
        span {{ row.descripcion }}
    el-table-column(label='Activo' prop='activo' align='center')
      template(slot-scope='{row}')
        //- span {{ row.activo }}
        el-checkbox(v-model='row.activo' size='mini')
    //- el-table-column(label='Usuario Registro' prop='usuarioregistro' align='center')
    //-   template(slot-scope='{row}')
    //-     span {{ row.usuarioregistro }}
    //- el-table-column(label='Fecha Registro' prop='fecharegistro' align='center')
    //-   template(slot-scope='{row}')
    //-     span {{ row.fecharegistro | formatDate }}
  pagination(v-show='totalpagination > 0' :total='totalpagination' :page.sync='pagination' :limit.sync='limit' @pagination='fetch')

  el-dialog(:title='textMap[dialogStatus]' v-if="dialogFormVisible" :visible.sync='dialogFormVisible' :close-on-click-modal='false' :close-on-press-escape='false' :show-close='false' @close="closeModalMantenimiento()" :width="isMovil ? '90%' : '50%'" top="8vh" center)
    form-categorias(v-if="dialogFormVisible" :title="textMap[dialogStatus]" :tipoaccion="tipoaccion" @save="fetch()" :model='obj' @close="closeModalMantenimiento()" center)

  el-dialog(:title='textMap[dialogStatus]' :visible.sync='activarModalEliminarEmpresa' :close-on-click-modal='false' :close-on-press-escape='false' :show-close='false' @close="closeModalliminar()" width='30%' center='')
    span.bold ¿Desea eliminar&nbsp;
    span.bold(v-if="arreglo.length === 1") esta categoria
    span.bold(v-else) los categorias
    span.bold ?
    span.dialog-footer(slot='footer')
      el-button(@click='closeModalliminar()') Cancelar
      el-button(type='primary' @click='eliminarRegistros()') Eliminar
    //- span.dialog-footer(slot='footer')
    //- el-row.dialog-footer(slot='footer')
      //- el-col(:xs="12" :sm="12" :md="12" :lg="12" :xl="12")
      //-   el-button(type='primary' size="mini" width="95%;" style='width: 95%;' @click='centerDialogVisible = false') Continuar
      //- el-col(:xs="24" :sm="24" :md="24" :lg="24" :xl="24")
      //-   el-button(size="mini" width="100%;" style='width: 100%;' @click='centerDialogVisible = false') Cancelar
</template>

<script>
import { categoriasLista, categoriasMantenimiento } from '@/api/categorias.js'
import waves                                        from '@/directive/waves' // waves directive
// import { parseTime }                              from '@/utils'
import Pagination                                   from '@/components/Pagination' // secondary package based on el-pagination
import { mapState }                                 from 'vuex'
import { notify }                                   from '../../utils/general.js'
import formcategorias                               from '@/components/categorias'
import moment                                       from 'moment'

export default {
  name      : 'MantenimientoCategorias',
  components: {
    Pagination,
    'form-categorias': formcategorias
  },
  directives: {
    waves
  },
  filters   : {
    statusFilter(status) {
      const statusMap = {
        published: 'success',
        draft    : 'info',
        deleted  : 'danger'
      }
      return statusMap[status]
    }
  },
  data() {
    return {
      cargandoInformacion        : true,
      tableKey                   : 0,
      lista                      : [],
      listacategorias              : [],
      listaDetalle               : [],
      listaQuery                 : {},
      textSearch                 : '',
      sortByType                 : 'ASC',
      sortByName                 : '+idcategoria',
      idestado                   : 2,
      limit          : 50,
      pagination                 : 1,
      totalpagination            : 0,
      tipoaccion                 : 0,
      idcategoria                  : '',
      indexempresa               : '',
      obj                 : '',
      sortOptions                : [{ label: 'ID Ascending', key: '+idcategoria' }, { label: 'ID Descending', key: '-idcategoria' }],
      dialogFormVisible          : false,
      dialogStatus               : '',
      arreglo  : [],
      activarModalEliminarEmpresa: false,
      textMap                    : {
        update: 'Editar Categorias',
        create: 'Crear Categorias',
        delete: 'Eliminar Categorias'
      },
      dialogPvVisible: false,
      temporal               : {
        idcategoria      : null,
        nombre         : '',
        ruc            : '',
        direccion      : '',
        distrito       : '',
        ciudad         : '',
        telefono       : '',
        email          : '',
        activo         : true,
        logo           : '',
        isotipo        : '',
        usuarioregistro: localStorage.getItem('username'),
        fecharegistro  : new Date()
      },
      pvData         : [],
      rules          : {
        type     : [{ required: true, message: 'type is required', trigger: 'change' }],
        timestamp: [{ type: 'date', required: true, message: 'timestamp is required', trigger: 'change' }],
        title    : [{ required: true, message: 'title is required', trigger: 'blur' }]
      },
      downloadLoading    : false,
      centerDialogVisible: false,
      currentRow         : null,
      isProceso          : false,
      isSavingAdjunto    : false,
      isSavedAdjunto     : false,
      isMovil            : JSON.parse(localStorage.getItem('isMovil'))
    }
  },
  computed: {
    ...mapState('loading', ['isLoading'])
  },
  created() {
    var vm = this
    vm.fetch()
  },
  methods: {
    fetch() {
      var vm                  = this
      vm.listacategorias        = []
      vm.cargandoInformacion  = true
      vm.listaQuery = {
        textSearch: vm.textSearch,
        pagination: vm.pagination,
        limit     : vm.limit,
        idestado  : vm.idestado,
        sortByType: vm.sortByType,
        sortByName: vm.sortByName
      }
      categoriasLista(vm.listaQuery).then(data => {
        console.log('data: ', data)
        for (let i = 0; i < data.lista.length; i++) {
          vm.listacategorias.push(data.lista[i])
        }
        vm.totalpagination     = data.cantidad
        vm.cargandoInformacion = vm.isLoading
        vm.closeModalMantenimiento()
      }, function (err) {
        console.log(err)
        vm.cargandoInformacion = vm.isLoading
        notify(vm, 'error', 'Error', err.message)
      }, function () {
        vm.cargandoInformacion = false
      })
    },
    tableRowClassName(row, index) {
      if (row.activo === false) {
        return 'warning-row'
      }
      return ''
    },
    handleFilter() {
      var vm              = this
      vm.listaQuery.page  = 1
      vm.fetch()
    },
    handleModifyStatus(row, status) {
      this.$message({
        message: 'Success',
        type   : 'success'
      })
      row.status = status
    },
    sortChange(data) {
      var vm = this
      const { prop, order } = data
      if (prop === 'idcategoria') {
        vm.sortByID(order)
      }
    },
    sortByID(order) {
      var vm = this
      if (order === 'ascending') {
        vm.listaQuery.sortByName = '+idcategoria'
      } else {
        vm.listaQuery.sortByName = '-idcategoria'
      }
      vm.handleFilter()
    },
    getSortClass: function(key) {
      var vm              = this
      const  sortByName   = vm.sortByName
      return sortByName === `+${key}` ? 'ascending' : 'descending'
    },
    resetTemp() {
      var vm = this
      vm.temporal = {
        idcategoria      : null,
        nombre         : '',
        ruc            : '',
        direccion      : '',
        distrito       : '',
        ciudad         : '',
        telefono       : '',
        email          : '',
        activo         : true,
        logo           : '',
        isotipo        : '',
        usuarioregistro: localStorage.getItem('username'),
        fecharegistro  : new Date()
      }
    },
    handleDownload() {
      var vm = this
      vm.downloadLoading = true
      import('@/vendor/Export2Excel').then(excel => {
        const tHeader   = ['idcategoria', 'nombre', 'ruc', 'direccion', 'distrito', 'ciudad', 'telefono', 'email', 'activo', 'logo', 'isotipo', 'usuarioregistro', 'fecharegistro']
        const filterVal = ['nombre', 'idcategoria', 'ruc', 'direccion', 'distrito', 'ciudad', 'telefono', 'email', 'activo', 'logo', 'isotipo', 'usuarioregistro', 'fecharegistro']
        const data      = vm.formatJson(filterVal)
        excel.export_json_to_excel({
          header: tHeader,
          data,
          filename: 'table-listacategorias'
        })
        vm.downloadLoading = false
      })
    },
    formatJson(filterVal) {
      var vm = this
      return vm.listacategorias.map(v => filterVal.map(j => {
        return v[j]
        // if (j === 'timestamp') {
        //   return parseTime(v[j])
        // } else {
        //   return v[j]
        // }
      }))
    },
    handleDownloadExportar () {
      console.log('handleDownloadExportar')
      var vm = this
      vm.downloadLoading = true
      import('@/vendor/Export2Excel').then(excel => {
        const tHeader   = ['nombre', 'ruc', 'direccion', 'distrito', 'ciudad', 'telefono', 'email', 'activo', 'logo', 'isotipo', 'usuarioregistro']
        const filterVal = ['nombre', 'ruc', 'direccion', 'distrito', 'ciudad', 'telefono', 'email', 'activo', 'logo', 'isotipo', 'usuarioregistro']
        const data      = vm.formatJsonExportar(filterVal)
        // var   data      = []
        excel.export_json_to_excel({
          header: tHeader,
          data,
          filename: 'plantilla-listacategorias'
        })
        vm.downloadLoading = false
      })
    },
    formatJsonExportar(filterVal) {
      // var vm = this
      var listacategorias = [
        {
          // idcategoria      : !this.administrador ? JSON.parse(localStorage.getItem('itemcategoriaseleccionado')) : '',
          nombre         : '',
          ruc            : '',
          direccion      : '',
          distrito       : '',
          ciudad         : '',
          telefono       : '',
          email          : '',
          activo         : 'VERDADERO',
          logo           : '',
          isotipo        : '',
          usuarioregistro: localStorage.getItem('username')
          // fecharegistro  : moment().format()
        }
      ]
      return listacategorias.map(v => filterVal.map(j => {
        return v[j]
        // if (j === 'timestamp') {
        //   return parseTime(v[j])
        // } else {
        //   return v[j]
        // }
      }))
    },
    handleDownloadImportar () {
      console.log('handleDownloadImportar')
      var vm = this
      vm.centerDialogVisible = true
    },
    formatJsonImportar(filterVal) {
      // var vm = this
      var listacategorias = [
        {
          // idtercero      : '',
          idcategoria      : !this.administrador ? JSON.parse(localStorage.getItem('itemcategoriaseleccionado')) : '',
          ruc            : '',
          nombre         : '',
          direccion      : '',
          activo         : 'VERDADERO',
          usuarioregistro: localStorage.getItem('username'),
          fecharegistro  : moment().format()
        }
      ]
      return listacategorias.map(v => filterVal.map(j => {
        return v[j]
        // if (j === 'timestamp') {
        //   return parseTime(v[j])
        // } else {
        //   return v[j]
        // }
      }))
    },
    submitUpload() {
      this.$refs.upload.submit()
    },
    isObjEmpty (obj) {
      // console.log('obj:>>> ', obj)
      // var verificar = Object.keys(obj).length === 0
      // console.log('verificar:>>> ', verificar)
      // return verificar
      if (JSON.stringify(obj) === '{}' || obj === null || obj === undefined) {
        return true
      }
    },
    cargarDatos () {
      var vm = this
      vm.resetTemp()
      if (vm.tipoaccion === 1) {
        vm.resetTemp()
      } else {
        vm.temporal = {
          idcategoria      : vm.obj.idcategoria,
          nombre         : vm.obj.nombre,
          ruc            : vm.obj.ruc,
          direccion      : vm.obj.direccion,
          distrito       : vm.obj.distrito,
          ciudad         : vm.obj.ciudad,
          telefono       : vm.obj.telefono,
          email          : vm.obj.email,
          activo         : vm.obj.activo,
          logo           : vm.obj.logo,
          isotipo        : vm.obj.isotipo,
          usuarioregistro: vm.obj.usuarioregistro,
          fecharegistro  : vm.obj.fecharegistro
        }
      }
    },
    openModalMantenimiento (tipo) {
      var vm        = this
      vm.tipoaccion = tipo
      vm.resetTemp()
      if (vm.tipoaccion === 1) {
        vm.dialogStatus = 'create'
        vm.obj   = {}
        vm.resetTemp()
      } else if (vm.tipoaccion === 2) {
        var validObj      = vm.isObjEmpty(vm.obj)
        if (validObj) {
          notify(vm, 'error', 'Error', 'Debe seleccionar un registro.')
          return
        }
        vm.dialogStatus = 'update'
        vm.cargarDatos()
        // vm.temporal     = Object.assign({}, vm.obj)
      }
      vm.dialogFormVisible = true
    },
    closeModalMantenimiento () {
      var vm                = this
      vm.tipoaccion         = 0
      vm.dialogStatus       = ''
      vm.obj         = {}
      // vm.resetTemp()
      vm.setCurrent()
      vm.dialogFormVisible  = false
    },
    setCurrent (row) {
      this.$refs.tblcategorias.setCurrentRow(row)
    },
    openModalEliminar (tipo) {
      var vm          = this
      vm.dialogStatus = 'delete'
      vm.tipoaccion   = tipo
      if (vm.arreglo.length === 0) {
        notify(vm, 'error', 'Error', 'Debe seleccionar un registro para esta accion.')
        return
      }
      vm.activarModalEliminarEmpresa = true
    },
    closeModalliminar () {
      var vm                          = this
      vm.$refs.tblcategorias.clearSelection()
      vm.tipoaccion                   = 0
      vm.dialogStatus                 = ''
      vm.arreglo               = []
      vm.activarModalEliminarEmpresa  = false
    },
    handleSelectionChange(val) {
      console.log('val:>>> ', val)
      var vm                        = this
      vm.arreglo  = val
    },
    eliminarRegistros () {
      var vm                  = this
      vm.cargandoInformacion  = true
      var obj                 = {
        tipoaccion    : vm.tipoaccion,
        arreglo: vm.arreglo
      }
      categoriasMantenimiento(obj).then(data => {
        console.log('data: ', data)
        vm.cargandoInformacion = vm.isLoading
        var texto = vm.arreglo.length >= 2 ? 'Se han eliminado correctamente las empresa' : 'Se ah elimiando correctamente la empresa.'
        notify(vm, 'success', 'Éxito', texto)
        vm.closeModalliminar()
        vm.fetch()
      }, function (err) {
        console.log(err)
        vm.cargandoInformacion = vm.isLoading
        notify(vm, 'error', 'Error', err.message)
      }, function () {
        vm.closeModalliminar()
        vm.cargandoInformacion = false
      })
    },
    handleCurrentChange(item) {
      var vm        = this
      vm.obj = item
      console.log('vm.obj:>>> ', vm.obj)
    },
    rowClicked (row) {
      var vm        = this
      vm.obj = row
      console.log('vm.obj:>>> ', vm.obj)
    },
    rowDblClicked (row) {
      var vm        = this
      vm.obj = row
      vm.openModalMantenimiento(2)
      console.log('vm.obj:>>> ', vm.obj)
    },
    dblhandlecurrentchange (row, column, cell, event) {
      console.log('row:>>> ', row)
      console.log('column:>>> ', column)
      console.log('cell:>>> ', cell)
      console.log('event:>>> ', event)
    }
  }
}
</script>

<style lang="scss">
.table {
  overflow-y: scroll;
  min-height: calc(100vh - 343px);
  max-height: calc(100vh - 243px)
}

.el-table .warning-row {
  background: oldlace;
}

.el-table .success-row {
  background: #f0f9eb;
}
</style>
