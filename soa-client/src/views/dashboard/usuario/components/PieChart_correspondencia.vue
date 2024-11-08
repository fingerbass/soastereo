<template>
  <div v-loading="cargandoInformacion" :class="className" :style="{height:height,width:width}" />
</template>

<script>
import { dashboardListaCorrespondencia } from '@/api/dashboard'
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
      listaCorrespondencia   : [],
      objAux                 : {},
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
      // console.log('obtenerListaCorrespondencia')
      var vm                  = this
      vm.listaCorrespondencia = []
      vm.cargandoInformacion  = true
      var obj = {
        idestado : 2,
        idempresa: vm.itemEmpresaSeleccionado.idempresa
      }
      // console.log('obj:>>> ', obj)
      dashboardListaCorrespondencia(obj).then(data => {
        console.log('data correspondencia:>>> ', data)
        for (let i = 0; i < data.lista.length; i++) {
          data.lista[i].recepcion_fecha_formateada = moment(data.lista[i].recepcion_fecha).format('YYYY-MM-DD')
          data.lista[i].entrega_fecha_formateada   = moment(data.lista[i].entrega_fecha).format('YYYY-MM-DD')
          // vm.listaCorrespondencia.push(data.lista[i])
        }
        var arreglouno           = _.filter(data.lista, function(o) { return o.recepcion_fecha_formateada !== '1900-01-01' && o.entrega_fecha_formateada === '1900-01-01' })
        var cantidaduno          = arreglouno.length
        var arreglodos           = _.filter(data.lista, function(o) { return o.recepcion_fecha_formateada !== '1900-01-01' && o.entrega_fecha_formateada !== '1900-01-01' })
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
      this.chart = echarts.init(this.$el, 'shine')

      this.chart.setOption({
        title: {
          text   : 'Correspondencia',
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
          data  : ['Por Entregar', 'Entregados']
        },
        series: [
          {
            name    : 'Correspondencia',
            type    : 'pie',
            roseType: 'radius',
            radius  : [15, 95],
            center  : ['50%', '38%'],
            data    : [
              { value: this.objAux.cantidaduno, name: 'Por Entregar' },
              { value: this.objAux.cantidaddos, name: 'Entregados' }
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
