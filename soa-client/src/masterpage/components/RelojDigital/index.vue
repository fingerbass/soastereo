<template>
  <div class="reloj-digital">
    {{ hora }}
  </div>
</template>

<script>
export default {
  data() {
    return {
      sizeOptions: [
        { label: 'Por defecto', value: 'default' },
        { label: 'Medio', value: 'medium' },
        { label: 'Pequeño', value: 'small' },
        { label: 'Mini', value: 'mini' }
      ],
      horas   : 0,
      minutos : 0,
      segundos: 0,
      hora    : ''
    }
  },
  computed: {
    size() {
      return this.$store.getters.size
    }
  },
  created() {
  },
  mounted() {
    var vm = this
    setInterval(() => vm.setTiempo(), 1000)
  },
  methods: {
    setTiempo() {
      var vm = this
      const date      = new Date()
      let   horas     = date.getHours()
      let   minutos   = date.getMinutes()
      let   segundos  = date.getSeconds()
      horas           = horas <= 9 ? `${horas}`.padStart(2, 0) : horas
      minutos         = minutos <= 9 ? `${minutos}`.padStart(2, 0) : minutos
      segundos        = segundos <= 9 ? `${segundos}`.padStart(2, 0) : segundos
      this.horas      = horas
      this.minutos    = minutos
      this.segundos   = segundos
      vm.hora         = `${horas}:${minutos}:${segundos}`
    }
  }
}
</script>

<style lang="scss" scoped>
@import "~@/styles/variables.scss";
.change-theme {
  @if $navbarColor == #000000 {
    fill: #ffffff !important;
  } @else {
    fill: #000000 !important;
  }
}
.reloj-digital {
  font-size  : 12px !important;
  font-weight: 700 !important;
}
</style>
