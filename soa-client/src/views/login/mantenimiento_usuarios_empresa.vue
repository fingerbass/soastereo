<template lang="pug">
.app-container
  .filter-container.text-align-right
    //- el-select.filter-item.margin-right-5(v-model='sortByName' style='width: 140px' size='mini' @change='handleFilter')
      el-option(v-for='item in sortOptions' :key='item.key' :label='item.label' :value='item.key')
    el-button.filter-item(style='margin-left: 10px;' type='primary' icon='el-icon-plus' size='mini' @click='openModalMantenimiento(1)')
      | Nuevo
    el-button.filter-item(style='margin-left: 10px;' type='primary' icon='el-icon-edit' size='mini' @click='openModalMantenimiento(2)' :disabled="listausuariosempresa.length === 0")
      | Editar
    el-button.filter-item(style='margin-left: 10px;' type='danger' icon='el-icon-delete' size='mini' @click='openModalEliminar(3)' :disabled="listausuariosempresa.length === 0")
      | Eliminar
    el-button.filter-item(v-waves='' :loading='downloadLoading' type='success' icon='el-icon-download' size='mini' @click='handleDownload' :disabled="listausuariosempresa.length === 0")
      | Exportar
    el-button.filter-item(v-waves='' :loading='cargandoInformacion' type='success' icon='el-icon-refresh' size='mini' @click='fetch()' :disabled="cargandoInformacion")
      | Actualizar
  el-table(ref="tbltipospersonal" @selection-change="handleSelectionChange" :key='tableKey' v-loading='cargandoInformacion' :data='listausuariosempresa'  :border='false' fit='' highlight-current-row='' height="calc(100vh - 218px)" max-height="calc(100vh - 218px)" style="width: 100%;" size='mini' @sortByName-change='sortChange' @current-change="handleCurrentChange" :row-class-name="tableRowClassName" @cell-dblclick= "dblhandlecurrentchange" @row-click="rowClicked" @row-dblclick="rowDblClicked" empty-text="No existen Registros")
    el-table-column(type='selection' width='30')
    //- el-table-column(label='ID' prop='idusuarioempresa' sortable='custom' align='left' width='60' :class-name="getSortClass('idusuarioempresa')")
    //-   template(slot-scope='{row}')
    //-     span {{ row.idusuarioempresa }}
    //- el-table-column(label='idusuario' prop='idusuario' align='left')
    //-   template(slot-scope='{row}')
    //-     span {{ row.idusuario }}
    el-table-column(label='Nombre' prop='nombre' align='left')
      template(slot-scope='{row}')
        span {{ row.nombre }}
    el-table-column(label='Login' prop='login' align='center')
      template(slot-scope='{row}')
        span {{ row.login }}
    //- el-table-column(label='idempresa' prop='idempresa' align='left')
    //-   template(slot-scope='{row}')
    //-     span {{ row.idempresa }}
    el-table-column(label='Empresa' prop='empresa' align='left')
      template(slot-scope='{row}')
        span {{ row.empresa }}
    el-table-column(label='Ruc' prop='ruc' align='center')
      template(slot-scope='{row}')
        span {{ row.ruc }}
    //- el-table-column(label='idrol' prop='idrol' align='center')
    //-   template(slot-scope='{row}')
    //-     span {{ row.idrol }}
    el-table-column(label='Rol' prop='rol' align='center')
      template(slot-scope='{row}')
        span {{ row.rol }}
    el-table-column(label='Usuario Registro' prop='usuarioregistro' align='center')
      template(slot-scope='{row}')
        span {{ row.usuarioregistro }}
    el-table-column(label='Fecha Registro' prop='fecharegistro' align='center')
      template(slot-scope='{row}')
        span {{ row.fecharegistro | formatDate }}
  pagination(v-show='totalpagination > 0' :total='totalpagination' :page.sync='pagination' :limit.sync='limit' @pagination='fetch')

  el-dialog(:title='textMap[dialogStatus]' v-if="dialogFormVisible" :visible.sync='dialogFormVisible' :close-on-click-modal='false' :close-on-press-escape='false' :show-close='false' @close="closeModalMantenimiento()" :width="isMovil ? '90%' : '60%'" top="8vh" center)
    form-usuarios-empresa(v-if="dialogFormVisible" :title="textMap[dialogStatus]" :tipoaccion="tipoaccion" :model='obj' @save="fetch()" @close="closeModalMantenimiento()")

  el-dialog(:title='textMap[dialogStatus]' :visible.sync='activarModalEliminarUsuario' :close-on-click-modal='false' :close-on-press-escape='false' :show-close='false' @close="closeModalEliminar()" width='30%' center='')
    span.bold ¿Desea eliminar&nbsp;
    span.bold(v-if="arreglo.length === 1") este usuario de esta empresa
    span.bold(v-else) los usuarios de las empresas
    span.bold ?
    span.dialog-footer(slot='footer')
      el-button(@click='closeModalEliminar()') Cancelar
      el-button(type='primary' @click='eliminarRegistros()') Eliminar
