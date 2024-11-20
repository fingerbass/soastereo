<template lang="pug">
.card.flex-uno
  .card-content
    .content
      .upload-container
        .dropzone(
          :id="'dropzone_' + name"
          v-if="!filename"
          @click='$upload.select(name)'
        )
          transition(name="fade-quick")
            .overlay(v-show="$upload.meta(name).dropzoneActive")
              span Suelta el archivo para cargarlo
          .upload-progress(v-if='$upload.meta(name).status == "sending"')
            span {{$upload.meta(name).percentCompvare}}%
          span.icon.is-large.icon-adjuntar
            //- el-icon.md-size-2x.color-adjuntar cloud_upload
            //- svg-icon(icon-class='excel')
            i.el-icon-upload(style="font-size: 50px;")
          span.margin-bottom-10.texto Para poder subir el archivo , Dale click al recuadro para buscar en tus archivos.
        .error(v-if="$upload.errors(name).length > 0")
          | {{ $upload.errors(name)[0].msg }}
        transition(name="fade")
          .uploaded-file(v-if="filename")
            template(v-for="file in $upload.files(name).all")
              span.file-name {{ file.name }}
              .buttons-container.margin-10
                //- template(v-if="!isSaving")
                template
                  el-button.md-raised.md-primary.flex-uno(v-if="$upload.errors(name).length === 0" type="primary"
                  @click="save(fileSubido)")
                    span Guardar archivo
                  el-button.md-raised.flex-uno(@click='limpiar')
                    span Volver adjuntar
                //- template(v-else)
                //-   button.button.flex-1.margin-left-5.is-primary.is-loading.is-disabled()
                //-     span Guardando
      el-button.el-icon-button.md-raised.md-dense.md-accent.floating(type='danger' @click="close", v-if="!filename" circle='')
        el-icon.el-icon-close
      el-button(v-else size="mini" width="100%;" style='width: 100%;' @click='close') Cancelar
</template>

