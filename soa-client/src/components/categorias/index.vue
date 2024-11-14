<template lang="pug">
el-form(ref='form' :model='form' label-width='80px' size="mini" :label-position="isMovil ? 'top' : 'right'" :rules="rules" class="demo-formusuario")
  //- el-input.is-uppercase(v-if="tipoaccion === 2" size='mini' placeholder='ID' v-model='idcategoria')
  el-row
    el-col(:xs="24" :sm="24" :md="24" :lg="24" :xl="24")
      el-form-item(label='Nombre' size='mini')
        el-input.is-uppercase(size='mini' placeholder='Nombre' v-model='form.nombre')
    el-col(:xs="24" :sm="24" :md="24" :lg="24" :xl="24")
      el-form-item(label='Descripcion' size='mini')
        el-input.is-uppercase(size='mini' placeholder='Descripcion' v-model='form.descripcion')
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
import { categoriasMantenimiento }  from '@/api/categorias'
import { notify }                   from '@/utils/general.js'
import { mapState }                 from 'vuex'
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
        idcategoria      : null,
        nombre        : '',
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
        idcategoria    : null,
        nombre         : '',
        descripcion    : '',
        activo         : true,
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
          idcategoria    : vm.model.idcategoria,
          nombre         : vm.model.nombre,
          descripcion    : vm.model.descripcion,
          activo         : vm.model.activo,
          usuarioregistro: vm.model.usuarioregistro,
          fecharegistro  : vm.model.fecharegistro
        }
      }
    },
    onSubmit() {
      var vm                  = this
      if (vm.form.nombre === null || vm.form.nombre === undefined || vm.form.nombre === '') {
        notify(vm, 'error', 'Error', 'Debe ingresar un nombre.')
        return
      }
      if (vm.form.descripcion === null || vm.form.descripcion === undefined || vm.form.descripcion === '') {
        notify(vm, 'error', 'Error', 'Debe ingresar un descripcion.')
        return
      }
      vm.cargandoInformacion  = true
      var arreglo = {
        idcategoria    : vm.form.idcategoria,
        nombre         : vm.form.nombre,
        descripcion    : vm.form.descripcion,
        activo         : vm.form.activo,
        usuarioregistro: vm.form.usuarioregistro,
        fecharegistro  : vm.form.fecharegistro
      }
      var obj = {
        tipoaccion: vm.tipoaccion,
        arreglo   : arreglo
      }
      categoriasMantenimiento(obj).then(data => {
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

