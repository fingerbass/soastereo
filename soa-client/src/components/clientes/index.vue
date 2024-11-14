<template lang="pug">
el-form(ref='form' :model='form' label-width='80px' size="mini" :label-position="isMovil ? 'top' : 'right'" :rules="rules" class="demo-formusuario")
  //- el-input.is-uppercase(v-if="tipoaccion === 2" size='mini' placeholder='ID' v-model='idcliente')
  el-row
    el-col(:xs="24" :sm="24" :md="24" :lg="24" :xl="24")
      el-form-item(label='Nombres' size='mini')
        el-input.is-uppercase(size='mini' placeholder='Nombres' v-model='form.nombres')
    el-col(:xs="24" :sm="24" :md="24" :lg="24" :xl="24")
      el-form-item(label='Apellidos' size='mini')
        el-input.is-uppercase(size='mini' placeholder='Apellidos' v-model='form.apellidos')
    el-col(:xs="24" :sm="24" :md="24" :lg="24" :xl="24")
      el-form-item(label='DNI' size='mini')
        el-input.is-uppercase(size='mini' placeholder='Numero Documento' v-model='form.numerodocumento' maxlength="8" show-word-limit)
    el-col(:xs="24" :sm="24" :md="24" :lg="24" :xl="24")
      el-form-item(label='Direccion' size='mini')
        el-input.is-uppercase(size='mini' placeholder='Direccion' v-model='form.direccion')
    el-col(:xs="24" :sm="24" :md="24" :lg="24" :xl="24")
      el-form-item(label='Distrito' size='mini')
        el-input.is-uppercase(size='mini' placeholder='Distrito' v-model='form.distrito')
    el-col(:xs="24" :sm="24" :md="24" :lg="24" :xl="24")
      el-form-item(label='Ciudad' size='mini')
        el-input.is-uppercase(size='mini' placeholder='Ciudad' v-model='form.ciudad')
    el-col(:xs="24" :sm="24" :md="24" :lg="24" :xl="24")
      el-form-item(label='Email' size='mini')
        el-input.is-uppercase(size='mini' placeholder='Email' v-model='form.email')
    el-col(:xs="24" :sm="24" :md="24" :lg="24" :xl="24")
      el-form-item(label='Telefono' size='mini')
        el-input.is-uppercase(size='mini' placeholder='Telefono' v-model='form.telefono')
    el-col(:xs="24" :sm="24" :md="24" :lg="24" :xl="24")
      el-form-item(label='Activo' size='mini')
        el-switch(size='mini' placeholder='Activo' v-model='form.activo' active-color="#1890ff" inactive-color="#ff4949")
  //- el-row
  //-   el-col(:xs="24" :sm="24" :md="24" :lg="24" :xl="24")
  //-     el-form-item(label='USUARIO REGISTRO' size='mini')
  //-       el-input.is-uppercase(size='mini' placeholder='USUARIO REGISTRO' v-model='form.usuarioregistro')
  //- el-row
  //-   el-col(:xs="24" :sm="24" :md="24" :lg="24" :xl="24")
  //-     el-form-item(label='FECHA REGISTRO' size='mini')
  //-       el-input.is-uppercase(size='mini' placeholder='FECHA REGISTRO' v-model='form.fecharegistro')
  el-form-item
    el-row
      el-col(:xs="12" :sm="12" :md="12" :lg="12" :xl="12")
        el-button(type='primary' size='mini' @click='onSubmit' style='width: 95%;' :disabled="cargandoInformacion") Aceptar
      el-col(:xs="12" :sm="12" :md="12" :lg="12" :xl="12")
        el-button(size='mini' @click="close()" style='width: 95%;' :disabled="cargandoInformacion") Cancelar
</template>

