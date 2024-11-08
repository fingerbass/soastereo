<template>
  <div v-loading="cargandoInformacion" :class="className" :style="{height:height,width:width}" />
</template>

<script>
import { dashboardListaPersonas } from '@/api/dashboard'
import { notify }                 from '@/utils/general.js'
import moment                     from 'moment'
import _                          from 'lodash'
import echarts                    from 'echarts'
require('echarts/theme/macarons') // echarts theme
import resize                     from './mixins/resize'

export default {
  mixins: [resize],
  props: {
    className: {
      type   : String,
      default: 'chart'
    },
    width: {
      type   : String,
      default: '100%'
    },
    height: {
      type   : String,
      default: '300px'
    },
    lineChartData: {
      type    : Object,
      required: false,
      default() {
        return {}
      }
    }
  },
  data() {
    return {
      cargandoInformacion    : false,
      objAux                 : {},
      listaPersonas          : [],
      chart                  : null,
      administrador          : JSON.parse(localStorage.getItem('administrador')),
      itemEmpresaSeleccionado: JSON.parse(localStorage.getItem('itemEmpresaSeleccionado'))
    }
  },
  mounted() {
    this.$nextTick(() => {
      // this.initChart()
      this.fetch()
    })
  },
  beforeDestroy() {
    if (!this.chart) {
      return
    }
    this.chart.dispose()
    this.chart = null
  },
  methods: {
    fetch() {
      // console.log('obtenerListaPersonas')
      var vm                = this
      vm.listaPersonas      = []
      vm.cargandoInformacion  = true
      var obj = {
        idestado: 2,
        idempresa: vm.itemEmpresaSeleccionado.idempresa
      }
      // console.log('obj:>>> ', obj)
      dashboardListaPersonas(obj).then(data => {
        console.log('data personas:>>> ', data)
        for (let i = 0; i < data.lista.length; i++) {
          data.lista[i].ingreso_hora_formateada = moment(data.lista[i].ingreso_hora).format('YYYY-MM-DD')
          data.lista[i].salida_hora_formateada  = moment(data.lista[i].salida_hora).format('YYYY-MM-DD')
          // vm.listaPersonas.push(data.lista[i])
        }
        var arreglouno           = _.filter(data.lista, function(o) { return o.ingreso_hora_formateada !== '1900-01-01' && o.salida_hora_formateada === '1900-01-01' })
        var cantidaduno          = arreglouno.length
        var arreglodos           = _.filter(data.lista, function(o) { return o.ingreso_hora_formateada !== '1900-01-01' && o.salida_hora_formateada !== '1900-01-01' })
        var cantidaddos          = arreglodos.length
        vm.cargandoInformacion     = vm.isLoading
        vm.objAux                   = {
          cantidaduno: cantidaduno,
          cantidaddos: cantidaddos
        }
        console.log('vm.objAux:>>> ', vm.objAux)
        this.$nextTick(() => {
          this.initChart()
        })
      }, function (err) {
        vm.cargandoInformacion = vm.isLoading
        notify(vm, 'error', 'Error', err.message)
      }, function () {
        vm.cargandoInformacion = false
      })
    },
    initChart() {
      this.chart = echarts.init(this.$el, 'macarons')

      this.chart.setOption({
        title: {
          text   : 'Ingreso/Salida',
          // subtext: 'Fake Data',
          left   : 'left'
        },
        tooltip: {
          trigger  : 'item',
          formatter: '{a} <br/>{b} : {c} ({d}%)'
        },
        legend: {
          left  : 'center',
          bottom: '10',
          // data  : ['Industries', 'Technology', 'Forex', 'Gold', 'Forecasts']
          data  : ['Por Salir', 'Salidos']
        },
        series: [
          {
            name    : 'Ingreso / Salida',
            type    : 'pie',
            roseType: 'radius',
            radius  : [15, 95],
            center  : ['50%', '38%'],
            data    : [
              { value: this.objAux.cantidaduno, name: 'Por Salir' },
              { value: this.objAux.cantidaddos, name: 'Salidos' }
              // { value: 320, name: 'Industries' },
              // { value: 240, name: 'Technology' },
              // { value: 149, name: 'Forex' },
              // { value: 100, name: 'Gold' },
              // { value: 59,  name: 'Forecasts' }
            ],
            animationEasing  : 'cubicInOut',
            animationDuration: 2600
          }
        ]
      })
    }
  }
}
</script>
