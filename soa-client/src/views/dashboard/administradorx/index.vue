<template lang="pug">
div.dashboard-vigilante-container
  //- el-row
  //-   el-col(:xs="24" :sm="24" :md="24" :lg="24" :xl="24")
  //-     el-button(size='mini' type="success" @click="fetch()" style='width: 100%;' :loading="cargandoInformacion" :disabled="cargandoInformacion") Actualizar
  el-row
    panel-group(:lineChartData="lineChartData" @handleSetLineChartData='handleSetLineChartData')
  el-row(:gutter='20')
    el-col(:xs='24' :sm='24' :md="12" :lg="12" :xl="12")
      .chart-wrapper
        pie-chart-ingreso-salida(ref="personas")
    el-col(:xs='24' :sm='24' :md="12" :lg="12" :xl="12")
      .chart-wrapper
        bar-chart-activos(ref="activos")
    el-col(:xs='24' :sm='24' :md="12" :lg="12" :xl="12")
      .chart-wrapper
        pie-chart-correspondencia(ref="correspondencia")
    el-col(:xs='24' :sm='24' :md="12" :lg="12" :xl="12")
      .chart-wrapper
        pie-chart-incidencias(ref="incidencias")
  a.boton-floating-actualizar.animated.fadeInUp.faster(:loading="cargandoInformacion" @click="fetch()" :disabled="cargandoInformacion")
    span.icon
      i.el-icon-refresh
  //- el-row(style='background:#fff;padding:16px 16px 0;margin-bottom:32px;')
  //-   line-chart(:chart-data='lineChartData')
  //- el-row(:gutter='8')
  //-   el-col(:xs='{span: 24}' :sm='{span: 24}' :md='{span: 24}' :lg='{span: 12}' :xl='{span: 12}' style='padding-right:8px;margin-bottom:30px;')
  //-     transaction-table
  //-   el-col(:xs='{span: 24}' :sm='{span: 12}' :md='{span: 12}' :lg='{span: 6}' :xl='{span: 6}' style='margin-bottom:30px;')
  //-     todo-list
  //-   el-col(:xs='{span: 24}' :sm='{span: 12}' :md='{span: 12}' :lg='{span: 6}' :xl='{span: 6}' style='margin-bottom:30px;')
  //-     box-card

//- div.dashboard-vigilante-container
//-   div
//-     span.display_name {{ name }}
//-   el-row
//-     panel-group(@handlesetlinechartdata='handleSetLineChartData')
//-   el-row
//-     el-col(:xs="24" :sm="24" :md="24" :lg="24" :xl="24")
//-       el-button(size='mini' type="success" @click="actualizar()" style='width: 100%; margin-bottom: 20px' :loading="cargandoInformacion" :disabled="cargandoInformacion") Actualizar
//-     //- <div class=" clearfix">
//-     //-   <pan-thumb :image="avatar" style="float: left">
//-     //-     Tus Roles:
//-     //-     <span v-for="item in roles" :key="item" class="pan-info-roles">{{ item }}</span>
//-     //-   </pan-thumb>
//-     //-   <div class="info-container">
//-     //-     <span class="display_name">{{ name }}</span>
//-     //-     <span style="font-size:20px;padding-top:20px;display:inline-block;">{{ name }} Dashboard</span>
//-     //-   </div>
//-     //- </div>
//-     //- <div>
//-     //-   <img :src="emptyGif" class="emptyGif">
//-     //- </div>
//-     el-col(:xs="24" :sm="24" :md="8" :lg="8" :xl="8")
//-       el-card.box-card(shadow='hover')
//-         .clearfix(slot='header')
//-           span Data 1
//-           el-button(style='float: right; padding: 0px 0' type='text') Actualizar
//-         .text.item
//-           span Registro 1, en espera...
//-     el-col(:xs="24" :sm="24" :md="8" :lg="8" :xl="8")
//-       el-card.box-card(shadow='hover')
//-         .clearfix(slot='header')
//-           span Data 2
//-           el-button(style='float: right; padding: 0px 0' type='text') Actualizar
//-         .text.item
//-           span Registro 2, en espera...
//-     el-col(:xs="24" :sm="24" :md="8" :lg="8" :xl="8")
//-       el-card.box-card(shadow='hover')
//-         .clearfix(slot='header')
//-           span Data 3
//-           el-button(style='float: right; padding: 0px 0' type='text') Actualizar
//-         .text.item
//-           span Registro 3, en espera...
//-     el-col(:xs="24" :sm="24" :md="8" :lg="8" :xl="8")
//-       el-card.box-card(shadow='hover')
//-         .clearfix(slot='header')
//-           span Data 4
//-           el-button(style='float: right; padding: 0px 0' type='text') Actualizar
//-         .text.item
//-           span Registro 4, en espera...
//-     el-col(:xs="24" :sm="24" :md="8" :lg="8" :xl="8")
//-       el-card.box-card(shadow='hover')
//-         .clearfix(slot='header')
//-           span Data 5
//-           el-button(style='float: right; padding: 0px 0' type='text') Actualizar
//-         .text.item
//-           span Registro 5, en espera...
//-     el-col(:xs="24" :sm="24" :md="8" :lg="8" :xl="8")
//-       el-card.box-card(shadow='hover')
//-         .clearfix(slot='header')
//-           span Data 6
//-           el-button(style='float: right; padding: 0px 0' type='text') Actualizar
//-         .text.item
//-           span Registro 6, en espera...
</template>

