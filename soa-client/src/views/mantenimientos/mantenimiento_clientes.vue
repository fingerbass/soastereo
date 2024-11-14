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
    el-dropdown(split-button='' style='margin-left: 10px; margin-right: 10px;' size='mini' type='success' icon='el-icon-download' :hide-on-click="true" :visible-change="true" @click='handleDownload' :disabled="downloadLoading")
      i.el-icon-download.el-icon--left
      | Exportar
      el-dropdown-menu(slot='dropdown')
        el-dropdown-item(icon='el-icon-download' @click.native.stop='handleDownloadExportar') Exportar Plantilla
        el-dropdown-item(icon='el-icon-upload' @click.native.stop='handleDownloadImportar') Importar Plantilla
    //- el-button.filter-item(v-waves='' :loading='cargandoInformacion' type='success' icon='el-icon-download' size='mini' @click='handleDownload')
    //-   | Limpiar
    el-button.filter-item(v-waves='' :loading='cargandoInformacion' type='success' icon='el-icon-refresh' size='mini' @click='fetch()' :disabled="cargandoInformacion")
      | Actualizar
  el-table(ref="tblclientes" @selection-change="handleSelectionChange" :key='tableKey' v-loading='cargandoInformacion' :data='listaclientes'  :border='false' fit='' highlight-current-row='' height="calc(100vh - 218px)" max-height="calc(100vh - 218px)" style="width: 100%;" size='mini' @sortByName-change='sortChange' @current-change="handleCurrentChange" :row-class-name="tableRowClassName" @cell-dblclick= "dblhandlecurrentchange" @row-click="rowClicked" @row-dblclick="rowDblClicked" empty-text="No existen Registros")
    el-table-column(type='selection' width='30')
    //- el-table-column(label='ID' prop='idcliente' sortable='custom' align='center' width='60' :class-name="getSortClass('idcliente')")
    //-   template(slot-scope='{row}')
    //-     span {{ row.idcliente }}
    el-table-column(label='Nombres' prop='nombres' align='left')
      template(slot-scope='{row}')
        span {{ row.nombres }}
    el-table-column(label='Apellidos' prop='apellidos' align='left')
      template(slot-scope='{row}')
        span {{ row.apellidos }}
    el-table-column(label='Nro Do.' prop='numerodocumento' align='center')
      template(slot-scope='{row}')
        span {{ row.numerodocumento }}
    //- el-table-column(label='Direccion' prop='direccion' align='left')
    //-   template(slot-scope='{row}')
    //-     span {{ row.direccion }}
    el-table-column(label='Distrito' prop='distrito' align='left')
      template(slot-scope='{row}')
        span {{ row.distrito }}
    //- el-table-column(label='Ciudad' prop='ciudad' align='left')
    //-   template(slot-scope='{row}')
    //-     span {{ row.ciudad }}
    el-table-column(label='Telefono' prop='telefono' align='center')
      template(slot-scope='{row}')
        span {{ row.telefono }}
    el-table-column(label='Email' prop='email' align='left')
      template(slot-scope='{row}')
        span {{ row.email }}
    el-table-column(label='Activo' prop='activo' align='center')
      template(slot-scope='{row}')
        //- span {{ row.activo }}
        el-checkbox(v-model='row.activo' size='mini' readonly)
    //- el-table-column(label='Logo' prop='logo' align='center')
    //-   template(slot-scope='{row}')
    //-     span {{ row.logo }}
    //- el-table-column(label='Isotipo' prop='isotipo' align='center')
    //-   template(slot-scope='{row}')
    //-     span {{ row.isotipo }}
    //- el-table-column(label='Usuario Registro' prop='usuarioregistro' align='center')
    //-   template(slot-scope='{row}')
    //-     span {{ row.usuarioregistro }}
    //- el-table-column(label='Fecha Registro' prop='fecharegistro' align='center')
    //-   template(slot-scope='{row}')
    //-     span {{ row.fecharegistro | formatDate }}
  pagination(v-show='totalpagination > 0' :total='totalpagination' :page.sync='pagination' :limit.sync='limit' @pagination='fetch')

  el-dialog(:title='textMap[dialogStatus]' v-if="dialogFormVisible" :visible.sync='dialogFormVisible' :close-on-click-modal='false' :close-on-press-escape='false' :show-close='false' @close="closeModalMantenimiento()" :width="isMovil ? '90%' : '50%'" top="8vh" center)
    form-clientes(v-if="dialogFormVisible" :title="textMap[dialogStatus]" :tipoaccion="tipoaccion" @save="fetch()" :model='obj' @close="closeModalMantenimiento()" center)

  el-dialog(:title='textMap[dialogStatus]' :visible.sync='activarModalEliminarEmpresa' :close-on-click-modal='false' :close-on-press-escape='false' :show-close='false' @close="closeModalliminar()" width='30%' center='')
    span.bold ¿Desea eliminar&nbsp;
    span.bold(v-if="arreglo.length === 1") este cliente
    span.bold(v-else) los clientes
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
import { clientesLista, clientesMantenimiento, clientesUUID, clientesUploadPlantillaCargaMasiva }   from '@/api/clientes.js'
import waves                                      from '@/directive/waves' // waves directive
// import { parseTime }                              from '@/utils'
import Pagination                                 from '@/components/Pagination' // secondary package based on el-pagination
import { mapState }                               from 'vuex'
import { notify }                                 from '../../utils/general.js'
import formclientes                               from '@/components/clientes'
import { apiUploadWithParams }                    from '@/utils/general'
import moment                                     from 'moment'

