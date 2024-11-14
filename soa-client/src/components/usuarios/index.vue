<template lang="pug">
el-form(ref='form' :model='form' label-width='120px' size="mini" :label-position="isMovil ? 'top' : 'right'" :rules="rules" :show-message="false" class="demo-form")
  //- el-input.is-uppercase(v-if="tipoaccion === 2" size='mini' placeholder='ID' v-model='idusuario')
  el-row
    el-col(:xs="24" :sm="24" :md="24" :lg="24" :xl="24")
      el-form-item(label='Apellido Paterno' size='mini' prop="paterno")
        el-input.is-uppercase(size='mini' placeholder='Apellido Paterno' v-model='form.paterno' :maxlength="50" clearable show-word-limit)
    el-col(:xs="24" :sm="24" :md="24" :lg="24" :xl="24")
      el-form-item(label='Apellido Materno' size='mini' prop="materno")
        el-input.is-uppercase(size='mini' placeholder='Apellido Materno' v-model='form.materno' :maxlength="50" clearable show-word-limit)
    el-col(:xs="24" :sm="24" :md="24" :lg="24" :xl="24")
      el-form-item(label='Nombre' size='mini' prop="nombre")
        el-input.is-uppercase(size='mini' placeholder='Nombre' v-model='form.nombre' :maxlength="50" clearable show-word-limit)
    el-col(:xs="24" :sm="24" :md="12" :lg="12" :xl="12")
      el-form-item(label='Tipo Documento' prop='idtipodocumento' align='left' size='mini')
        el-select.width-total(v-model='form.idtipodocumento' placeholder='Seleccione Tipo Documento' size='mini' :disabled="cargandoInformacion || isLoadingTipoDocumento" :loading="isLoadingTipoDocumento" @change='changeTipoDocumento()')
          el-option(v-for='item in listaTiposDocumentos' :key='item.idtipodocumento' :label='item.nombre' :value='item.idtipodocumento')
    el-col(:xs="24" :sm="24" :md="12" :lg="12" :xl="12")
      el-form-item(label='Documento' size='mini')
        el-input.is-uppercase(size='mini' placeholder='Ingrese Documento' v-model='form.documento' style='text-align: right;' :loading="isLoadingTipoDocumento" :disabled="cargandoInformacion || isLoadingTipoDocumento || isTrue" :maxlength="maxlengthTipodocumento" clearable show-word-limit)
    //- el-row
    //-   el-col(:xs="24" :sm="24" :md="24" :lg="24" :xl="24")
    //-     el-form-item(label='Documento' size='mini' prop="documento")
    //-       el-input.is-uppercase(size='mini' placeholder='Documento' type="number" v-model='form.documento' :disabled='tipoaccion === 2')
    el-col(:xs="24" :sm="24" :md="12" :lg="12" :xl="12")
      el-form-item(label='Email' size='mini' prop='email')
        el-input.is-uppercase(type='email' size='mini' placeholder='Email' v-model='form.email' :max="80" clearable show-word-limit)
    el-col(:xs="24" :sm="24" :md="12" :lg="12" :xl="12")
      el-form-item(label='Movil' size='mini' prop='movil')
        el-input.is-uppercase(type='number' size='mini' placeholder='Movil' v-model='form.movil' :max="20" clearable show-word-limit)
    el-col(:xs="24" :sm="24" :md="12" :lg="12" :xl="12")
      el-form-item(label='Usuario' size='mini' prop='login')
        el-input.is-uppercase(size='mini' placeholder='Login' v-model='form.login' :disabled="administrador !== true && isTrue" :maxlength="50" show-word-limit)
    el-col(:xs="24" :sm="24" :md="12" :lg="12" :xl="12" v-if="administrador === true")
      el-form-item(label='Contraseña' size='mini' prop='password')
        el-input.is-uppercase(size='mini' placeholder='Password' v-model='form.password')
    el-col.password(:xs="24" :sm="24" :md="3" :lg="3" :xl="3" v-if="tipoaccion === 2 && administrador === true")
      el-button(type='primary' size='mini' @click="changePassword()" style='width: 100%;' :loading="isLoadingCambiarPassword" :disabled="isLoadingCambiarPassword") Cambiar
    //- el-row
    //-   el-col(:xs="24" :sm="24" :md="24" :lg="24" :xl="24")
    //-     el-form-item(label='ULTIMO INGRESO' size='mini')
    //-       el-input.is-uppercase(size='mini' placeholder='ULTIMO INGRESO' v-model='form.ultimoingreso')
    //-   el-col(:xs="24" :sm="24" :md="24" :lg="24" :xl="24")
    //-     el-form-item(label='CAMBIO CLAVE' size='mini')
    //-       el-input.is-uppercase(size='mini' placeholder='CAMBIO CLAVE' v-model='form.cambioclave')
    el-col(:xs="12" :sm="12" :md="12" :lg="12" :xl="12")
      el-form-item(label='Activo' size='mini')
        el-switch(size='mini' placeholder='Activo' v-model='form.activo' active-color="#1890ff" inactive-color="#ff4949")
    el-col(:xs="12" :sm="12" :md="12" :lg="12" :xl="12")
      el-form-item(label='Administrador' size='mini')
        el-switch(size='mini' placeholder='administrador' v-model='form.administrador' active-color="#1890ff" inactive-color="#ff4949")
  //- el-row
  //-   el-col(:xs="24" :sm="24" :md="24" :lg="24" :xl="24")
  //-     el-form-item(label='USUARIO REGISTRO' size='mini')
  //-       el-input.is-uppercase(size='mini' placeholder='USUARIO REGISTRO' v-model='form.usuarioregistro')
  //-   el-col(:xs="24" :sm="24" :md="24" :lg="24" :xl="24")
  //-     el-form-item(label='FECHA REGISTRO' size='mini')
  //-       el-input.is-uppercase(size='mini' placeholder='FECHA REGISTRO' v-model='form.fecharegistro')
  el-row.demo-avatar.demo-basic.text-align-center.margin-bottom-10px
    el-col(:xs="24" :sm="24" :md="24" :lg="24" :xl="24")
      el-upload.avatar-uploader(action='#' accept='image/*' list-type="picture-card"  :show-file-list='false' :on-success='handleAvatarSuccess' :before-upload='beforeAvatarUpload' :on-remove='handleRemove' :on-preview='handlePictureCardPreview')
        img.avatar(v-if='form.foto' :src='form.foto')
        i.el-icon-plus.avatar-uploader-icon(v-else='')
        .el-upload__tip(slot='tip') Solo archivos jpg/png/jfif con un tamaño menor de 2MB
  el-form-item
    el-row
      el-col(:xs="12" :sm="12" :md="12" :lg="12" :xl="12")
        el-button(type='primary' size='mini' @click="submitForm('form')" style='width: 95%;' :disabled="cargandoInformacion") {{ title }}
      el-col(:xs="12" :sm="12" :md="12" :lg="12" :xl="12")
        el-button(size='mini' @click="close()" style='width: 95%;' :disabled="cargandoInformacion") Cancelar