<script>
import PanelGroup                                           from './components/PanelGroup'
import PieChartIngresoSalida                                from './components/PieChart_ingresosalida'
import BarChartActivos                                      from './components/BarChart_activos'
import PieChartCorrespondencia                              from './components/PieChart_correspondencia'
import PieChartIncidencias                                  from './components/PieChart_incidencias'
import { dashboardListaPersonas, dashboardListaActivos, dashboardListaCorrespondencia, dashboardListaIncidencias }  from '@/api/dashboard'
import { notify }                                           from '@/utils/general.js'
import { mapGetters }                                       from 'vuex'
// lo que no se utiliza
import LineChart        from './components/LineChart'
import RaddarChart      from './components/RaddarChart'
import PieChart         from './components/PieChart'
import BarChart         from './components/BarChart'
import TransactionTable from './components/TransactionTable'
import TodoList         from './components/TodoList'
import BoxCard          from './components/BoxCard'
// import moment                     from 'moment'
// import _                          from 'lodash'
// import PanThumb from '@/components/PanThumb'

const lineChartData = {
  personas: {
    cantidad    : 0,
    expectedData: [100, 120, 161, 134, 105, 160, 165],
    actualData  : [120, 82, 91, 154, 162, 140, 145]
  },
  activos: {
    cantidad    : 0,
    expectedData: [200, 192, 120, 144, 160, 130, 140],
    actualData  : [180, 160, 151, 106, 145, 150, 130]
  },
  correspondencia: {
    cantidad    : 0,
    expectedData: [80, 100, 121, 104, 105, 90, 100],
    actualData  : [120, 90, 100, 138, 142, 130, 130]
  },
  incidencias: {
    cantidad    : 0,
    expectedData: [130, 140, 141, 142, 145, 150, 160],
    actualData  : [120, 82, 91, 154, 162, 140, 130]
  }
}

