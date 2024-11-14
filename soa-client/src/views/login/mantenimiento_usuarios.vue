<template lang="pug">
.app-container
  .filter-container.text-align-right
    //- el-row
    //-   el-input.filter-item.margin-right-5(v-model='textSearch' placeholder='Texto a buscar' style='width: 200px;' size='mini' @keyup.enter.native='handleFilter')
    //-   el-button.filter-item(v-waves='' type='primary' icon='el-icon-search' size='mini' @click='handleFilter')
    //- el-select.filter-item.margin-right-5(v-model='sortByName' style='width: 140px' size='mini' @change='handleFilter')
    //-   el-option(v-for='item in sortOptions' :key='item.key' :label='item.label' :value='item.key')
    el-button.filter-item(style='margin-left: 10px;' type='primary' icon='el-icon-plus' size='mini' @click='openModalMantenimiento(1)')
      | Nuevo
    el-button.filter-item(style='margin-left: 10px;' type='primary' icon='el-icon-edit' size='mini' @click='openModalMantenimiento(2)')
      | Editar
    el-button.filter-item(style='margin-left: 10px;' type='danger' icon='el-icon-delete' size='mini' @click='openModalUsuariosEliminar(3)')
      | Eliminar
    el-button.filter-item(v-waves='' :loading='downloadLoading' type='success' icon='el-icon-download' size='mini' @click='handleDownload')
      | Exportar
    //- el-button.filter-item(v-waves='' :loading='cargandoInformacion' type='success' icon='el-icon-download' size='mini' @click='handleDownload')
    //-   | Limpiar
    el-button.filter-item(v-waves='' :loading='cargandoInformacion' type='success' icon='el-icon-refresh' size='mini' @click='fetch()' :disabled="cargandoInformacion")
      | Actualizar
  el-table(ref="tblusuarios" @selection-change="handleSelectionChange" :key='tableKey' v-loading='cargandoInformacion' :border='false' fit='' highlight-current-row='' height="calc(100vh - 218px)" max-height="calc(100vh - 218px)" style="width: 100%;" size='mini' @sortByName-change='sortChange' @current-change="handleCurrentChange" :row-class-name="tableRowClassName" @cell-dblclick= "dblhandlecurrentchange" @row-click="rowClicked" @row-dblclick="rowDblClicked"
  :data="listaUsuarios" empty-text="No existen Registros")
    //- :data="listaUsuarios.filter(data => !search || data.nombre.toLowerCase().includes(search.toLowerCase()) || data.paterno.toLowerCase().includes(search.toLowerCase()) || data.materno.toLowerCase().includes(search.toLowerCase()))"

    //- el-table-column(align='top')
    //-   template(slot='header' slot-scope='scope')
    //-     el-input(v-model='search' size='mini' placeholder='Search')
    el-table-column(type='selection' width='30')
    //- el-table-column(label='ID' prop='idusuario' sortable='custom' align='center' width='60' :class-name="getSortClass('idusuario')")
      template(slot-scope='{row}')
        span {{ row.idusuario }}
    el-table-column(label='Login' prop='login' align='left')
      template(slot-scope='{row}')
        span {{ row.login }}
    el-table-column(label='Apellidos y Nombres' prop='paterno' align='left')
      template(slot-scope='{row}')
        span {{ row.paterno }} {{ row.materno }} {{ row.nombre }}
    //- el-table-column(label='Paterno' prop='paterno' align='center')
    //-   template(slot-scope='{row}')
    //-     span {{ row.paterno }}
    //- el-table-column(label='Materno' prop='materno' align='center')
    //-   template(slot-scope='{row}')
    //-     span {{ row.materno }}
    //- el-table-column(label='Nombre' prop='nombre' align='center')
    //-   template(slot-scope='{row}')
    //-     span {{ row.nombre }}
    //- el-table-column(label='Documento' prop='documento' align='center')
    //-   template(slot-scope='{row}')
    //-     span {{ row.documento }}
    el-table-column(label='Email' prop='email' align='left')
      template(slot-scope='{row}')
        span {{ row.email }}
    el-table-column(label='Movil' prop='movil' align='left' width='100')
      template(slot-scope='{row}')
        span {{ row.movil }}
    el-table-column(label='Ultimo Ingreso' prop='ultimoingreso' align='left' width='150')
      template(slot-scope='{row}')
        span(v-if="row.ultimoingreso !== null") {{ row.ultimoingreso | formatDate }}
    el-table-column(label='Cambio Clave' prop='cambioclave' align='left' width='150')
      template(slot-scope='{row}')
        span(v-if="row.cambioclave !== null") {{ row.cambioclave | formatDate }}
    el-table-column(label='Administrador' prop='administrador' align='center' width='80')
      template(slot-scope='{row}')
        //- span {{ row.administrador }}
        el-checkbox(v-model='row.administrador' size='mini')
    el-table-column(label='Activo' prop='activo' align='center' width='80')
      template(slot-scope='{row}')
        //- span {{ row.activo }}
        el-checkbox(v-model='row.activo' size='mini')
    //- el-table-column(label='Foto' prop='foto' align='center')
    //-   template(slot-scope='{row}')
    //-     span {{ row.foto }}
    //- el-table-column(label='Usuario Registro' prop='usuarioregistro' align='center')
    //-   template(slot-scope='{row}')
    //-     span {{ row.usuarioregistro }}
    //- el-table-column(label='Fecha Registro' prop='fecharegistro' align='center')
    //-   template(slot-scope='{row}')
    //-     span {{ row.fecharegistro | formatDate }}
    //- el-table-column(label='Fecha' width='150px' align='center')
    //-   template(slot-scope='{row}')
    //-     span {{ row.timestamp | parseTime('{y}-{m}-{d} {h}:{i}') }}
    //- el-table-column(label='Titulo' min-width='150px')
    //-   template(slot-scope='{row}')
    //-     span.link-type(@click='handleUpdate(row)') {{ row.title }}
    //-     el-tag(size='mini') {{ row.type | typeFilter }}
    //- el-table-column(label='Autor' width='110px' align='center')
    //-   template(slot-scope='{row}')
    //-     span {{ row.author }}
    //- el-table-column(label='Calificacion' width='80px')
    //-   template(slot-scope='{row}')
    //-     svg-icon.meta-item__icon(v-for='n in + row.importance' :key='n' icon-class='star')
    //- el-table-column(label='Estado' class-name='status-col' width='100')
    //-   template(slot-scope='{row}')
    //-     el-tag(:type='row.status | statusFilter')
    //-       | {{ row.status }}
    //- el-table-column(label='Accion' align='center' width='230' class-name='small-padding fixed-width')
    //-   template(slot-scope='{row, $index}')
    //-     el-button(type='primary' size='mini' @click='handleUpdate(row)')
    //-       | Editar
    //-     el-button(v-if="row.status!='published'" size='mini' type='success' @click="handleModifyStatus(row,'published')")
    //-       | Publicar
    //-     el-button(v-if="row.status!='draft'" size='mini' @click="handleModifyStatus(row,'draft')")
    //-       | Borrador
    //-     el-button(v-if="row.status!='deleted'" size='mini' type='danger' @click='handleDelete(row,$index)')
    //-       | Eliminar
  pagination(v-show='totalpagination > 0' :total='totalpagination' :page.sync='pagination' :limit.sync='limit' @pagination='fetch')

  el-dialog(:title='textMap[dialogStatus]' v-if="dialogFormVisible" :visible.sync='dialogFormVisible' :close-on-click-modal='false' :close-on-press-escape='false' :show-close='false' @close="closeModalMantenimiento()" :width="isMovil ? '90%' : '60%'" top="8vh" center)
    form-usuarios(v-if="dialogFormVisible" :title="textMap[dialogStatus]" :tipoaccion="tipoaccion" :model='objusuario' @save="fetch()" @close="closeModalMantenimiento()")

  el-dialog(:title='textMap[dialogStatus]' :visible.sync='activarModalEliminarUsuario' :close-on-click-modal='false' :close-on-press-escape='false' :show-close='false' @close="closeModalEliminar()" width='30%' center='')
    span.bold ¿Desea eliminar&nbsp;
    span.bold(v-if="arreglousuario.length === 1") este usuario
    span.bold(v-else) los usuarios
    span.bold ?
    span.dialog-footer(slot='footer')
      el-button(@click='closeModalEliminar()') Cancelar
      el-button(type='primary' @click='eliminarRegistros()') Eliminar

  //-   el-dialog(:title='textMap[dialogStatus]' :visible.sync='dialogFormVisible' :close-on-click-modal='false' :close-on-press-escape='false' :show-close='false')
  //-     el-form(ref='dataForm' :rules='rules' :model='temporal' label-position='left' label-width='70px' style='width: 400px; margin-left:50px;')
  //-       el-form-item(label='Fecha' prop='timestamp')
  //-         el-date-picker(v-model='temporal.timestamp' type='datetime' size='mini' placeholder='Please pick a date')
  //-       el-form-item(label='Titulo' prop='title')
  //-         el-input.is-uppercase(v-model='temporal.title' size='mini')
  //-       el-form-item(label='Estado')
  //-         el-select.filter-item(v-model='temporal.status' size='mini' placeholder='Please select')
  //-           el-option(v-for='item in statusOptions' :key='item' :label='item' :value='item')
  //-       el-form-item(label='Calificacion')
  //-         el-rate(v-model='temporal.importance' :colors="['#99A9BF', '#F7BA2A', '#FF9900']" size='mini' :max='3' style='margin-top:8px;')
  //-       el-form-item(label='Descripcion')
  //-         el-input.is-uppercase(v-model='temporal.remark' resize='none' :autosize='{ minRows: 2, maxRows: 3}' size='mini' type='textarea' placeholder='Please input')
  //-     .dialog-footer(slot='footer')
  //-       el-button(size='mini' @click='dialogFormVisible = false')
  //-         | Cancelar
  //-       el-button(type='primary' size='mini' @click="dialogStatus==='create'?createData():updateData()")
  //-         | Confirmar
  //-   el-dialog(:visible.sync='dialogPvVisible' title='Estadística de lectura' :close-on-click-modal='false' :close-on-press-escape='false' :show-close='false')
  //-     el-table(size='mini' :data='pvData' border='' fit='' highlight-current-row='' style='width: 100%')
  //-       el-table-column(prop='key' label='Channel')
  //-         el-table-column(prop='pv' label='Pv')
  //-     span.dialog-footer(slot='footer')
  //-       el-button(type='primary' size='mini' @click='dialogPvVisible = false') Confirmar
