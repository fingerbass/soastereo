<template>
  <div class="navbar">

    <LoginContrasenaCambiar v-if="showModalContraseñaCambiar" :modal="modal" :proviniente="2" @close="closeModalCambiarContraseña()" />

    <hamburger id="hamburger-container" :is-active="sidebar.opened" class="hamburger-container" @toggleClick="toggleSideBar" />

    <span class="pointer class" style="color: #FFFFFF" @click="redirectToHome()">
      SOASTEREO
    </span>

    <!-- <span class="class2 img-container4">
      {{ objitemEmpresaSeleccionado.empresa }}
    </span> -->
    <div v-if="!administrador && !isMovil" class="class2 img-container4 pre-formatted">
      <div v-for="(item, index) in texto" :key="index">{{ item }}</div>
    </div>
    <!-- <div v-if="!isMovil" class="class2 img-container4">
      {{ objitemEmpresaSeleccionado.empresa }}
      {{ objitemSedeSeleccionado.nombre }}
    </div> -->

    <!-- <breadcrumb id="breadcrumb-container" class="breadcrumb-container" /> -->
    <!--
    <router-link to="/">
      <img v-if="itemEmpresaSeleccionado && itemEmpresaSeleccionado.logo" :src="itemEmpresaSeleccionado.logo" class="sidebar-logo img-container2" loading="lazy">
    </router-link>

    <router-link to="/">
      <img v-if="itemServicioSeleccionado && itemServicioSeleccionado.logo" :src="itemServicioSeleccionado.logo" class="sidebar-logo img-container3" loading="lazy">
    </router-link> -->

    <!-- <h6 class="change-theme">({{ itemEmpresaSeleccionado }} - {{ itemServicioSeleccionado }})</h6> -->

    <div class="right-menu">
      <template v-if="device !== 'mobile'">
        <reloj id="header-search" class="right-menu-item change-theme" />

        <search id="header-search" class="right-menu-item change-theme" />

        <error-log class="errLog-container right-menu-item hover-effect" />

        <screenfull id="screenfull" class="right-menu-item hover-effect" />

        <el-tooltip content="Tamaño Global" effect="dark" placement="bottom">
          <size-select id="size-select" class="right-menu-item hover-effect" />
        </el-tooltip>

      </template>

      <el-dropdown class="avatar-container right-menu-item hover-effect" trigger="click">
        <div class="avatar-wrapper">
          <img :src="avatar" class="user-avatar" loading="lazy">
          <i class="el-icon-caret-bottom change-theme" />
        </div>
        <el-dropdown-menu slot="dropdown">
          <el-dropdown-item @click.native="redirectToHome()">
            <span style="display:block;">Inicio</span>
          </el-dropdown-item>
          <!-- <router-link to="/">
            <el-dropdown-item>Inicio</el-dropdown-item>
          </router-link> -->
          <router-link to="/profile/index">
            <el-dropdown-item>Perfil</el-dropdown-item>
          </router-link>
          <el-dropdown-item divided @click.native="openModalRestablecerContraseña()">
            <span style="display:block;">Cambiar Contraseña</span>
          </el-dropdown-item>
          <router-link :to="{ path: '/dashboard'}">
            <el-dropdown-item>Dashboard</el-dropdown-item>
          </router-link>
          <!-- <a target="_blank" href="https://panjiachen.github.io/vue-element-admin-site/#/">
            <el-dropdown-item>Documentación</el-dropdown-item>
          </a> -->
          <el-dropdown-item divided @click.native="logout">
            <span style="display:block;">Salir</span>
          </el-dropdown-item>
        </el-dropdown-menu>
      </el-dropdown>
    </div>
  </div>
</template>

<script>
import LoginContrasenaCambiar from '@/views/login/login_contrasena_cambiar.vue'
import { mapGetters }         from 'vuex'
// import Breadcrumb             from './Breadcrumb'
import Hamburger              from './Hamburger'
import ErrorLog               from './ErrorLog'
import Screenfull             from './Screenfull'
import SizeSelect             from './SizeSelect'
import Search                 from './HeaderSearch'
import Reloj                  from './RelojDigital'
import variables              from '@/styles/variables.scss'
// import _                      from 'lodash'

