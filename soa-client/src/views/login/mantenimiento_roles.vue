<!-- <template lang="pug">
.app-container
  el-button(type='primary' size="mini" @click='handleAddRole') Nuevo Rol
  el-table(:data='rolesList' size="mini" style='width: 100%;margin-top:30px;' border='')
    el-table-column(align='center' label='Role Key' width='220')
      template(slot-scope='scope')
        | {{ scope.row.key }}
    el-table-column(align='center' label='Role Name' width='220')
      template(slot-scope='scope')
        | {{ scope.row.name }}
    el-table-column(align='header-center' label='Description')
      template(slot-scope='scope')
        | {{ scope.row.description }}
    el-table-column(align='center' label='Operations')
      template(slot-scope='scope')
        el-button(type='primary' size='mini' @click='handleEdit(scope)') Editar
        el-button(type='danger' size='mini' @click='handleDelete(scope)') Eliminar
  el-dialog(:visible.sync='dialogVisible' :title="dialogType==='edit'?'Editar Rol':'Nuevo Rol'" :close-on-click-modal="false" :close-on-press-escape="false" :show-close="false")
    el-form(:model='role' label-width='80px' label-position='left')
      el-form-item(label='Nombre')
        el-input.is-uppercase(v-model='role.name' placeholder='Nombre de Rol')
      el-form-item(label='Descripcion')
        el-input.is-uppercase(v-model='role.description' :autosize='{ minRows: 2, maxRows: 4}' type='textarea' placeholder='Descripcion Rol')
      el-form-item(label='Menus')
        el-tree.permission-tree.min-max-over(ref='tree' :check-strictly='checkStrictly' :data='routesData' :props='defaultProps' show-checkbox='' node-key='path')
    div(style='text-align:right;')
      el-button(type='danger' size="mini" @click='dialogVisible=false') Cancelar
      el-button(type='primary' size="mini" @click='confirmRole') Confirmar
</template>

<script>
import path from 'path'
import { deepClone } from '@/utils'
import { getRoutes, getRoles, addRole, deleteRole, updateRole } from '@/api/role'

const defaultRole = {
  key: '',
  name: '',
  description: '',
  routes: []
}

export default {
  name: 'UsuariosAcceso',
  components: {},
  props: [],
  data() {
    return {
      role         : Object.assign({}, defaultRole),
      routes       : [],
      rolesList    : [],
      dialogVisible: false,
      dialogType   : 'new',
      checkStrictly: false,
      defaultProps : {
        children: 'children',
        label   : 'title'
      },
      isLoading: false
    }
  },
  computed: {
    routesData() {
      return this.routes
    }
  },
  created() {
    // Mock: get all routes and roles list from server
    this.getRoutes()
    this.getRoles()
  },
  methods: {
    async getRoutes() {
      const res = await getRoutes()
      this.serviceRoutes = res.data
      this.routes = this.generateRoutes(res.data)
    },
    async getRoles() {
      const res = await getRoles()
      this.rolesList = res.data
    },

    // Reshape the routes structure so that it looks the same as the sidebar
    generateRoutes(routes, basePath = '/') {
      const res = []

      for (let route of routes) {
        // skip some route
        if (route.hidden) { continue }

        const onlyOneShowingChild = this.onlyOneShowingChild(route.children, route)

        if (route.children && onlyOneShowingChild && !route.alwaysShow) {
          route = onlyOneShowingChild
        }

        const data = {
          path: path.resolve(basePath, route.path),
          title: route.meta && route.meta.title

        }

        // recursive child routes
        if (route.children) {
          data.children = this.generateRoutes(route.children, data.path)
        }
        res.push(data)
      }
      return res
    },
    generateArr(routes) {
      let data = []
      routes.forEach(route => {
        data.push(route)
        if (route.children) {
          const temp = this.generateArr(route.children)
          if (temp.length > 0) {
            data = [...data, ...temp]
          }
        }
      })
      return data
    },
    handleAddRole() {
      this.role = Object.assign({}, defaultRole)
      if (this.$refs.tree) {
        this.$refs.tree.setCheckedNodes([])
      }
      this.dialogType = 'new'
      this.dialogVisible = true
    },
    handleEdit(scope) {
      this.dialogType = 'edit'
      this.dialogVisible = true
      this.checkStrictly = true
      this.role = deepClone(scope.row)
      this.$nextTick(() => {
        const routes = this.generateRoutes(this.role.routes)
        this.$refs.tree.setCheckedNodes(this.generateArr(routes))
        // set checked state of a node not affects its father and child nodes
        this.checkStrictly = false
      })
    },
    handleDelete({ $index, row }) {
      this.$confirm('¿Confirmar para eliminar el rol?', 'Warning', {
        confirmButtonText: 'Confirm',
        cancelButtonText: 'Cancel',
        type: 'warning'
      })
        .then(async() => {
          await deleteRole(row.key)
          this.rolesList.splice($index, 1)
          this.$message({
            type: 'success',
            message: 'Delete succed!'
          })
        })
        .catch(err => { console.error(err) })
    },
    generateTree(routes, basePath = '/', checkedKeys) {
      const res = []

      for (const route of routes) {
        const routePath = path.resolve(basePath, route.path)

        // recursive child routes
        if (route.children) {
          route.children = this.generateTree(route.children, routePath, checkedKeys)
        }

        if (checkedKeys.includes(routePath) || (route.children && route.children.length >= 1)) {
          res.push(route)
        }
      }
      return res
    },
    async confirmRole() {
      const isEdit = this.dialogType === 'edit'

      const checkedKeys = this.$refs.tree.getCheckedKeys()
      this.role.routes = this.generateTree(deepClone(this.serviceRoutes), '/', checkedKeys)

      if (isEdit) {
        await updateRole(this.role.key, this.role)
        for (let index = 0; index < this.rolesList.length; index++) {
          if (this.rolesList[index].key === this.role.key) {
            this.rolesList.splice(index, 1, Object.assign({}, this.role))
            break
          }
        }
      } else {
        const { data } = await addRole(this.role)
        this.role.key = data.key
        this.rolesList.push(this.role)
      }

      const { description, key, name } = this.role
      this.dialogVisible = false
      this.$notify({
        title: 'Success',
        dangerouslyUseHTMLString: true,
        message: `
            <div>Clave de rol: ${key}</div>
            <div>Nombre de rol: ${name}</div>
            <div>Descripcion: ${description}</div>
          `,
        type: 'success'
      })
    },
    // reference: src/view/layout/components/Sidebar/SidebarItem.vue
    onlyOneShowingChild(children = [], parent) {
      let onlyOneChild = null
      const showingChildren = children.filter(item => !item.hidden)

      // When there is only one child route, the child route is displayed by default
      if (showingChildren.length === 1) {
        onlyOneChild = showingChildren[0]
        onlyOneChild.path = path.resolve(parent.path, onlyOneChild.path)
        return onlyOneChild
      }

      // Show parent if there are no child route to display
      if (showingChildren.length === 0) {
        onlyOneChild = { ... parent, path: '', noShowingChildren: true }
        return onlyOneChild
      }

      return false
    }
  }
}
</script>