export default {
  name      : 'MantenimientoClientes',
  components: {
    Pagination,
    'form-clientes': formclientes
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
      listaclientes              : [],
      listaDetalle               : [],
      listaQuery                 : {},
      textSearch                 : '',
      sortByType                 : 'ASC',
      sortByName                 : '+idcliente',
      idestado                   : 2,
      limit          : 50,
      pagination                 : 1,
      totalpagination            : 0,
      tipoaccion                 : 0,
      idcliente                  : '',
      indexempresa               : '',
      obj                 : '',
      sortOptions                : [{ label: 'ID Ascending', key: '+idcliente' }, { label: 'ID Descending', key: '-idcliente' }],
      dialogFormVisible          : false,
      dialogStatus               : '',
      arreglo  : [],
      activarModalEliminarEmpresa: false,
      textMap                    : {
        update: 'Editar Clientes',
        create: 'Crear Clientes',
        delete: 'Eliminar Clientes'
      },
      dialogPvVisible: false,
      temporal               : {
        idcliente      : null,
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
      vm.listaclientes        = []
      vm.cargandoInformacion  = true
      vm.listaQuery = {
        textSearch: vm.textSearch,
        pagination: vm.pagination,
        limit     : vm.limit,
        idestado  : vm.idestado,
        sortByType: vm.sortByType,
        sortByName: vm.sortByName
      }
      clientesLista(vm.listaQuery).then(data => {
        console.log('data: ', data)
        for (let i = 0; i < data.lista.length; i++) {
          vm.listaclientes.push(data.lista[i])
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
      if (prop === 'idcliente') {
        vm.sortByID(order)
      }
    },
    sortByID(order) {
      var vm = this
      if (order === 'ascending') {
        vm.listaQuery.sortByName = '+idcliente'
      } else {
        vm.listaQuery.sortByName = '-idcliente'
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
        idcliente      : null,
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
        const tHeader   = ['idcliente', 'nombre', 'ruc', 'direccion', 'distrito', 'ciudad', 'telefono', 'email', 'activo', 'logo', 'isotipo', 'usuarioregistro', 'fecharegistro']
        const filterVal = ['nombre', 'idcliente', 'ruc', 'direccion', 'distrito', 'ciudad', 'telefono', 'email', 'activo', 'logo', 'isotipo', 'usuarioregistro', 'fecharegistro']
        const data      = vm.formatJson(filterVal)
        excel.export_json_to_excel({
          header: tHeader,
          data,
          filename: 'table-listaclientes'
        })
        vm.downloadLoading = false
      })
    },
    formatJson(filterVal) {
      var vm = this
      return vm.listaclientes.map(v => filterVal.map(j => {
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
          filename: 'plantilla-listaclientes'
        })
        vm.downloadLoading = false
      })
    },
    formatJsonExportar(filterVal) {
      // var vm = this
      var listaclientes = [
        {
          // idcliente      : !this.administrador ? JSON.parse(localStorage.getItem('itemclienteseleccionado')) : '',
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
      return listaclientes.map(v => filterVal.map(j => {
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
      var listaclientes = [
        {
          // idtercero      : '',
          idcliente      : !this.administrador ? JSON.parse(localStorage.getItem('itemclienteseleccionado')) : '',
          ruc            : '',
          nombre         : '',
          direccion      : '',
          activo         : 'VERDADERO',
          usuarioregistro: localStorage.getItem('username'),
          fecharegistro  : moment().format()
        }
      ]
      return listaclientes.map(v => filterVal.map(j => {
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
          idcliente      : vm.obj.idcliente,
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
      this.$refs.tblclientes.setCurrentRow(row)
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
      vm.$refs.tblclientes.clearSelection()
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
      clientesMantenimiento(obj).then(data => {
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
    },
    // EXCEL
    onSubmit (archivoSubir) {
      console.log('archivoSubir:>>> ', archivoSubir)
      var vm              = this
      vm.isSavingAdjunto  = true
      var obj = {
        tipoaccion: 1
      }
      clientesUUID(obj).then(data => {
        console.log('data: ', data)
        console.log('data.uuid:>>> : ', data.uuid)
        vm.isSavingAdjunto = vm.isLoading
        // if (archivoSubir && archivoSubir.length > 0) {
        if (JSON.stringify(archivoSubir) === '{}' || archivoSubir === null || archivoSubir === undefined) {
          vm.guardarAdjunto(data.uuid, archivoSubir, function(err, data) {
            if (err) {
              notify(vm, 'error', 'Error', err.message)
              return
            } else {
              notify(vm, 'success', 'Éxito', 'El registro se ah guardado satisfactoriamente.')
            }
          })
        }
      }, function (err) {
        vm.isSavingAdjunto = vm.isLoading
        notify(vm, 'error', 'Error', err.message)
      }, function () {
        vm.isSavingAdjunto = false
      })
    },
    guardarAdjunto (uuid, archivoSubir) {
      console.log('UPLOADING FILE', archivoSubir)
      var vm = this
      // var apiUploadRoute = process.env.API_UPLOAD_ROUTE
      // var url = `${apiUploadRoute}/upload`
      var url = `/upload`
      vm.isSavingAdjunto = true

      var fd = new FormData()
      fd.append('file', archivoSubir)
      var params = {
        carpeta     : 'app_achivos',
        idincidencia: null,
        uuid        : uuid || new Date(),
        usuario     : localStorage.getItem('login')
      }

      apiUploadWithParams(vm, url, fd, params,
        function (data) {
          vm.observaciones = []
          console.log('data:', data)
          console.log('data.file:', data.file)
          console.log('data.file.localPath:', data.file.path)
          // vm.validarPlantillaExcel(data.file.localPath, function (err, observaciones) {
          //   if (err) {
          //     notify(vm, 'warning', 'Error', 'Ha ocurrido un error al subir el archivo')
          //     console.error(err)
          //     vm.isSavingAdjunto = false
          //   } else {
          //     if (observaciones.length > 0) {
          //       notify(vm, 'warning', 'Error', 'Se encontraron observaciones en la plantilla.')
          //       console.log('observaciones :', observaciones)
          //       vm.observaciones = observaciones
          //       vm.$refs['dialog_errores_validador'].open();
          //       vm.isSavingAdjunto = false
          //     } else {
          vm.guardarPlantillaExcel(data.file.path, function (err) {
            if (err) {
              notify(vm, 'warning', 'Error', err.message)
              console.error(err)
              vm.isSavingAdjunto = false
              vm.closeAdjuntar()
            } else {
              this.$store.dispatch('procesos/openProcesos')
              vm.isSavingAdjunto = false
              vm.isSavedAdjunto  = true
              vm.closeAdjuntar()
            }
            vm.closeAdjuntar()
          })
          //     }
          //   }
          // })
        }, function (err) {
          console.error('err:>>> ', err)
          vm.closeAdjuntar()
        }, function () {
          vm.closeAdjuntar()
        }
      )
    },
    guardarPlantillaExcel (fileSubido, callback) {
      // var vm = this
      // var url = '/upload-plantilla-carga-masiva'
      // var obj = {
      //   fileSubido: fileSubido
      // }
      // console.log('obj :', obj)
      // // return
      // apiPost(vm, url, obj, function (data) {
      //   callback(null)
      // }, function (err) {
      //   callback(err)
      // })
      // var vm = this
      // var url = '/upload-plantilla-carga-masiva'
      var obj = {
        fileSubido: fileSubido
      }
      console.log('obj :', obj)
      // return
      clientesUploadPlantillaCargaMasiva(obj, function (data) {
        // this.$store.dispatch('procesos/openProcesos')
        callback(null)
      }, function (err) {
        callback(err)
      }, function () {
        callback()
      })
    },
    closeAdjuntar () {
      var vm                  = this
      vm.centerDialogVisible  = false
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
