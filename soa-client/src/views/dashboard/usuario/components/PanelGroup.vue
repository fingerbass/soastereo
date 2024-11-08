<template>
  <el-row :gutter="20" class="panel-group">
    <el-col :xs="24" :sm="24" :md="6" :lg="6" :xl="6" class="card-panel-col">
      <div v-loading="lineChartData.personas.cantidad >= 0 ? false : true" class="card-panel" @click="handleSetLineChartData('personas')">
        <div class="card-panel-icon-wrapper icon-people">
          <svg-icon icon-class="peoples" class-name="card-panel-icon" />
        </div>
        <div class="card-panel-description">
          <div class="card-panel-text">
            Ingreso/Salida
          </div>
          <count-to :start-val="0" :end-val="lineChartData.personas.cantidad" :duration="2600" class="card-panel-num" />
        </div>
      </div>
    </el-col>
    <el-col :xs="24" :sm="24" :md="6" :lg="6" :xl="6" class="card-panel-col">
      <div v-loading="lineChartData.activos.cantidad >= 0 ? false : true" class="card-panel" @click="handleSetLineChartData('activos')">
        <div class="card-panel-icon-wrapper icon-message">
          <svg-icon icon-class="tab" class-name="card-panel-icon" />
          <!-- <i class="el-icon-delete-solid" class-name="card-panel-icon"></i> -->
        </div>
        <div class="card-panel-description">
          <div class="card-panel-text">
            Activos
          </div>
          <count-to :start-val="0" :end-val="lineChartData.activos.cantidad" :duration="3000" class="card-panel-num" />
        </div>
      </div>
    </el-col>
    <el-col :xs="24" :sm="24" :md="6" :lg="6" :xl="6" class="card-panel-col">
      <div v-loading="lineChartData.correspondencia.cantidad >= 0 ? false : true" class="card-panel" @click="handleSetLineChartData('correspondencia')">
        <div class="card-panel-icon-wrapper icon-shopping">
          <svg-icon icon-class="documentation" class-name="card-panel-icon" />
        </div>
        <div class="card-panel-description">
          <div class="card-panel-text">
            Correspondencia
          </div>
          <count-to :start-val="0" :end-val="lineChartData.correspondencia.cantidad" :duration="3600" class="card-panel-num" />
        </div>
      </div>
    </el-col>
    <el-col :xs="24" :sm="24" :md="6" :lg="6" :xl="6" class="card-panel-col">
      <div v-loading="lineChartData.incidencias.cantidad >= 0 ? false : true" class="card-panel" @click="handleSetLineChartData('incidencias')">
        <div class="card-panel-icon-wrapper icon-money">
          <svg-icon icon-class="form" class-name="card-panel-icon" />
        </div>
        <div class="card-panel-description">
          <div class="card-panel-text">
            Incidencias
          </div>
          <count-to :start-val="0" :end-val="lineChartData.incidencias.cantidad" :duration="3200" class="card-panel-num" />
        </div>
      </div>
    </el-col>
  </el-row>
</template>

<script>
import CountTo from 'vue-count-to'

export default {
  components: {
    CountTo
  },
  props: {
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
    }
  },
  created() {
    var vm = this
    console.log('lineChartData:>>> ', vm.lineChartData)
  },
  methods: {
    handleSetLineChartData(type) {
      this.$emit('handleSetLineChartData', type)
    }
  }
}
</script>

<style lang="scss" scoped>
.panel-group {
  // margin-top: 20px;
  // margin-top: 18px;

  .card-panel-col {
    margin-bottom: 20px;
    // margin-bottom: 32px;
  }

  .card-panel {
    height      : 108px;
    cursor      : pointer;
    font-size   : 12px;
    position    : relative;
    overflow    : hidden;
    color       : #666;
    background  : #fff;
    box-shadow  : 4px 4px 40px rgba(0, 0, 0, .05);
    border-color: rgba(0, 0, 0, .05);

    &:hover {
      .card-panel-icon-wrapper {
        color: #fff;
      }

      .icon-people {
        background: #40c9c6;
      }

      .icon-message {
        background: #36a3f7;
      }

      .icon-money {
        background: #f4516c;
      }

      .icon-shopping {
        background: #34bfa3
      }
    }

    .icon-people {
      color: #40c9c6;
    }

    .icon-message {
      color: #36a3f7;
    }

    .icon-money {
      color: #f4516c;
    }

    .icon-shopping {
      color: #34bfa3
    }

    .card-panel-icon-wrapper {
      float        : left;
      margin       : 14px 0 0 14px;
      padding      : 16px;
      transition   : all 0.38s ease-out;
      border-radius: 6px;
    }

    .card-panel-icon {
      float    : left;
      font-size: 48px;
    }

    .card-panel-description {
      float      : right;
      font-weight: bold;
      margin     : 26px;
      margin-left: 0px;
      text-align : right;

      .card-panel-text {
        line-height  : 18px;
        color        : rgba(0, 0, 0, 0.45);
        font-size    : 16px;
        margin-bottom: 12px;
      }

      .card-panel-num {
        font-size: 20px;
      }
    }
  }
}

// SI ES MOVIL
// @media (max-width:550px) {
//   .card-panel-description {
//     display: none;
//   }

//   .card-panel-icon-wrapper {
//     float: none !important;
//     width: 100%;
//     height: 100%;
//     margin: 0 !important;

//     .svg-icon {
//       display: block;
//       margin: 14px auto !important;
//       float: none !important;
//     }
//   }
// }
</style>