<style lang="scss" scoped>
.app-container {
  .roles-table {
    margin-top: 30px;
  }
  .permission-tree {
    margin-bottom: 30px;
  }

  .min-max-over {
    overflow-x: scroll;
    min-height: calc(100vh - 480px);
    max-height: calc(100vh - 480px);
  }
}
</style> -->
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
    el-button.filter-item(v-waves='' :loading='downloadLoading' type='success' icon='el-icon-download' size='mini' @click='handleDownload')
      | Exportar
    //- el-button.filter-item(v-waves='' :loading='cargandoInformacion' type='success' icon='el-icon-download' size='mini' @click='handleDownload')
    //-   | Limpiar
    el-button.filter-item(v-waves='' :loading='cargandoInformacion' type='success' icon='el-icon-refresh' size='mini' @click='fetch()' :disabled="cargandoInformacion")
      | Actualizar
  el-table(ref="tblroles" @selection-change="handleSelectionChange" :key='tableKey' v-loading='cargandoInformacion' :data='listaRoles'  :border='false' fit='' highlight-current-row='' height="calc(100vh - 218px)" max-height="calc(100vh - 218px)" style="width: 100%;" size='mini' @sortByName-change='sortChange' @current-change="handleCurrentChange" :row-class-name="tableRowClassName" @cell-dblclick= "dblhandlecurrentchange" @row-click="rowClicked" @row-dblclick="rowDblClicked" empty-text="No existen Registros")
    el-table-column(type='selection' width='30')
    el-table-column(label='ID' prop='idrol' sortable='custom' align='left' width='60' :class-name="getSortClass('idrol')")
      template(slot-scope='{row}')
        span {{ row.idrol }}
    el-table-column(label='Nombre' prop='nombre' align='left')
      template(slot-scope='{row}')
        span {{ row.nombre }}
    el-table-column(label='Activo' prop='activo' align='center')
      template(slot-scope='{row}')
        //- span {{ row.activo }}
        el-checkbox(v-model='row.activo' size='mini')
    el-table-column(label='Usuario Registro' prop='usuarioregistro' align='left')
      template(slot-scope='{row}')
        span {{ row.usuarioregistro }}
    el-table-column(label='Fecha Registro' prop='fecharegistro' align='center')
      template(slot-scope='{row}')
        span {{ row.fecharegistro | formatDate }}
  pagination(v-show='totalpagination > 0' :total='totalpagination' :page.sync='pagination' :limit.sync='limit' @pagination='fetch')

  el-dialog(:title='textMap[dialogStatus]' v-if="dialogFormVisible" :visible.sync='dialogFormVisible' :close-on-click-modal='false' :close-on-press-escape='false' :show-close='false' @close="closeModalMantenimiento()" width="60%" top="8vh" center)
    form-rol(v-if="dialogFormVisible" :title="textMap[dialogStatus]" :tipoaccion="tipoaccion" :model='obj' @save="fetch()" @close="closeModalMantenimiento()")

  el-dialog(:title='textMap[dialogStatus]' :visible.sync='activarModalEliminarUsuario' :close-on-click-modal='false' :close-on-press-escape='false' :show-close='false' @close="closeModalEliminar()" width='30%' center='')
    span.bold ¿Desea eliminar&nbsp;
    span.bold(v-if="arreglo.length === 1") este rol
    span.bold(v-else) los roles
    span.bold ?
    span.dialog-footer(slot='footer')
      el-button(@click='closeModalEliminar()') Cancelar
      el-button(type='primary' @click='eliminarRegistros()') Eliminar
