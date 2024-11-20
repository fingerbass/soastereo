<template>
  <div class="dashboard-editor-container">
    <!-- Panel Superior con KPIs -->
    <el-row :gutter="40" class="panel-group">
      <el-col :xs="12" :sm="12" :lg="6" class="card-panel-col">
        <div class="card-panel">
          <div class="card-panel-icon-wrapper icon-events">
            <i class="el-icon-date card-panel-icon" />
          </div>
          <div class="card-panel-description">
            <div class="card-panel-text">Total Eventos</div>
            <count-to :start-val="0" :end-val="kpis.total_eventos" :duration="2600" class="card-panel-num" />
          </div>
        </div>
      </el-col>
      <el-col :xs="12" :sm="12" :lg="6" class="card-panel-col">
        <div class="card-panel">
          <div class="card-panel-icon-wrapper icon-pending">
            <i class="el-icon-time card-panel-icon" />
          </div>
          <div class="card-panel-description">
            <div class="card-panel-text">Eventos Pendientes</div>
            <count-to :start-val="0" :end-val="kpis.eventos_pendientes" :duration="3000" class="card-panel-num" />
          </div>
        </div>
      </el-col>
      <el-col :xs="12" :sm="12" :lg="6" class="card-panel-col">
        <div class="card-panel">
          <div class="card-panel-icon-wrapper icon-costs">
            <i class="el-icon-money card-panel-icon" />
          </div>
          <div class="card-panel-description">
            <div class="card-panel-text">Costos Totales</div>
            <div class="card-panel-num">S/ {{ formatNumber(kpis.costos_totales) }}</div>
          </div>
        </div>
      </el-col>
      <el-col :xs="12" :sm="12" :lg="6" class="card-panel-col">
        <div class="card-panel">
          <div class="card-panel-icon-wrapper icon-month">
            <i class="el-icon-data-analysis card-panel-icon" />
          </div>
          <div class="card-panel-description">
            <div class="card-panel-text">Eventos del Mes</div>
            <count-to :start-val="0" :end-val="kpis.eventos_mes_actual" :duration="3600" class="card-panel-num" />
          </div>
        </div>
      </el-col>
    </el-row>

    <!-- Gráfico de Tendencias -->
    <el-row style="background:#fff;padding:16px 16px 0;margin-bottom:32px;">
      <el-card>
        <div slot="header" class="clearfix">
          <span>Tendencia de Eventos</span>
        </div>
        <line-chart :chart-data="lineChartData" />
      </el-card>
    </el-row>

    <!-- Gráficos de Análisis -->
    <el-row :gutter="32">
      <el-col :xs="24" :sm="24" :lg="8">
        <div class="chart-wrapper">
          <el-card>
            <div slot="header" class="clearfix">
              <span>Distribución por Estados</span>
            </div>
            <raddar-chart height="300px" />
          </el-card>
        </div>
      </el-col>
      <el-col :xs="24" :sm="24" :lg="8">
        <div class="chart-wrapper">
          <el-card>
            <div slot="header" class="clearfix">
              <span>Tipos de Eventos</span>
            </div>
            <pie-chart height="300px" />
          </el-card>
        </div>
      </el-col>
      <el-col :xs="24" :sm="24" :lg="8">
        <div class="chart-wrapper">
          <el-card>
            <div slot="header" class="clearfix">
              <span>Costos Mensuales</span>
            </div>
            <bar-chart height="300px" />
          </el-card>
        </div>
      </el-col>
    </el-row>

    <!-- Tabla de Eventos Recientes -->
    <el-row :gutter="32" style="margin-top: 20px;">
      <el-col :xs="24" :sm="24" :lg="24">
        <el-card>
          <div slot="header" class="clearfix">
            <span>Eventos Recientes</span>
          </div>
          <el-table v-loading="loading" :data="eventosRecientes" style="width: 100%">
            <el-table-column prop="nombre" label="Nombre" min-width="200" />
            <el-table-column prop="fecha_formato" label="Fecha" width="120" align="center" />
            <el-table-column prop="lugar" label="Lugar" min-width="150" />
            <el-table-column prop="estado" label="Estado" width="120" align="center">
              <template slot-scope="{row}">
                <el-tag :type="getEstadoTag(row.estado)">{{ row.estado }}</el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="costo_total" label="Costo" width="120" align="right">
              <template slot-scope="{row}">
                S/ {{ formatNumber(row.costo_total) }}
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import CountTo from 'vue-count-to'
import LineChart from './components/LineChart'
import RaddarChart from './components/RaddarChart'
import PieChart from './components/PieChart'
import BarChart from './components/BarChart'
import {
  getDashboardKpis,
  getDashboardTendencia,
  getDashboardRadar,
  getDashboardDistribucion,
  getDashboardCostos
} from '@/api/dashboard'

