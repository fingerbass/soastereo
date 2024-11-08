<template>
  <div class="dashboard-container">
    <component :is="currentRole" />
  </div>
</template>

<script>
import { mapGetters }         from 'vuex'
import administradorDashboard from './administrador'
import usuarioDashboard       from './usuario'

export default {
  name: 'Dashboard',
  components: { administradorDashboard, usuarioDashboard },
  data() {
    return {
      itemEmpresaSeleccionado : null,
      itemServicioSeleccionado: null,
      currentRole             : ''
    }
  },
  computed: {
    ...mapGetters([
      'roles'
    ])
  },
  created() {
    // console.log('this.roles:>>>', this.roles)
    // var vm = this
    // vm.itemEmpresaSeleccionado = JSON.parse(localStorage.getItem('itemEmpresaSeleccionado'))
    // // console.log('vm.itemEmpresaSeleccionado', vm.itemEmpresaSeleccionado)
    // vm.itemServicioSeleccionado = JSON.parse(localStorage.getItem('itemServicioSeleccionado'))
    // // console.log('vm.itemServicioSeleccionado', vm.itemServicioSeleccionado)

    if (!this.roles.includes('ADMINISTRADOR')) {
      this.currentRole = 'usuarioDashboard'
    } else {
      this.currentRole = 'administradorDashboard'
    }
  },
  mounted() {
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
  methods: {
  }
}
</script>