export default {
  name: 'DashboardVigilante',
  // components: { PanThumb },
  components: {
    PanelGroup,
    PieChartIngresoSalida,
    BarChartActivos,
    PieChartCorrespondencia,
    PieChartIncidencias,
    LineChart,
    RaddarChart,
    PieChart,
    BarChart,
    TransactionTable,
    TodoList,
    BoxCard
  },
  data() {
    return {
      emptyGif                : '',
      cargandoInformacion     : false,
      lineChartData           : lineChartData,
      listaPersonas           : [],
      cantidadPersonas        : 0,
      isLoadingPersonas       : false,
      listaActivos            : [],
      cantidadActivos         : 0,
      isLoadingActivos        : false,
      listaCorrespondencia    : [],
      cantidadCorrespondencia : 0,
      isLoadingCorrespondencia: false,
      listaIncidencias        : [],
      cantidadIncidencias     : 0,
      isLoadingIncidencias    : false,
      administrador           : JSON.parse(localStorage.getItem('administrador')),
      itemEmpresaSeleccionado : JSON.parse(localStorage.getItem('itemEmpresaSeleccionado'))
    }
  },
  computed: {
    ...mapGetters([
      'name',
      'avatar',
      'roles'
    ])
  },
  created() {
    // var vm = this
    // vm.fetch()
    // console.log('this.roles:>>>', this.roles)
    // var vm = this
    // vm.itemEmpresaSeleccionado = JSON.parse(localStorage.getItem('itemEmpresaSeleccionado'))
    // // console.log('vm.itemEmpresaSeleccionado', vm.itemEmpresaSeleccionado)
    // vm.itemServicioSeleccionado = JSON.parse(localStorage.getItem('itemServicioSeleccionado'))
    // // console.log('vm.itemServicioSeleccionado', vm.itemServicioSeleccionado)
  },
  mounted() {
    var vm = this
    vm.fetch()
    // var vm = this
    // vm.itemEmpresaSeleccionado = JSON.parse(localStorage.getItem('itemEmpresaSeleccionado'))
    // // console.log('vm.itemEmpresaSeleccionado', vm.itemEmpresaSeleccionado)
    // vm.itemServicioSeleccionado = JSON.parse(localStorage.getItem('itemServicioSeleccionado'))
    // // console.log('vm.itemServicioSeleccionado', vm.itemServicioSeleccionado)
    // const administrador = JSON.parse(localStorage.getItem('ADMINISTRADOR'))
    // if (!administrador) {
    //   if (vm.itemEmpresaSeleccionado === null && vm.itemServicioSeleccionado === null) {
    //     vm.$router.push({ path: '/' })
    //   }
    // } else {
    //   vm.$router.push({ path: '/dashboard' })
    // }
  },
  methods : {
    actualizar () {
      console.log('actualizar')
      this.handleSetLineChartData()
    },
    handleSetLineChartData(type) {
      var vm = this
      // console.log('type:>>> ', type)
      // console.log('this.lineChartData:>>> ', this.lineChartData)
      // console.log('this.lineChartData[type]:>>> ', this.lineChartData[type])
      // this.lineChartData = lineChartData[type]
      if (type === 'personas') {
        vm.obtenerListaPersonas()
      } else if (type === 'activos') {
        vm.obtenerListaActivos()
      } else if (type === 'correspondencia') {
        vm.obtenerListaCorrespondencia()
      } else if (type === 'incidencias') {
        vm.obtenerListaIncidencias()
      }
    },
    fetch () {
      var vm = this
      vm.$nextTick(function () {
        vm.obtenerListaPersonas()
        vm.$refs.personas.fetch()
        vm.obtenerListaActivos()
        vm.$refs.activos.fetch()
        vm.obtenerListaCorrespondencia()
        vm.$refs.correspondencia.fetch()
        vm.obtenerListaIncidencias()
        vm.$refs.incidencias.fetch()
      })
    },
    obtenerListaPersonas() {
      // console.log('obtenerListaPersonas')
      var vm                = this
      vm.listaPersonas      = []
      vm.isLoadingPersonas  = true
      var obj = {
        idestado : 2,
        idempresa: vm.itemEmpresaSeleccionado.idempresa
      }
      // console.log('obj:>>> ', obj)
      dashboardListaPersonas(obj).then(data => {
        // console.log('data personas:>>> ', data)
        for (let i = 0; i < data.lista.length; i++) {
          vm.listaPersonas.push(data.lista[i])
        }
        vm.cantidadPersonas                = data.cantidad
        vm.lineChartData.personas.cantidad = data.cantidad
        vm.isLoadingPersonas               = vm.isLoading
      }, function (err) {
        vm.isLoadingPersonas = vm.isLoading
        notify(vm, 'error', 'Error', err.message)
      }, function () {
        vm.isLoadingPersonas = false
      })
    },
    obtenerListaActivos() {
      // console.log('obtenerListaActivos')
      var vm                = this
      vm.listaActivos       = []
      vm.isLoadingActivos   = true
      var obj = {
        idestado : 2,
        idempresa: vm.itemEmpresaSeleccionado.idempresa
      }
      // console.log('obj:>>> ', obj)
      dashboardListaActivos(obj).then(data => {
        // console.log('data activos:>>> ', data)
        for (let i = 0; i < data.lista.length; i++) {
          vm.listaActivos.push(data.lista[i])
        }
        vm.cantidadActivos                = data.cantidad
        vm.lineChartData.activos.cantidad = data.cantidad
        vm.isLoadingActivos               = vm.isLoading
      }, function (err) {
        vm.isLoadingActivos = vm.isLoading
        notify(vm, 'error', 'Error', err.message)
      }, function () {
        vm.isLoadingActivos = false
      })
    },
    obtenerListaCorrespondencia() {
      // console.log('obtenerListaCorrespondencia')
      var vm                      = this
      vm.listaCorrespondencia     = []
      vm.isLoadingCorrespondencia = true
      var obj = {
        idestado : 2,
        idempresa: vm.itemEmpresaSeleccionado.idempresa
      }
      // console.log('obj:>>> ', obj)
      dashboardListaCorrespondencia(obj).then(data => {
        // console.log('data correspondencia:>>> ', data)
        for (let i = 0; i < data.lista.length; i++) {
          vm.listaCorrespondencia.push(data.lista[i])
        }
        vm.cantidadCorrespondencia                = data.cantidad
        vm.lineChartData.correspondencia.cantidad = data.cantidad
        vm.isLoadingCorrespondencia               = vm.isLoading
      }, function (err) {
        vm.isLoadingCorrespondencia = vm.isLoading
        notify(vm, 'error', 'Error', err.message)
      }, function () {
        vm.isLoadingCorrespondencia = false
      })
    },
    obtenerListaIncidencias() {
      // console.log('obtenerListaIncidencias')
      var vm                  = this
      vm.listaIncidencias     = []
      vm.isLoadingIncidencias = true
      var obj = {
        idestado : 2,
        idempresa: vm.itemEmpresaSeleccionado.idempresa
      }
      // console.log('obj:>>> ', obj)
      dashboardListaIncidencias(obj).then(data => {
        // console.log('data incidencias:>>> ', data)
        for (let i = 0; i < data.lista.length; i++) {
          vm.listaIncidencias.push(data.lista[i])
        }
        vm.cantidadIncidencias                = data.cantidad
        vm.lineChartData.incidencias.cantidad = data.cantidad
        vm.isLoadingIncidencias               = vm.isLoading
      }, function (err) {
        vm.isLoadingIncidencias = vm.isLoading
        notify(vm, 'error', 'Error', err.message)
      }, function () {
        vm.isLoadingIncidencias = false
      })
    }
  }
}
</script>