<script>
export default {
  name : 'CAdjuntarArchivo',
  // props: ['url', 'name', 'isSaving', 'isSaved', 'observations'],
  props: {
    url: {
      type   : String,
      default: null
    },
    name: {
      type   : String,
      default: null
    },
    isSaving: {
      type   : Boolean,
      default: false
    },
    isSaved: {
      type   : Boolean,
      default: false
    },
    observations: {
      type   : String,
      default: null
    }
  },
  data() {
    return {
      fileSubido: {},
      apiRoute  : process.env.API_ROUTE,
      filename  : '',
      test      : '',
      upload    : this.$upload
    }
  },
  // created() {
  //   var vm = this
  //   vm.create()
  //   vm.$forceUpdate()
  // },
  computed: {
    _meta() {
      var vm = this
      return this.$upload.meta(vm.name)
    },
    _file() {
      var vm = this
      return this.$upload.file(vm.name)
    },
    errorcomputed () {
      var vm = this
      return this.$upload.files(vm.name).error
    }
  },
  mounted() {
    var vm = this
    vm.create()
    vm.$forceUpdate()
  },
  beforeDestroy() {
    var vm = this
    this.$upload.off(vm.name)
  },
  methods: {
    create() {
      var vm = this
      this.$upload.on(vm.name, {
        accept             : ['*'],
        extensions         : ['xlsx'],
        // extensions         : ['pdf', 'png', 'jpg', 'docx', 'xlsx', 'pptx', 'txt', 'doc', 'mp4'],
        maxSizePerFile     : 5 * 1024 * 1024,
        dropzoneId         : 'dropzone',
        invalidExtensionMsg: 'El archivo no tiene una extencion no permitida solo permite .xlsx',
        maxFileSizeMsg     : 'Máximo de {max}MB por archivo',
        http               : (data) => {
          console.log('data:>>> ', data)
        },
        onSelect: (files, res) => {
          console.log('files:>>> ', files)
          console.log('res:>>> ', res)
          vm.fileSubido = vm._file.$file
          vm.filename   = vm._file.$file.name
          console.log('vm.fileSubido:>>> ', vm.fileSubido)
          console.log('vm.filename:>>> ', vm.filename)
        },
        onProgress(file, res) {
          console.log('onProgress')
          console.log(file)
          console.log(res)
        },
        onSuccess: (file, res) => {
          console.log('onSuccess')
          console.log(file)
          console.log(res)
          this.file = res.data.data
        },
        onError: (file, res) => {
          console.log('onError')
          console.log(file)
          console.log(res)
          console.log(this.$upload.errors(vm.name))
        },
        onEnd(files, res) {
          console.log('onEnd')
        }
      })
    },
    select() {
      var vm = this
      this.$upload.select(vm.name)
    },
    start() {
      var vm = this
      this.$upload.start(vm.name)
    },
    reset() {
      var vm = this
      this.$upload.reset(vm.name)
    },
    limpiar() {
      var vm        = this
      vm.fileSubido = {}
      vm.filename   = ''
      this.$upload.reset(vm.name)
    },
    save (fileSubido) {
      var vm = this
      vm.$emit('save', fileSubido)
      vm.fileSubido = {}
      vm.filename   = ''
      vm.update()
      vm.$emit('close')
    },
    update() {
      var vm = this
      this.$upload.reset(vm.name)
    },
    close() {
      var vm = this
      vm.fileSubido = {}
      vm.filename   = ''
      vm.update()
      vm.$emit('close')
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style lang="scss" scoped>
.card-content {
  position: relative
}

.download-container {
  padding: 13px 10px 0px 10px
}

.upload-container {
  .dropzone {
    width: 100%;
    height: 120px;
    position: relative;
    margin: 10px 0px;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    cursor: pointer;
    color: #e91e63;
    background-color: #ffe8f0;
    text-align: center;
    margin-top: 10px;
    margin-bottom: 10px;
    padding: 10px;
    font-size: 12px;
    font-weight: 700;
    border-radius: 10px;

    .overlay {
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      position: absolute;
      background-color: rgba(10, 10, 10, 0.3);
      display: flex;
      justify-content: center;
      align-items: center;
      color: #fff;
      font-size: 28px;
    }

    .upload-progress {
      position: absolute;
      top: 0;
      right: 0;
    }

    .icon {
      display: block;
      margin-top: 10px;
    }
  }

  .uploaded-file {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;

    button {
      margin-top: 5px;
    }
  }

  .error {
    color: #fff;
    background-color: #f70859;
    padding: 5px;
    border-radius: 9px;
    font-size: 12px;
    text-align: center;
    font-weight: 500;
  }

  .observations {
    margin-top: 10px;
    display: flex;
    flex-direction: column;
    align-items: center;
    border: 1px solid #f00;
    padding: 10px;
    background-color: #fde0e0;

    p {
      font-size: 20px;
      margin-bottom: 0;
    }

    ul {
      list-style-type: none;
      text-align: left;
      font-weight: bold;

      .error {
        color: #f00;
      }

      .warning {
        color: #4831ff;
      }
    }
  }
}

.texto {
  font-size: 11.5px;
  color: #e91e63;
  text-align: center;
  font-weight: bold;
}

.color-adjuntar {
  color: #e91e63;
}

.floating {
  position: absolute;
  top: -9px;
  right: -14px;
}

.file-name {
  color: #3d3b3b;
  font-size: 11px;
  padding: 5px;
  padding-left: 15px;
  padding-right: 15px;
  font-weight: 800;
  background-color: #e8e4e4;
  border-radius: 15px;
}

.icon-adjuntar {
  background-color: #fff;
  padding: 10px;
  border-radius: 73px;
  border: 1px dashed #f70859;
  box-shadow: 0 0 0 #e91e63;
  animation: pulse 1.3s infinite;
}

.margin-bottom-10 {
  margin-top   : 10px;
  margin-bottom: 10px;
}
</style>