export default {
  // props: {
  //   to  : { type: Object, required: true },
  //   name: { type: String, required: true }
  // },
  components: {
    // Breadcrumb,
    Hamburger,
    ErrorLog,
    Screenfull,
    SizeSelect,
    Search,
    Reloj,
    'LoginContrasenaCambiar': LoginContrasenaCambiar
  },
  data() {
    return {
      title                     : 'soa',
      logo                      : require('@/assets/lib_imagenes/logo_soa.svg'),
      empresas                  : null,
      servicios                 : null,
      itemEmpresaSeleccionado   : null,
      itemServicioSeleccionado  : null,
      itemSedeSeleccionado      : null,
      itemPuestoSeleccionado    : null,
      showModalContraseñaCambiar: false,
      centerDialogVisible       : true,
      cargandoInformacion       : false,
      modal                     : false,
      administrador             : JSON.parse(localStorage.getItem('administrador')),
      objitemEmpresaSeleccionado: '',
      objitemSedeSeleccionado   : '',
      window                    : { width : 0, height: 0 },
      minWidthMedia             : 700,
      minHeightMedia            : 550,
      isMovil                   : null,
      context                   : null,
      someSound                 : '@/assets/lib_notificacion/notificacion.mp3',
      myTimeout                 : '',
      texto                     : []
    }
  },
  computed: {
    ...mapGetters([
      'sidebar',
      'avatar',
      'device'
    ])
  },
  watch : {
    isMovil : function (newValue, oldValue) {
      if (oldValue !== null) window.location.reload()
    }
  },
  created() {
    var vm = this
    // console.log('device: ', this.device)
    this.objitemEmpresaSeleccionado = !this.administrador ? JSON.parse(localStorage.getItem('itemEmpresaSeleccionado')) : ''
    this.objitemSedeSeleccionado    = !this.administrador ? JSON.parse(localStorage.getItem('itemSedeSeleccionado')) : ''
    // console.log('this.objitemEmpresaSeleccionado', this.objitemEmpresaSeleccionado)
    // console.log('this.objitemSedeSeleccionado', this.objitemSedeSeleccionado)
    if (!this.administrador) {
      if (this.objitemEmpresaSeleccionado && this.objitemSedeSeleccionado) {
        vm.texto = [
          this.objitemEmpresaSeleccionado.empresa,
          this.objitemSedeSeleccionado.nombre
        ]
      }
    }
    // console.log(vm.texto)
    // vm.texto = `${this.objitemEmpresaSeleccionado.empresa} \n\n ${this.objitemSedeSeleccionado.nombre}`
    // console.log('objitemEmpresaSeleccionado: ', this.objitemEmpresaSeleccionado)
    // console.log('avatar: ', this.avatar)
    // var vm = this
    // vm.empresas = JSON.parse(localStorage.getItem('empresas'))
    // // console.log('vm.empresas', vm.empresas)
    // vm.servicios = JSON.parse(localStorage.getItem('servicios'))
    // // console.log('vm.servicios', vm.servicios)
    // if (!localStorage.getItem('itemEmpresaSeleccionado')) vm.itemEmpresaSeleccionado = JSON.parse(localStorage.getItem('itemEmpresaSeleccionado'))
    // // console.log('vm.itemEmpresaSeleccionado', vm.itemEmpresaSeleccionado)
    // if (!localStorage.getItem('itemServicioSeleccionado')) vm.itemServicioSeleccionado = JSON.parse(localStorage.getItem('itemServicioSeleccionado'))
    // // console.log('vm.itemServicioSeleccionado', vm.itemServicioSeleccionado)

    // const filter = _.filter(vm.empresas, function(o) { return o.id !== vm.itemEmpresaSeleccionado.id })
    // console.log('filter: ', filter)
    // const resultado = vm.empresas.filter(o => o.id !== vm.itemEmpresaSeleccionado.id)
    // console.log('resultado', resultado)
    // var arregloAux = resultado.push(vm.itemEmpresaSeleccionado)
    // console.log('arregloAux', arregloAux)
    window.addEventListener('resize', vm.handleResize)
    vm.handleResize()
  },
  mounted() {
    // var vm = this
    // const administrador = JSON.parse(localStorage.getItem('ADMINISTRADOR'))
    // if (!administrador) {
    //   if (vm.itemEmpresaSeleccionado === null && vm.itemServicioSeleccionado === null) {
    //     vm.$router.push({ path: '/' })
    //   }
    // }
    var vm = this
    vm.itemEmpresaSeleccionado  = JSON.parse(localStorage.getItem('itemEmpresaSeleccionado'))
    // console.log('vm.itemEmpresaSeleccionado', vm.itemEmpresaSeleccionado)
    vm.itemServicioSeleccionado = JSON.parse(localStorage.getItem('itemServicioSeleccionado'))
    // console.log('vm.itemServicioSeleccionado', vm.itemServicioSeleccionado)
    // vm.itemSedeSeleccionado     = JSON.parse(localStorage.getItem('itemSedeSeleccionado'))
    // // console.log('vm.itemSedeSeleccionado', vm.itemSedeSeleccionado)
    // vm.itemPuestoSeleccionado   = JSON.parse(localStorage.getItem('itemPuestoSeleccionado'))
    // // console.log('vm.itemPuestoSeleccionado', vm.itemPuestoSeleccionado)
    const administrador = JSON.parse(localStorage.getItem('administrador'))
    // console.log('administrador', administrador)
    if (!administrador) {
      if (vm.itemEmpresaSeleccionado === null && vm.itemServicioSeleccionado === null) {
        vm.$router.push({ path: '/' })
      }
    } else {
      vm.$router.push({ path: '/dashboard' })
    }
  },
  destroyed () {
    var vm = this
    window.removeEventListener('resize', vm.handleResize)
    clearTimeout(vm.myTimeout)
  },
  methods: {
    handleResize () {
      // console.log('cambio tamaño de la pantalla.. ')
      var  vm                                                     = this
      vm.window.width                                             = window.innerWidth
      vm.window.height                                            = window.innerHeight
      if   (vm.window.width < vm.minWidthMedia)       vm.isMovil  = true
      else if (vm.window.height < vm.minHeightMedia)  vm.isMovil  = true
      else vm.isMovil                                             = false
      localStorage.setItem('isMovil', vm.isMovil)
      // console.log('vm.isMovil.. ', vm.isMovil)
    },
    variables() {
      return variables
    },
    toggleSideBar() {
      this.$store.dispatch('app/toggleSideBar')
    },
    redirectToHome () {
      var vm = this
      var administrador = JSON.parse(localStorage.getItem('administrador'))
      if (administrador) {
        vm.$router.push({ path: '/dashboard' })
      } else {
        var empresaSelected  = JSON.parse(localStorage.getItem('empresas'))
        var servicioSelected = JSON.parse(localStorage.getItem('servicios'))
        if ((empresaSelected && empresaSelected.length === 1) && (servicioSelected && servicioSelected.length === 1)) {
          vm.$router.push({ path: '/dashboard' })
        } else {
          localStorage.setItem('itemEmpresaSeleccionado', null)
          localStorage.setItem('itemEmpresaSeleccionado', null)
          // vm.$router.push({ path: '/' })
          vm.$router.push({ path: '/' })
        }
      }
    },
    openModalRestablecerContraseña() {
      var vm                        = this
      vm.modal                    = true
      vm.showModalContraseñaCambiar = true
    },
    closeModalCambiarContraseña() {
      var vm                        = this
      vm.modal                    = ''
      vm.showModalContraseñaCambiar = false
    },
    async logout() {
      await this.$store.dispatch('user/logout')
      this.$router.push(`/login?redirect=${this.$route.fullPath}`)
    }
    // playNote() {
    //   console.log('calling playNote()')
    //   var note = new Audio(this.someSound)
    //   note.addEventListener('canplaythrough', () => {
    //     console.log('event listener called')
    //     note.play()
    //   })
    // }
  },
  soundNotification () {
  },
  playNote (frequency, startTime, duration) {
    this.context = new AudioContext()
    var osc1    = this.context.createOscillator()
    var osc2    = this.context.createOscillator()
    var volume  = this.context.createGain()
    // Set oscillator wave type
    osc1.type = 'triangle'
    osc2.type = 'triangle'
    volume.gain.value = 0.1
    // Set up node routing
    osc1.connect(volume)
    osc2.connect(volume)
    volume.connect(this.context.destination)
    // Detune oscillators for chorus effect
    osc1.frequency.value = frequency + 1
    osc2.frequency.value = frequency - 2
    // Fade out
    volume.gain.setValueAtTime(0.1, startTime + duration - 0.05)
    volume.gain.linearRampToValueAtTime(0, startTime + duration)
    // Start oscillators
    osc1.start(startTime)
    osc2.start(startTime)
    // Stop oscillators
    osc1.stop(startTime + duration)
    osc2.stop(startTime + duration)
  },
  playSuccessSound () {
    // Play a 'B' now that lasts for 0.116 seconds
    this.playNote(493.883, this.context.currentTime, 0.116)
    // Play an 'E' just as the previous note finishes, that lasts for 0.232 seconds
    this.playNote(659.255, this.context.currentTime + 0.116, 0.232)
  },
  myFakeAjaxCall (callback) {
    setTimeout(function () {
      callback()
    }, 3000)
  }
}
</script>