</template>

<script>
import { usuariosMantenimiento }    from '@/api/usuarios'
import { usuariospasswordCambiar }  from '@/api/usuarios-password'
import { tiposdocumentosLista }     from '@/api/tipos-documentos'
import { notify }                   from '@/utils/general.js'
import { mapState }                 from 'vuex'
export default {
  name: 'FormUsuario',
  props: {
    title: {
      type    : String,
      required: true,
      default : ''
    },
    tipoaccion: {
      type    : Number,
      required: true,
      default : 1
    },
    model: {
      type    : Object,
      required: false,
      default() {
        return {}
      }
    }
  },
  data() {
    var validate = (rule, value, callback) => {
      if (value === '') {
        callback(new Error(''))
      } else {
        callback()
      }
    }
    return {
      form: {
        idusuario      : null,
        paterno        : '',
        materno        : '',
        nombre         : '',
        idtipodocumento: '',
        documento      : '',
        login          : '',
        password       : '',
        email          : '',
        movil          : '',
        ultimoingreso  : '',
        cambioclave    : '',
        activo         : true,
        foto           : '',
        usuarioregistro: localStorage.getItem('username'),
        fecharegistro  : '',
        file           : null
      },
      isTrue                  : false,
      cargandoInformacion     : false,
      foto                    : {},
      file                    : null,
      imageUrl                : {},
      dialogImageUrl          : '',
      dialogVisible           : false,
      disabled                : false,
      isLoadingCambiarPassword: false,
      maxlengthTipodocumento  : 8,
      listaTiposDocumentos    : [],
      isLoadingTipoDocumento  : false,
      administrador           : JSON.parse(localStorage.getItem('administrador')),
      apiRoute                : process.env.VUE_APP_API_ROUTE,
      rules                   : {
        paterno: [
          { validator: validate, trigger: 'blur' }
        ],
        materno: [
          { validator: validate, trigger: 'blur' }
        ],
        nombre: [
          { validator: validate, trigger: 'blur' }
        ],
        idtipodocumento: [
          { validator: validate, trigger: 'blur' }
        ],
        documento: [
          { validator: validate, trigger: 'blur' }
        ],
        email: [
          { validator: validate, trigger: 'blur' }
        ],
        login: [
          { validator: validate, trigger: 'blur' }
        ],
        password: [
          { validator: validate, trigger: 'blur' }
        ]
      },
      image  : null,
      base64 : null,
      isMovil: JSON.parse(localStorage.getItem('isMovil'))
    }
  },
  computed: {
    ...mapState('loading', ['isLoading'])
  },
  watch: {
    image: function (newVal, oldVal) {
      if (newVal) {
        this.createBase64Image(newVal)
      } else {
        this.form.foto = null
        // this.base64    = null
      }
    }
  },
  created () {
    var vm = this
    console.log('vm.title', vm.title)
    console.log('vm.tipoaccion', vm.tipoaccion)
    console.log('vm.model', vm.model)
    if (vm.tipoaccion === 1) {
      vm.isTrue = false
    } else {
      vm.isTrue = true
    }
    // console.log(this.$store.getters.size)
    vm.fetchTiposDocumentos()
    vm.cargarDatos()
  },
  methods: {
    isObjEmpty (obj) {
      // console.log('obj:>>> ', obj)
      // var verificar = Object.keys(obj).length === 0
      // console.log('verificar:>>> ', verificar)
      // return verificar
      if (JSON.stringify(obj) === '{}' || obj === null || obj === undefined) {
        return true
      }
    },
    fetchTiposDocumentos () {
      var vm                    = this
      vm.listaTiposDocumentos     = []
      vm.isLoadingTipoDocumento = true
      var obj                   = {
        idestado: 2
      }
      tiposdocumentosLista(obj).then(data => {
        // console.log('data tipo documento:  ', data)
        for (let i = 0; i < data.lista.length; i++) {
          vm.listaTiposDocumentos.push(data.lista[i])
        }
        vm.isLoadingTipoDocumento = vm.isLoading
      }, function (err) {
        vm.isLoadingTipoDocumento = vm.isLoading
        notify(vm, 'error', 'Error', err.message)
      }, function () {
        vm.isLoadingTipoDocumento = false
      })
    },
    changeTipoDocumento () {
      var vm = this
      console.log('vm.form.idtipodocumento: ', vm.form.idtipodocumento)
      if (vm.form.idtipodocumento === '01') {
        vm.maxlengthTipodocumento = 8
      } else if (vm.form.idtipodocumento === '04') {
        vm.maxlengthTipodocumento = 12
      } else if (vm.form.idtipodocumento === '06') {
        vm.maxlengthTipodocumento = 11
      } else if (vm.form.idtipodocumento === '07') {
        vm.maxlengthTipodocumento = 12
      } else if (vm.form.idtipodocumento === '11') {
        vm.maxlengthTipodocumento = 15
      } else if (vm.form.idtipodocumento === '00') {
        vm.maxlengthTipodocumento = 15
      } else if (vm.form.idtipodocumento === '99') {
        vm.maxlengthTipodocumento = 20
      }
    },
    cargarDatosVacios () {
      var vm          = this
      vm.form = {
        idusuario      : null,
        paterno        : '',
        materno        : '',
        nombre         : '',
        idtipodocumento: '',
        documento      : '',
        login          : '',
        password       : '',
        email          : '',
        movil          : '',
        ultimoingreso  : '',
        cambioclave    : '',
        administrador  : '',
        activo         : true,
        foto           : '',
        usuarioregistro: localStorage.getItem('username'),
        fecharegistro  : ''
      }
    },
    cargarDatos () {
      var vm = this
      vm.cargarDatosVacios()
      if (vm.tipoaccion === 1) {
        vm.cargarDatosVacios()
      } else {
        vm.form = {
          idusuario      : vm.model.idusuario,
          paterno        : vm.model.paterno,
          materno        : vm.model.materno,
          nombre         : vm.model.nombre,
          idtipodocumento: vm.model.idtipodocumento,
          documento      : vm.model.documento,
          login          : vm.model.login,
          password       : vm.model.password,
          email          : vm.model.email,
          movil          : vm.model.movil,
          ultimoingreso  : vm.model.ultimoingreso,
          cambioclave    : vm.model.cambioclave,
          administrador  : vm.model.administrador,
          activo         : vm.model.activo,
          foto           : vm.model.foto,
          usuarioregistro: vm.model.usuarioregistro,
          fecharegistro  : vm.model.fecharegistro
        }
      }
    },
    onSubmit() {
      var vm                  = this
      // console.log('vm.form:>>> ', vm.form)
      if (!vm.form.paterno && !vm.form.materno && !vm.form.nombre && !vm.form.documento && !vm.form.login && !vm.form.password) {
        notify(vm, 'error', 'Error', 'Algunos de los campos son obligatorio.')
        return
      }
      vm.cargandoInformacion  = true
      var arreglousuario      = {
        idusuario      : vm.form.idusuario,
        paterno        : vm.form.paterno,
        materno        : vm.form.materno,
        nombre         : vm.form.nombre,
        idtipodocumento: vm.form.idtipodocumento,
        documento      : vm.form.documento,
        login          : vm.form.login,
        password       : vm.form.password,
        email          : vm.form.email,
        movil          : vm.form.movil,
        ultimoingreso  : vm.form.ultimoingreso,
        cambioclave    : vm.form.cambioclave,
        administrador  : vm.form.administrador,
        activo         : vm.form.activo,
        foto           : vm.form.foto,
        usuarioregistro: vm.form.usuarioregistro,
        fecharegistro  : vm.form.fecharegistro
      }
      var obj = {
        tipoaccion    : vm.tipoaccion,
        arreglousuario: arreglousuario
      }
      console.log('obj: ', obj)
      usuariosMantenimiento(obj).then(data => {
        // console.log('data: ', data)
        vm.cargandoInformacion = vm.isLoading
        vm.save()
        vm.close()
        notify(vm, 'success', 'Éxito', 'El registro se ah guardado satisfactoriamente.')
      }, function (err) {
        console.log(err)
        vm.cargandoInformacion = vm.isLoading
        notify(vm, 'error', 'Error', err.message)
      }, function () {
        vm.cargandoInformacion = false
      })
    },
    save () {
      this.$emit('save')
    },
    close () {
      this.$emit('close')
    },
    submitForm (formName) {
      this.$refs[formName].validate((valid) => {
        console.log(valid)
        if (valid) {
          this.onSubmit()
        } else {
          return false
        }
      })
    },
    resetForm(formName) {
      this.$refs[formName].resetFields()
    },
    changePassword () {
      var vm = this
      if (!vm.form.idusuario || vm.form.idusuario === null || vm.form.idusuario === undefined) {
        notify(vm, 'error', 'Error', 'No puede estar vacio, Debe ingresar un usuario.')
        return
      }
      if (!vm.form.password || vm.form.password === null || vm.form.password === undefined) {
        notify(vm, 'error', 'Error', 'No puede estar vacio, Debe ingresar una contraseña.')
        return
      }
      if (vm.form.password) {
        if (vm.form.password.length < 6) {
          notify(vm, 'error', 'Error', 'Debe ingresar una contraseña mas de 6 digitos.')
          return
        }
      }
      vm.isLoadingCambiarPassword  = true
      var obj                 = {
        idusuario: vm.form.idusuario,
        password : vm.form.password
      }
      console.log(obj)
      usuariospasswordCambiar(obj).then(data => {
        vm.isLoadingCambiarPassword  = vm.isLoading
        var texto               = 'Se ha cambiado la contraseña correctamente.'
        notify(vm, 'success', 'Éxito', texto)
      }, function (err) {
        vm.isLoadingCambiarPassword = vm.isLoading
        notify(vm, 'error', 'Error', err.message)
      }, function () {
        vm.isLoadingCambiarPassword = false
      })
    },
    // UPLOAD
    handleAvatarSuccess(res, file) {
      console.log('res:>>> ', res)
      console.log('file:>>> ', file)
      var vm = this
      vm.imageUrl = URL.createObjectURL(file.raw)
      console.log('vm.imageUrl:>>> ', vm.imageUrl)
    },
    beforeAvatarUpload(file) {
      console.log('file:>>> ', file)
      var vm = this
      const isJPG  = file.type === 'image/jpeg'
      const isLt2M = file.size / 1024 / 1024 < 2

      if (!isJPG) {
        vm.$message.error('La imagen debe estar en formato JPG!')
      }
      if (!isLt2M) {
        vm.$message.error('La imagen excede los 2MB!')
      }
      // return isJPG && isLt2M
      // vm.form.foto =  file.name
      this.createBase64Image(file)
    },
    createBase64Image (fileObject) {
      const reader = new FileReader()
      reader.onload = (e) => {
        // this.base64 = e.target.result
        this.form.foto = e.target.result
      }
      // reader.readAsBinaryString(fileObject)
      reader.readAsDataURL(fileObject)
      console.log('fileObject:>>> ', fileObject)
    },
    handleRemove(file, fileList) {
      console.log(file, fileList)
    },
    handlePictureCardPreview(file) {
      console.log('file:>>> ', file)
      var vm = this
      vm.dialogImageUrl = file.url
      vm.dialogVisible = true
    },
    handleDownload(file) {
      console.log('file:>>> ', file)
    },
    handleUploadBefore(file) {
      console.log('file:>>> ', file)
      // var vm = this
      console.log(file.name)
    }
    // handleImage (e) {
    //   console.log('e.target.files', e.target.files)
    //   console.log('e.target.files[0]', e.target.files[0])
    //   const selectedImage = e.target.files[0]
    //   this.createBase64Image(selectedImage)
    // },
    // createBase64Image: function(FileObject) {
    //   const reader  = new FileReader();
    //   reader.onload = (event) => {
    //     this.base64 = event.target.result;
    //   }
    //   reader.readAsDataURL(FileObject);
    //   console.log('this.base64', this.base64)
    // }
  }
}
</script>

<style lang="scss" scoped>
.text-align-center {
  text-align: center
}
.margin-bottom-10px {
  margin-bottom: 20px
}
.margin-bottom-20px {
  margin-bottom: 20px
}
.el-dialog__header {
  text-align: center
}

.is-uppercase {
  text-transform: uppercase !important;
}
.password {
  float: right;
  margin-top: 5px;
}

/* UPLOAD */
.avatar-uploader .el-upload {
  border       : 1px dashed #d9d9d9;
  border-radius: 6px;
  cursor       : pointer;
  position     : relative;
  overflow     : hidden;
}
.avatar-uploader .el-upload:hover {
  border-color: #409EFF;
}
.avatar-uploader-icon {
  font-size  : 28px;
  color      : #8c939d;
  width      : 150px;
  height     : 150px;
  line-height: 150px;
  text-align : center;
}
.avatar {
  width : 145px;
  height: 145px;
}
</style>

@/api/tipos-corespondencia