<script>
import { clientesMantenimiento }  from '@/api/clientes'
import { notify }                 from '@/utils/general.js'
import { mapState }               from 'vuex'
export default {
  name: 'FormEmpresa',
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
    return {
      form: {
        idcliente      : null,
        nombres        : '',
        apellidos      : '',
        numerodocumento: '',
        direccion      : '',
        distrito       : '',
        ciudad         : '',
        telefono       : '',
        email          : '',
        activo         : true,
        usuarioregistro: localStorage.getItem('username'),
        fecharegistro  : ''
      },
      cargandoInformacion: false,
      rules: {
        name: [
          { required: true, message: 'Please input Activity name', trigger: 'blur' },
          { min: 3, max: 5, message: 'Length should be 3 to 5', trigger: 'blur' }
        ],
        region: [
          { required: true, message: 'Please select Activity zone', trigger: 'change' }
        ],
        date1: [
          { type: 'date', required: true, message: 'Please pick a date', trigger: 'change' }
        ],
        date2: [
          { type: 'date', required: true, message: 'Please pick a time', trigger: 'change' }
        ],
        type: [
          { type: 'array', required: true, message: 'Please select at least one activity type', trigger: 'change' }
        ],
        resource: [
          { required: true, message: 'Please select activity resource', trigger: 'change' }
        ],
        desc: [
          { required: true, message: 'Please input activity form', trigger: 'blur' }
        ]
      },
      isMovil: JSON.parse(localStorage.getItem('isMovil'))
    }
  },
  computed: {
    ...mapState('loading', ['isLoading'])
  },
  created () {
    var vm = this
    console.log('vm.title', vm.title)
    console.log('vm.tipoaccion', vm.tipoaccion)
    console.log('vm.model', vm.model)
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
    cargarDatosVacios () {
      var vm          = this
      vm.form = {
        idcliente      : null,
        nombres         : '',
        apellidos         : '',
        numerodocumento            : '',
        direccion      : '',
        distrito       : '',
        ciudad         : '',
        telefono       : '',
        email          : '',
        activo         : true,
        logo           : '',
        isotipo        : '',
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
          idcliente      : vm.model.idcliente,
          nombres        : vm.model.nombres,
          apellidos      : vm.model.apellidos,
          numerodocumento: vm.model.numerodocumento,
          direccion      : vm.model.direccion,
          distrito       : vm.model.distrito,
          ciudad         : vm.model.ciudad,
          telefono       : vm.model.telefono,
          email          : vm.model.email,
          activo         : vm.model.activo,
          logo           : vm.model.logo,
          isotipo        : vm.model.isotipo,
          usuarioregistro: vm.model.usuarioregistro,
          fecharegistro  : vm.model.fecharegistro
        }
      }
    },
    onSubmit() {
      var vm                  = this
      if (vm.form.nombres === null || vm.form.nombres === undefined || vm.form.nombres === '') {
        notify(vm, 'error', 'Error', 'Debe ingresar un nombres.')
        return
      }
      if (vm.form.apellidos === null || vm.form.apellidos === undefined || vm.form.apellidos === '') {
        notify(vm, 'error', 'Error', 'Debe ingresar un apellidos.')
        return
      }
      if (vm.form.numerodocumento === null || vm.form.numerodocumento === undefined || vm.form.numerodocumento === '') {
        notify(vm, 'error', 'Error', 'Debe ingresar un numerodocumento.')
        return
      }
      if (vm.form.direccion === null || vm.form.direccion === undefined || vm.form.direccion === '') {
        notify(vm, 'error', 'Error', 'Debe ingresar una direccion.')
        return
      }
      if (vm.form.distrito === null || vm.form.distrito === undefined || vm.form.distrito === '') {
        notify(vm, 'error', 'Error', 'Debe ingresar un distrito.')
        return
      }
      if (vm.form.ciudad === null || vm.form.ciudad === undefined || vm.form.ciudad === '') {
        notify(vm, 'error', 'Error', 'Debe ingresar una ciudad.')
        return
      }
      if (vm.form.telefono === null || vm.form.telefono === undefined || vm.form.telefono === '') {
        notify(vm, 'error', 'Error', 'Debe ingresar un telefono.')
        return
      }
      if (vm.form.email === null || vm.form.email === undefined || vm.form.email === '') {
        notify(vm, 'error', 'Error', 'Debe ingresar un email.')
        return
      }
      vm.cargandoInformacion  = true
      var arreglo = {
        idcliente      : vm.form.idcliente,
        nombres        : vm.form.nombres,
        apellidos      : vm.form.apellidos,
        numerodocumento: vm.form.numerodocumento,
        direccion      : vm.form.direccion,
        distrito       : vm.form.distrito,
        ciudad         : vm.form.ciudad,
        telefono       : vm.form.telefono,
        email          : vm.form.email,
        activo         : vm.form.activo,
        usuarioregistro: vm.form.usuarioregistro,
        fecharegistro  : vm.form.fecharegistro
      }
      var obj = {
        tipoaccion: vm.tipoaccion,
        arreglo   : arreglo
      }
      clientesMantenimiento(obj).then(data => {
        console.log('data: ', data)
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
    submitForm(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          alert('submit!')
        } else {
          console.log('error submit!!')
          return false
        }
      })
    },
    resetForm(formName) {
      this.$refs[formName].resetFields()
    },
    // UPLOAD
    handleAvatarSuccessLogo(res, file) {
      console.log('res:>>> ', res)
      console.log('file:>>> ', file)
      var vm = this
      vm.imageUrl = URL.createObjectURL(file.raw)
      console.log('vm.imageUrl:>>> ', vm.imageUrl)
    },
    beforeAvatarUploadLogo(file) {
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
      this.createBase64ImageLogo(file)
    },
    createBase64ImageLogo(fileObject) {
      const reader = new FileReader()
      reader.onload = (e) => {
        // this.base64 = e.target.result
        this.form.logo = e.target.result
      }
      // reader.readAsBinaryString(fileObject)
      reader.readAsDataURL(fileObject)
      console.log('fileObject:>>> ', fileObject)
    },
    handleRemoveLogo(file, fileList) {
      console.log(file, fileList)
    },
    handlePictureCardPreviewLogo(file) {
      console.log('file:>>> ', file)
      var vm = this
      vm.dialogImageUrl = file.url
      vm.dialogVisible = true
    },
    handleDownloadLogo(file) {
      console.log('file:>>> ', file)
    },
    handleUploadBeforeLogo(file) {
      console.log('file:>>> ', file)
      // var vm = this
      console.log(file.name)
    },
    handleAvatarSuccessIsotipo(res, file) {
      console.log('res:>>> ', res)
      console.log('file:>>> ', file)
      var vm = this
      vm.imageUrl = URL.createObjectURL(file.raw)
      console.log('vm.imageUrl:>>> ', vm.imageUrl)
    },
    beforeAvatarUploadIsotipo(file) {
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
      this.createBase64ImageIsotipo(file)
    },
    createBase64ImageIsotipo(fileObject) {
      const reader = new FileReader()
      reader.onload = (e) => {
        // this.base64 = e.target.result
        this.form.isotipo = e.target.result
      }
      // reader.readAsBinaryString(fileObject)
      reader.readAsDataURL(fileObject)
      console.log('fileObject:>>> ', fileObject)
    },
    handleRemoveIsotipo(file, fileList) {
      console.log(file, fileList)
    },
    handlePictureCardPreviewIsotipo(file) {
      console.log('file:>>> ', file)
      var vm = this
      vm.dialogImageUrl = file.url
      vm.dialogVisible = true
    },
    handleDownloadIsotipo(file) {
      console.log('file:>>> ', file)
    },
    handleUploadBeforeIsotipo(file) {
      console.log('file:>>> ', file)
      // var vm = this
      console.log(file.name)
    }
    // handleImageLogo (e) {
    //   const selectedImage = e.target.files[0]
    //   this.createBase64ImageLogo(selectedImage)
    // },
    // createBase64ImageLogo (fileObject) {
    //   const reader = new FileReader()
    //   reader.onload = (e) => {
    //     // this.base64 = e.target.result
    //     this.form.logo = e.target.result
    //   }
    //   // reader.readAsBinaryString(fileObject)
    //   reader.readAsDataURL(fileObject)
    //   console.log('fileObject:>>> ', fileObject)
    // },
    // handleImageIsotipo (e) {
    //   const selectedImage = e.target.files[0]
    //   this.createBase64ImageIsotipo(selectedImage)
    // },
    // createBase64ImageIsotipo (fileObject) {
    //   const reader = new FileReader()
    //   reader.onload = (e) => {
    //     // this.base64 = e.target.result
    //     this.form.isotipo = e.target.result
    //   }
    //   // reader.readAsBinaryString(fileObject)
    //   reader.readAsDataURL(fileObject)
    //   console.log('fileObject:>>> ', fileObject)
    // },
  }
}
</script>

<style lang="scss" scoped>
.text-align-center {
  text-align: center
}
.margin-bottom-20px {
  margin-bottom: 20px
}
.margin-bottom-10px {
  margin-bottom: 10px
}
.el-dialog__header {
  text-align: center
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
// .el-input--medium .el-input__inner {
//     height: 36px;
//     line-height: 36px;
//     text-transform: uppercase;
// }

</style>