<style lang="scss" scoped>
@import "~@/styles/variables.scss";
.navbar {
  height    : 50px;
  overflow  : hidden;
  position  : relative;
  background: $navbarColor;
  box-shadow: 0 1px 4px rgba(0,21,41,.08);

  .hamburger-container {
    line-height                : 46px;
    height                     : 100%;
    float                      : left;
    cursor                     : pointer;
    transition                 : background .3s;
    -webkit-tap-highlight-color: transparent;

    &:hover {
      background: rgba(0, 0, 0, .025)
    }
  }

  .img-container {
    float           : left;
    width           : 10rem;
    margin-top      : 0.2rem;
    // margin-bottom   : 0.6rem;
    vertical-align  : middle !important;
    text-align      : center !important;
    background-color: #000000;
    // background-color: #2b2f3a;
  }
  .img-container2 {
    float           : left;
    width           : 7rem;
    margin-top      : 0.2rem;
    // margin-bottom   : 0.6rem;
    vertical-align  : middle !important;
    text-align      : center !important;
    background-color: #000000;
    // background-color: #2b2f3a;
  }
  .img-container3 {
    float           : left;
    width           : 3rem;
    margin-top      : 0.15rem;
    // margin-bottom   : 0.6rem;
    vertical-align  : middle !important;
    text-align      : center !important;
    background-color: #000000;
    // background-color: #2b2f3a;
  }
  .breadcrumb-container {
    float: left;
  }

  .errLog-container {
    display       : inline-block;
    vertical-align: top;
  }

  .right-menu {
    float      : right;
    height     : 100%;
    line-height: 50px;

    &:focus {
      outline: none;
    }

    .right-menu-item {
      display       : inline-block;
      padding       : 0 8px;
      height        : 100%;
      font-size     : 18px;
      color         : #5a5e66;
      vertical-align: text-bottom;

      &.hover-effect {
        cursor    : pointer;
        transition: background .3s;

        &:hover {
          background: rgba(0, 0, 0, .025)
        }
      }
    }

    .avatar-container {
      margin-right: 30px;

      .avatar-wrapper {
        margin-top: 5px;
        position  : relative;

        .user-avatar {
          cursor       : pointer;
          width        : 40px;
          height       : 40px;
          border-radius: 10px;
        }

        .el-icon-caret-bottom {
          cursor   : pointer;
          position : absolute;
          right    : -20px;
          top      : 25px;
          font-size: 12px;
        }
      }
    }
  }
}
.change-theme {
  @if $navbarColor == #000000 {
    color: #ffffff !important;
  } @else {
    color: #000000 !important;
  }
}
.change-theme2 {
  @if $navbarColor == #000000 {
    color    : #ffffff !important;
    margin   : 19px;
    font-size: 12px;
  } @else {
    color    : #000000 !important;
    margin   : 19px;
    font-size: 12px;
  }
}

.class {
  margin: 0px;
  color: #FFFFFF;
  font-size: 12px;
  font-weight: 700;
  /* padding: 30px; */
  vertical-align: -webkit-baseline-middle;
}
.class2 {
  margin         : 0px;
  color          : #FFFFFF;
  font-size      : 12px;
  font-weight    : 700;
  padding        : 30px !important;
  vertical-align : -webkit-baseline-middle;
  // display        : flex;
  // justify-content: center
  // width: 100% !important;
  // text-align: center;
}

.img-container4 {
  margin-left: 300px;
  // margin-left: 400px;
  float      : left !important;
  width      : 18rem !important;
  margin-top : -1.1rem !important;
  // margin-bottom   : 0.6rem;
  vertical-align  : middle !important;
  text-align      : center !important;
  background-color: #000000 !important;
  // background-color: #2b2f3a !important;
  color      : #FFFFFF !important;
  font-size  : 12px !important;
  font-weight: 700 !important;
}

.pre-formatted {
  white-space: pre;
}
</style>
