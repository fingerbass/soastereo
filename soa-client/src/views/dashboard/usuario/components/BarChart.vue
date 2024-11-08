<template>
  <div v-loading="cargandoInformacion" :class="className" :style="{height:height,width:width}" />
</template>

<script>
import { dashboardListaActivos }  from '@/api/dashboard'
import { notify }                 from '@/utils/general.js'
import echarts from 'echarts'
require('echarts/theme/macarons') // echarts theme
import resize from './mixins/resize'

const animationDuration = 6000

export default {
  mixins: [resize],
  props: {
    className: {
      type: String,
      default: 'chart'
    },
    width: {
      type: String,
      default: '100%'
    },
    height: {
      type: String,
      default: '300px'
    }
  },
  data() {
    return {
      cargandoInformacion: false,
      listaActivos       : [],
      objAux             : {},
      chart              : null
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
      // console.log('obtenerListaActivos')
      var vm                = this
      vm.listaActivos       = []
      vm.cargandoInformacion   = true
      var obj = {
        idestado: 2
      }
      // console.log('obj:>>> ', obj)
      dashboardListaActivos(obj).then(data => {
        console.log('data activos:>>> ', data)
        for (let i = 0; i < data.lista.length; i++) {
          vm.listaActivos.push(data.lista[i])
        }
        this.$nextTick(() => {
          this.initChart()
        })
        vm.cargandoInformacion = vm.isLoading
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
          text   : 'Activos',
          // subtext: 'Fake Data',
          left   : 'left'
        },
        tooltip: {
          trigger    : 'axis',
          axisPointer: { // Indicador de eje, el disparador de eje es válido
            type: 'shadow' // El valor predeterminado es línea recta, opcional es：'line' | 'shadow'
          }
        },
        grid: {
          top         : 40,
          left        : '2%',
          right       : '2%',
          bottom      : '3%',
          containLabel: true
        },
        xAxis: [{
          type    : 'category',
          data    : ['Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sabado', 'Domingo'],
          axisTick: {
            alignWithLabel: true
          }
        }],
        yAxis: [{
          type: 'value',
          axisTick: {
            show: false
          }
        }],
        series: [
          {
            name    : 'Item 1',
            type    : 'bar',
            stack   : 'vistors',
            barWidth: '60%',
            data    : [79, 52, 200, 334, 390, 330, 220],
            animationDuration
          },
          {
            name    : 'Item 2',
            type    : 'bar',
            stack   : 'vistors',
            barWidth: '60%',
            data    : [80, 52, 200, 334, 390, 330, 220],
            animationDuration
          },
          {
            name    : 'Item 3',
            type    : 'bar',
            stack   : 'vistors',
            barWidth: '60%',
            data    : [30, 52, 200, 334, 398, 330, 220],
            animationDuration
          }
        ]
      })
    }
  }
}
</script>