<style lang="scss" scoped>
  .emptyGif {
    display: block;
    width  : 45%;
    margin : 0 auto;
  }

  .dashboard-vigilante-container {
    background-color: #e3e3e3;
    min-height      : 88vh;
    padding         : 20px 20px 0px;
    /*padding: 50px 60px 0px;*/
    .pan-info-roles {
      font-size  : 12px;
      font-weight: 700;
      color      : #333;
      display    : block;
    }
    .info-container {
      position   : relative;
      margin-left: 190px;
      height     : 150px;
      line-height: 200px;
      .display_name {
        font-size  : 48px;
        line-height: 48px;
        color      : #212121;
        position   : absolute;
        top        : 25px;
      }
    }
  }
.dashboard-vigilante-container {
  padding         : 20px;
  background-color: rgb(240, 242, 245);
  position        : relative;

  .github-corner {
    position: absolute;
    top     : 0px;
    border  : 0;
    right   : 0;
  }

  .chart-wrapper {
    background   : #fff;
    padding      : 16px 16px 0;
    margin-bottom: 20px;
    // margin-bottom: 32px;
  }
}

@media (max-width:1024px) {
  .chart-wrapper {
    padding: 8px;
  }
}

.boton-floating-actualizar {
  background-color: #23d160;
  // position        : absolute;
  z-index         : 8000;
  bottom          : 20px;
  right           : 25px;
  border-radius   : 30px;
  color           : #fff;
  font-size       : 20px;
  box-shadow      : 1px 1px 12px 1px rgba(45,66,88,0.439);
  width           : 55px;
  height          : 55px;
  display         : flex;
  align-items     : center;
  justify-content : center;
  position        : fixed;
}
.boton-floating-actualizar:hover {
  background-color: #fff;
  color           : #23d160;
}
</style>