</template>

<script>
// import { createArticle, updateArticle }           from '@/api/article'
import { usuariosLista, usuariosMantenimiento }   from '@/api/usuarios'
import waves                                      from '@/directive/waves' // waves directive
// import { parseTime }                              from '@/utils'
import Pagination                                 from '@/components/Pagination' // secondary package based on el-pagination
import { mapState }                               from 'vuex'
import { notify }                                 from '../../utils/general.js'
import formUsuarios                               from '@/components/usuarios'

export default {
  name      : 'Usuarios',
  components: {
    Pagination,
    'form-usuarios': formUsuarios
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
      listaUsuarios              : [],
      listaDetalle               : [],
      listaQuery                 : {},
      search                     : '',
      textSearch                 : '',
      sortByType                 : 'ASC',
      sortByName                 : '+idusuario',
      idestado                   : 2,
      limit                      : 50,
      pagination                 : 1,
      totalpagination            : 0,
      tipoaccion                 : 0,
      idusuario                  : '',
      indexusuario               : '',
      objusuario                 : '',
      sortOptions                : [{ label: 'ID Ascending', key: '+idusuario' }, { label: 'ID Descending', key: '-idusuario' }],
      dialogFormVisible          : false,
      dialogStatus               : '',
      arreglousuario             : [],
      activarModalEliminarUsuario: false,
      textMap                    : {
        update: 'Editar Usuario',
        create: 'Crear Usuario',
        delete: 'Eliminar Usuarios'
      },
      dialogPvVisible: false,
      statusOptions  : ['published', 'draft', 'deleted'],
      temporal       : {
        idusuario      : null,
        paterno        : '',
        materno        : '',
        nombre         : '',
        idtipodocumento: '',
        documento      : '',
        login          : '',
        password       : '',
        email          : '',
        movil          : '',
        ultimoingreso  : '',
        cambioclave    : '',
        administrador  : '',
        activo         : true,
        foto           : '',
        usuarioregistro: localStorage.getItem('username'),
        fecharegistro  : ''
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
      vm.listaUsuarios        = []
      vm.cargandoInformacion  = true
      vm.listaQuery = {
        textSearch: vm.textSearch,
        pagination: vm.pagination,
        limit     : vm.limit,
        idestado  : vm.idestado,
        sortByType: vm.sortByType,
        sortByName: vm.sortByName
      }
      usuariosLista(vm.listaQuery).then(data => {
        console.log('data: ', data)
        for (let i = 0; i < data.lista.length; i++) {
          // data.lista[i].foto = data.lista[i].foto ? vm.arrayBufferToBase64(data.lista[i].foto.data) : null
          vm.listaUsuarios.push(data.lista[i])
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
    arrayBufferToBase64(buffer) {
      // var binary = ''
      // var bytes  = new Uint8Array(buffer)
      // var len    = bytes.byteLength
      // for (var i = 0; i < len; i++) {
      //   binary += String.fromCharCode(bytes[i])
      // }
      // return binary
      // The original utf8 string
      // const originalString = buffer
      // // Create buffer object, specifying utf8 as encoding
      // const bufferObj = Buffer.from(originalString, 'utf8')
      // // Encode the Buffer as a base64 string
      // const base64String = bufferObj.toString('base64')
      // console.log('The encoded base64 string is:', base64String)
      // var base64String = buffer.toString('base64')
      // console.log('base64String:>>> ', base64String)
      // const withPrefix = 'data:image/jpeg;base64,' + base64String;
      // console.log('withPrefix:>>> ', withPrefix)
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
      if (prop === 'idusuario') {
        vm.sortByID(order)
      }
    },
    sortByID(order) {
      var vm = this
      if (order === 'ascending') {
        vm.listaQuery.sortByName = '+idusuario'
      } else {
        vm.listaQuery.sortByName = '-idusuario'
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
        idusuario      : undefined,
        paterno        : '',
        materno        : '',
        nombre         : '',
        idtipodocumento: '',
        documento      : '',
        login          : '',
        email          : '',
        movil          : '',
        ultimoingreso  : '',
        cambioclave    : '',
        aadministrador : true,
        activo         : true,
        foto           : '',
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
    createData() {
      this.$refs['dataForm'].validate((valid) => {
        if (valid) {
          this.temporal.id = parseInt(Math.random() * 100) + 1024 // mock a id
          this.temporal.author = 'soa'
          // createArticle(this.temporal).then(() => {
          //   this.listaUsuarios.unshift(this.temporal)
          //   this.dialogFormVisible = false
          //   this.$notify({
          //     title   : 'Success',
          //     message : 'Creado con éxito.',
          //     type    : 'success',
          //     duration: 2000
          //   })
          // })
        }
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
    updateData() {
      this.$refs['dataForm'].validate((valid) => {
        if (valid) {
          const tempData = Object.assign({}, this.temporal)
          tempData.timestamp = +new Date(tempData.timestamp) // change Thu Nov 30 2017 16:41:05 GMT+0800 (CST) to 1512031311464
          // updateArticle(tempData).then(() => {
          //   const index = this.listaUsuarios.findIndex(v => v.id === this.temporal.id)
          //   this.listaUsuarios.splice(index, 1, this.temporal)
          //   this.dialogFormVisible = false
          //   this.$notify({
          //     title   : 'Success',
          //     message : 'Actualizar correctamente.',
          //     type    : 'success',
          //     duration: 2000
          //   })
          // })
        }
      })
    },
    handleDelete(row, index) {
      this.$notify({
        title   : 'Success',
        message : 'Eliminar con éxito.',
        type    : 'success',
        duration: 2000
      })
      this.listaUsuarios.splice(index, 1)
    },
    handleDownload() {
      var vm = this
      vm.downloadLoading = true
      import('@/vendor/Export2Excel').then(excel => {
        const tHeader   = ['idusuario', 'paterno', 'materno', 'nombre', 'documento', 'login', 'email', 'movil', 'ultimoingreso', 'cambioclave', 'activo foto', 'usuarioregistro', 'fecharegistro']
        const filterVal = ['idusuario', 'paterno', 'materno', 'nombre', 'documento', 'login', 'email', 'movil', 'ultimoingreso', 'cambioclave', 'activo foto', 'usuarioregistro', 'fecharegistro']
        const data      = vm.formatJson(filterVal)
        excel.export_json_to_excel({
          header: tHeader,
          data,
          filename: 'table-listaUsuarios'
        })
        vm.downloadLoading = false
      })
    },
    formatJson(filterVal) {
      var vm = this
      return vm.listaUsuarios.map(v => filterVal.map(j => {
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
          idusuario      : vm.objusuario.idusuario,
          paterno        : vm.objusuario.paterno,
          materno        : vm.objusuario.materno,
          nombre         : vm.objusuario.nombre,
          documento      : vm.objusuario.documento,
          login          : vm.objusuario.login,
          password       : vm.objusuario.password,
          email          : vm.objusuario.email,
          movil          : vm.objusuario.movil,
          ultimoingreso  : vm.objusuario.ultimoingreso,
          cambioclave    : vm.objusuario.cambioclave,
          activo         : vm.objusuario.activo,
          foto           : vm.objusuario.foto,
          usuarioregistro: vm.objusuario.usuarioregistro,
          fecharegistro  : vm.objusuario.fecharegistro
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
        // console.log('vm.objusuario: ', vm.objusuario)
        var validObj      = vm.isObjEmpty(vm.objusuario)
        // console.log('validObj: ', validObj)
        if (validObj || validObj === null) {
          notify(vm, 'error', 'Error', 'Debe seleccionar un registro.')
          return
        }
        vm.cargarDatos()
        vm.dialogStatus = 'update'
        // vm.temporal     = Object.assign({}, vm.objusuario)
      }
      vm.dialogFormVisible = true
    },
    closeModalMantenimiento () {
      var vm                = this
      vm.tipoaccion         = 0
      vm.dialogStatus       = ''
      vm.objusuario         = {}
      // // vm.resetTemp()
      vm.setCurrent()
      vm.dialogFormVisible  = false
    },
    setCurrent (row) {
      this.$refs.tblusuarios.setCurrentRow(row)
    },
    openModalUsuariosEliminar (tipo) {
      var vm          = this
      vm.dialogStatus = 'delete'
      vm.tipoaccion   = tipo
      if (vm.arreglousuario.length === 0) {
        notify(vm, 'error', 'Error', 'Debe seleccionar un registro para esta accion.')
        return
      }
      vm.activarModalEliminarUsuario = true
    },
    closeModalEliminar () {
      var vm                          = this
      vm.$refs.tblusuarios.clearSelection()
      vm.tipoaccion                   = 0
      vm.dialogStatus                 = ''
      vm.arreglousuario               = []
      vm.activarModalEliminarUsuario  = false
    },
    handleSelectionChange(val) {
      // console.log('val:>>> ', val)
      var vm               = this
      vm.arreglousuario = val
    },
    eliminarRegistros () {
      var vm                  = this
      vm.cargandoInformacion  = true
      var obj                 = {
        tipoaccion    : vm.tipoaccion,
        arreglousuario: vm.arreglousuario
      }
      usuariosMantenimiento(obj).then(data => {
        console.log('data: ', data)
        vm.cargandoInformacion = vm.isLoading
        var texto = vm.arreglousuario.length >= 2 ? 'Se han eliminado correctamente los usuarios' : 'Se ah elimiando correctamente el usuario.'
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
      vm.objusuario = item
      console.log('vm.objusuario:>>> ', vm.objusuario)
    },
    rowClicked (row) {
      var vm        = this
      vm.objusuario = row
      console.log('vm.objusuario:>>> ', vm.objusuario)
    },
    rowDblClicked (row) {
      var vm        = this
      vm.objusuario = row
      console.log('vm.objusuario:>>> ', vm.objusuario)
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
