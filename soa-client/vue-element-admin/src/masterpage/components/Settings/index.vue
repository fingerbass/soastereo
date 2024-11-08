<template>
  <div class="drawer-container">
    <div>
      <h3 class="drawer-title">Configuración de estilo de página</h3>

      <div class="drawer-item">
        <span>Color del tema</span>
        <theme-picker style="float: right;height: 26px;margin: -3px 8px 0 0;" @change="themeChange" />
      </div>

      <div class="drawer-item">
        <span>Color del Navbar</span>
        <theme-picker style="float: right;height: 26px;margin: -3px 8px 0 0;" @change="themeChangeNavBar" />
      </div>

      <div class="drawer-item">
        <span>Color del Sidebar</span>
        <theme-picker style="float: right;height: 26px;margin: -3px 8px 0 0;" @change="themeChangeSideBar" />
      </div>

      <div class="drawer-item">
        <span>Cambiar Tema</span>
        <el-switch v-model="theme" class="drawer-switch" />
      </div>

      <div class="drawer-item">
        <span>Ver etiquetas-tags</span>
        <el-switch v-model="tagsView" class="drawer-switch" />
      </div>
      <div class="drawer-item">
        <span>Cambiar tamaño</span>
      </div>
      <div>
        <el-radio-group v-model="radio1" size="mini">
          <el-radio-button label="default" />
          <el-radio-button label="medium" />
          <el-radio-button label="small" />
          <el-radio-button label="mini" />
        </el-radio-group>
      </div>

    </div>
  </div>
</template>

<script>
import { toggleClass } from '@/utils'
import '@/assets/lib_contenido/index.css'
import ThemePicker from '../ThemePicker'
export default {
  components: { ThemePicker },
  data() {
    return {
      theme: false,
      radio1: 'mini'
    }
  },
  computed: {
    tagsView: {
      get() {
        return this.$store.state.settings.tagsView
      },
      set(val) {
        this.$store.dispatch('settings/changeSetting', {
          key: 'tagsView',
          value: val
        })
      }
    }
  },
  watch: {
    theme() {
      toggleClass(document.body, 'lib_contenido')
    }
  },
  methods: {
    themeChange(val) {
      this.$store.dispatch('settings/changeSetting', {
        key: 'theme',
        value: val
      })
    },
    themeChangeNavBar(val) {
      this.$store.dispatch('settings/changeSetting', {
        key: 'navbar',
        value: val
      })
    },
    themeChangeSideBar(val) {
      this.$store.dispatch('settings/changeSetting', {
        key: 'sidebar',
        value: val
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.drawer-container {
  padding: 24px;
  font-size: 14px;
  line-height: 1.5;
  word-wrap: break-word;

  .drawer-title {
    margin-bottom: 12px;
    color: rgba(0, 0, 0, .85);
    font-size: 14px;
    line-height: 22px;
  }

  .drawer-item {
    color: rgba(0, 0, 0, .65);
    font-size: 14px;
    padding: 12px 0;
  }

  .drawer-switch {
    float: right
  }
}

.select-tamano {
  width: 100px;
  margin-left: 8px;
}
</style>