export default {
  name: 'Dashboard',
  components: {
    CountTo,
    LineChart,
    RaddarChart,
    PieChart,
    BarChart
  },
  data() {
    return {
      loading: false,
      kpis: {
        total_eventos: 0,
        eventos_pendientes: 0,
        costos_totales: 0,
        eventos_mes_actual: 0
      },
      lineChartData: {
        expectedData: [],
        actualData: []
      },
      radarData: [],
      pieData: [],
      barData: [],
      eventosRecientes: []
    }
  },
  created() {
    this.fetchData()
  },
  methods: {
    async fetchData() {
      this.loading = true
      try {
        const [kpis, tendencia, radar, distribucion, costos] = await Promise.all([
          getDashboardKpis(),
          getDashboardTendencia(),
          getDashboardRadar(),
          getDashboardDistribucion(),
          getDashboardCostos()
        ])

        if (kpis.status === 1) {
          this.kpis = kpis.lista
        }

        this.setChartData(
          tendencia.status === 1 ? tendencia.lista : [],
          radar.status === 1 ? radar.lista : [],
          distribucion.status === 1 ? distribucion.lista : [],
          costos.status === 1 ? costos.lista : []
        )
      } catch (error) {
        console.error('Error cargando datos:', error)
        this.$notify.error({
          title: 'Error',
          message: 'Error al cargar los datos del dashboard'
        })
      } finally {
        this.loading = false
      }
    },
    setChartData(tendencia, radar, distribucion, costos) {
      // Datos para el gráfico de línea
      this.lineChartData = {
        expectedData: tendencia.map(item => item.eventos_proyectados),
        actualData: tendencia.map(item => item.eventos_realizados)
      }

      // Datos para el radar
      this.radarData = radar.estados.map(item => ({
        value: item.cantidad,
        name: item.estado
      }))

      // Datos para el pie
      this.pieData = distribucion.estados.map(item => ({
        value: item.cantidad,
        name: item.estado
      }))

      // Datos para el bar
      this.barData = costos.map(item => ({
        mes: this.getMesNombre(item.mes),
        monto: item.costo_total
      }))

      // Tomar los últimos 5 eventos para la tabla
      this.eventosRecientes = tendencia.slice(0, 5)
    },
    getMesNombre(mes) {
      const meses = [
        'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
        'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
      ]
      return meses[mes - 1]
    },
    formatNumber(num) {
      return num ? num.toLocaleString('es-PE', {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2
      }) : '0.00'
    },
    getEstadoTag(estado) {
      const tags = {
        'Pendiente': 'warning',
        'En Proceso': 'primary',
        'Completado': 'success',
        'Cancelado': 'danger'
      }
      return tags[estado] || 'info'
    }
  }
}
</script>

<style lang="scss" scoped>
.dashboard-editor-container {
  padding: 20px;
  background-color: rgb(240, 242, 245);

  .panel-group {
    margin-top: 18px;

    .card-panel-col {
      margin-bottom: 32px;
    }

    .card-panel {
      height: 108px;
      cursor: pointer;
      font-size: 12px;
      position: relative;
      overflow: hidden;
      color: #666;
      background: #fff;
      box-shadow: 4px 4px 40px rgba(0, 0, 0, .05);
      border-color: rgba(0, 0, 0, .05);

      &:hover {
        .card-panel-icon-wrapper {
          color: #fff;
        }
        .icon-events { background: #40c9c6; }
        .icon-pending { background: #36a3f7; }
        .icon-costs { background: #f4516c; }
        .icon-month { background: #34bfa3; }
      }

      .card-panel-icon-wrapper {
        float: left;
        margin: 14px 0 0 14px;
        padding: 16px;
        transition: all 0.38s ease-out;
        border-radius: 6px;
      }

      .card-panel-icon {
        float: left;
        font-size: 48px;
      }

      .card-panel-description {
        float: right;
        font-weight: bold;
        margin: 26px;
        margin-left: 0;

        .card-panel-text {
          line-height: 18px;
          color: rgba(0, 0, 0, 0.45);
          font-size: 16px;
          margin-bottom: 12px;
        }

        .card-panel-num {
          font-size: 20px;
        }
      }
    }

    .icon-events { color: #40c9c6; }
    .icon-pending { color: #36a3f7; }
    .icon-costs { color: #f4516c; }
    .icon-month { color: #34bfa3; }
  }

  .chart-wrapper {
    margin-bottom: 32px;
  }
}
</style>