</template>

<script>
import { rolesLista, rolesMantenimiento }   from '@/api/roles'
import waves                                from '@/directive/waves'        // waves directive
import Pagination                           from '@/components/Pagination'  // secondary package based on el-pagination
import { mapState }                         from 'vuex'
import { notify }                           from '../../utils/general.js'
import formRoles                            from '@/components/roles'

export default {
  name      : 'MantenimientoRoles',
  components: {
    Pagination,
    'form-rol': formRoles
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
      listaRoles              : [],
      listaDetalle               : [],
      listaQuery                 : {},
      textSearch                 : '',
      sortByType                 : 'ASC',
      sortByName                 : '+idrol',
      idestado                   : 2,
      limit                      : 50,
      pagination                 : 1,
      totalpagination            : 0,
      tipoaccion                 : 0,
      idrol                  : '',
      indexusuario               : '',
      obj                 : '',
      sortOptions                : [{ label: 'ID Ascending', key: '+idrol' }, { label: 'ID Descending', key: '-idrol' }],
      dialogFormVisible          : false,
      dialogStatus               : '',
      arreglo  : [],
      activarModalEliminarUsuario: false,
      textMap                    : {
        update: 'Editar Rol',
        create: 'Crear Rol',
        delete: 'Eliminar Rol'
      },
      dialogPvVisible: false,
      temporal       : {
        idrol      : null,
        nombre         : '',
        activo         : true,
        usuarioregistro: localStorage.getItem('username'),
        fecharegistro  : ''
      },
      rules          : {
        type     : [{ required: true, message: 'type is required', trigger: 'change' }],
        timestamp: [{ type: 'date', required: true, message: 'timestamp is required', trigger: 'change' }],
        title    : [{ required: true, message: 'title is required', trigger: 'blur' }]
      },
      downloadLoading: false,
      currentRow     : null
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
      vm.listaRoles        = []
      vm.cargandoInformacion  = true
      vm.listaQuery = {
        textSearch: vm.textSearch,
        pagination: vm.pagination,
        limit     : vm.limit,
        idestado  : vm.idestado,
        sortByType: vm.sortByType,
        sortByName: vm.sortByName
      }
      rolesLista(vm.listaQuery).then(data => {
        console.log('data: ', data)
        for (let i = 0; i < data.lista.length; i++) {
          vm.listaRoles.push(data.lista[i])
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
      if (prop === 'idrol') {
        vm.sortByID(order)
      }
    },
    sortByID(order) {
      var vm = this
      if (order === 'ascending') {
        vm.listaQuery.sortByName = '+idrol'
      } else {
        vm.listaQuery.sortByName = '-idrol'
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
        idrol      : null,
        nombre         : '',
        activo         : true,
        usuarioregistro: localStorage.getItem('username'),
        fecharegistro  : ''
      }
    },
    handleDownload() {
      var vm = this
      vm.downloadLoading = true
      import('@/vendor/Export2Excel').then(excel => {
        const tHeader   = ['idrol', 'nombre', 'activo', 'usuarioregistro', 'fecharegistro']
        const filterVal = ['idrol', 'nombre', 'activo', 'usuarioregistro', 'fecharegistro']
        const data      = vm.formatJson(filterVal)
        excel.export_json_to_excel({
          header: tHeader,
          data,
          filename: 'table-listaRoles'
        })
        vm.downloadLoading = false
      })
    },
    formatJson(filterVal) {
      var vm = this
      return vm.listaRoles.map(v => filterVal.map(j => {
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
          idrol          : vm.obj.idrol,
          nombre         : vm.obj.nombre,
          activo         : vm.obj.activo,
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
      this.$refs.tblroles.setCurrentRow(row)
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
      vm.$refs.tblroles.clearSelection()
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
        arreglo: vm.arreglo
      }
      console.log(obj)
      rolesMantenimiento(obj).then(data => {
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