</template>

<script>
import { usuariosempresaLista, usuariosempresaMantenimiento } from '@/api/usuarios-empresa'
import waves                                                  from '@/directive/waves'        // waves directive
import Pagination                                             from '@/components/Pagination'  // secondary package based on el-pagination
import { mapState }                                           from 'vuex'
import { notify }                                             from '../../utils/general.js'
import formUsuariosEmpresa                                    from '@/components/usuarios-empresa'

export default {
  name      : 'MantenimientoTiposPersonal',
  components: {
    Pagination,
    'form-usuarios-empresa': formUsuariosEmpresa
  },
  directives: {
    waves
  },
  filters: {
  },
  data() {
    return {
      cargandoInformacion        : true,
      tableKey                   : 0,
      lista                      : [],
      listausuariosempresa            : [],
      listaDetalle               : [],
      listaQuery                 : {},
      textSearch                 : '',
      sortByType                 : 'ASC',
      sortByName                 : '+idusuarioempresa',
      idtipo                     : -1,
      idestado                   : 2,
      limit                      : 50,
      pagination                 : 1,
      totalpagination            : 0,
      tipoaccion                 : 0,
      idusuarioempresa                   : '',
      indexusuario               : '',
      obj                        : '',
      sortOptions                : [{ label: 'ID Ascending', key: '+idusuarioempresa' }, { label: 'ID Descending', key: '-idusuarioempresa' }],
      dialogFormVisible          : false,
      dialogStatus               : '',
      arreglo                    : [],
      activarModalEliminarUsuario: false,
      textMap                    : {
        update: 'Editar Usuario Empresa',
        create: 'Crear Usuario Empresa',
        delete: 'Eliminar Usuarios Empresa'
      },
      dialogPvVisible: false,
      temporal       : {
        idusuarioempresa: null,
        idempresa       : '',
        idusuario       : '',
        idrol           : '',
        usuarioregistro : '',
        fecharegistro   : new Date()
      },
      rules          : {
        type     : [{ required: true, message: 'type is required', trigger: 'change' }],
        timestamp: [{ type: 'date', required: true, message: 'timestamp is required', trigger: 'change' }],
        title    : [{ required: true, message: 'title is required', trigger: 'blur' }]
      },
      downloadLoading: false,
      currentRow     : null,
      isMovil        : JSON.parse(localStorage.getItem('isMovil'))
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
      vm.listausuariosempresa      = []
      vm.cargandoInformacion  = true
      vm.listaQuery           = {
        textSearch: vm.textSearch,
        pagination: vm.pagination,
        limit     : vm.limit,
        idestado  : vm.idestado,
        idtipo    : vm.idtipo,
        sortByType: vm.sortByType,
        sortByName: vm.sortByName
      }
      // console.log(vm.listaQuery)
      usuariosempresaLista(vm.listaQuery).then(data => {
        console.log('data: ', data)
        for (let i = 0; i < data.lista.length; i++) {
          vm.listausuariosempresa.push(data.lista[i])
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
      // console.log(row)
      if (row.activo === true) {
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
      if (prop === 'idusuarioempresa') {
        vm.sortByID(order)
      }
    },
    sortByID(order) {
      var vm = this
      if (order === 'ascending') {
        vm.listaQuery.sortByName = '+idusuarioempresa'
      } else {
        vm.listaQuery.sortByName = '-idusuarioempresa'
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
        idusuarioempresa   : null,
        nombre         : '',
        activo         : true,
        flgarea        : true,
        flgbrevete     : true,
        usuarioregistro: localStorage.getItem('username'),
        fecharegistro  : ''
      }
    },
    handleCreate() {
      this.resetTemp()
      this.dialogStatus      = 'create'
      this.dialogFormVisible = true
      this.$nextTick(() => {
        this.$refs['dataForm'].clearValidate()
      })
    },
    handleUpdate(row) {
      this.temporal              = Object.assign({}, row)         // copy obj
      this.temporal.timestamp    = new Date(this.temporal.timestamp)
      this.dialogStatus      = 'update'
      this.dialogFormVisible = true
      this.$nextTick(() => {
        this.$refs['dataForm'].clearValidate()
      })
    },
    handleDelete(row, index) {
      this.$notify({
        title   : 'Success',
        message : 'Eliminar con éxito.',
        type    : 'success',
        duration: 2000
      })
      this.listausuariosempresa.splice(index, 1)
    },
    handleDownload() {
      var vm = this
      vm.downloadLoading = true
      import('@/vendor/Export2Excel').then(excel => {
        const tHeader   = ['idusuarioempresa', 'idusuario', 'nombre', 'idempresa', 'empresa', 'idrol', 'rol', 'usuarioregistro', 'fecharegistro']
        const filterVal = ['idusuarioempresa', 'idusuario', 'nombre', 'idempresa', 'empresa', 'idrol', 'rol', 'usuarioregistro', 'fecharegistro']
        const data      = vm.formatJson(filterVal)
        excel.export_json_to_excel({
          header: tHeader,
          data,
          filename: 'table-listausuariosempresa'
        })
        vm.downloadLoading = false
      })
    },
    formatJson(filterVal) {
      var vm = this
      return vm.listausuariosempresa.map(v => filterVal.map(j => {
        return v[j]
        // if (j === 'timestamp') {
        //   return parseTime(v[j])
        // } else {
        //   return v[j]
        // }
      }))
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
          idusuarioempresa : vm.obj.idusuarioempresa,
          nombre         : vm.obj.nombre,
          activo         : vm.obj.activo,
          flgarea        : vm.obj.flgarea,
          flgbrevete     : vm.obj.flgbrevete,
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
        vm.resetTemp()
      } else if (vm.tipoaccion === 2) {
        var validObj      = vm.isObjEmpty(vm.obj)
        if (validObj) {
          notify(vm, 'error', 'Error', 'Debe seleccionar un registro.')
          return
        }
        vm.cargarDatos()
        vm.dialogStatus = 'update'
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
      this.$refs.tbltipospersonal.setCurrentRow(row)
    },
    openModalEliminar (tipo) {
      var vm          = this
      vm.dialogStatus = 'delete'
      vm.tipoaccion   = tipo
      if (vm.arreglo.length === 0) {
        notify(vm, 'error', 'Error', 'Debe seleccionar un registro para esta accion.')
        return
      }
      vm.activarModalEliminarUsuario = true
    },
    closeModalEliminar () {
      var vm                          = this
      vm.$refs.tbltipospersonal.clearSelection()
      vm.tipoaccion                  = 0
      vm.dialogStatus                = ''
      vm.arreglo                  = []
      vm.activarModalEliminarUsuario = false
    },
    handleSelectionChange(val) {
      // console.log('val:>>> ', val)
      var vm               = this
      vm.arreglo = val
    },
    eliminarRegistros () {
      var vm                  = this
      vm.cargandoInformacion  = true
      var obj                 = {
        tipoaccion: vm.tipoaccion,
        arreglo   : vm.arreglo
      }
      console.log(obj)
      usuariosempresaMantenimiento(obj).then(data => {
        console.log('data: ', data)
        vm.cargandoInformacion = vm.isLoading
        var texto = vm.arreglo.length >= 2 ? 'Se han eliminado correctamente los rol' : 'Se ah elimiando correctamente el rol.'
        notify(vm, 'success', 'Éxito', texto)
        vm.closeModalEliminar()
        vm.fetch()
      }, function (err) {
        console.log(err)
        vm.cargandoInformacion = vm.isLoading
        notify(vm, 'error', 'Error', err.message)
      }, function () {
        vm.closeModalEliminar()
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
      console.log('vm.obj:>>> ', vm.obj)
      vm.openModalMantenimiento(2)
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
