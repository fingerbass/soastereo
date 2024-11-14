<template lang="pug">
#app
  router-view
    notifications(position='bottom' width='100%')
  //- <div id="app">
  //-   <router-view />
  //-   <notifications position="bottom" width="100%" />
  //-   <procesos-handler v-if="showProcesos" />
  //- </div>
</template>

<script>
export default {
  name: 'App'
}
</script>

<style lang="scss">
@import '~animate.css';

::-webkit-scrollbar {
  -webkit-appearance: none;
}

::-webkit-scrollbar:vertical {
  width:10px;
}

::-webkit-scrollbar-button:increment,::-webkit-scrollbar-button {
  display: none;
}

::-webkit-scrollbar:horizontal {
  height: 10px;
}

::-webkit-scrollbar-thumb {
  background-color: #797979;
  border-radius   : 20px;
  border          : 2px solid #f1f2f3;
}

::-webkit-scrollbar-track {
  border-radius: 10px;
}

.width-total {
  width: 100% !important;
}

.width-100 {
  width: 100% !important;
}

.is-uppercase {
  text-transform: uppercase !important;
}

.fade-enter-active,
.fade-leave-active {
  transition-property: opacity;
  transition-duration: 0.25s;
}
.fade-enter-active {
  transition-delay: 0.25s;
}
.fade-enter,
.fade-leave-active {
  opacity: 0;
}
.text-center {
  text-align: center;
}
.uppercase {
  text-transform: uppercase;
}
.flex-uno {
  flex: 1;
}
.flex {
  display: flex;
}
.jc-center {
  justify-content: center;
}
.jc-space-around {
  justify-content: space-around;
}
.ai-center {
  align-items: center;
}
.text-right {
  text-align: right;
}
.text-capitalize {
  text-transform: capitalize;
}
.margin-bottom-10 {
  margin-bottom: 10px;
}
.fd-c {
  flex-direction: column;
}
.h-100 {
  height: 100%;
}
.cursor-pointer {
  cursor: pointer;
}
.text-left {
  text-align: left;
}
.color-white {
  color: #fff !important;
}
.f-wrap {
  flex-wrap: wrap;
}
.margin-top-10 {
  margin-top: 10px;
}
.margin-top-20 {
  margin-top: 20px;
}
.margin-top-30 {
  margin-top: 30px;
}
.margin-top-40 {
  margin-top: 40px;
}
.padding-10 {
  padding: 10px;
}
.margin-top-5 {
  margin-top: 5px;
}
.margin-right-5 {
  margin-right: 5px;
}
.italic {
  font-style: italic;
}
.padding-20 {
  padding: 20px;
}
.margin-10 {
  margin: 10px;
}
.good-transition {
  display: flex;
  justify-content: center;
  flex-direction: column;
  position: relative;
}
.good-transition >* {
  transition: all 0.5s;
  width: 100%;
}
.fade-smooth-enter,
.fade-smooth-leave-active {
  opacity: 0;
}
.fade-smooth-leave-active {
  position: absolute;
}
.flex-wrap {
  flex-wrap: wrap;
}
.capitalize {
  text-transform: capitalize;
}
.bold {
  font-weight: bold;
}
.margin-2 {
  margin: 2px;
}
.md-chip-mini {
  padding: 2px 5px;
  height: auto;
  font-size: 10px;
}
.margin-left-20 {
  margin-left: 20px;
}
.margin-0 {
  margin: 0px;
}
.info-message {
  color: #1736e0 !important;
  background-color: #ecefff !important;
  text-align: center;
  margin-top: 10px;
  margin-bottom: 10px;
  padding: 10px;
  font-size: 12px;
  font-weight: 700;
  border-radius: 6px;
}
.success-message {
  border: 1px solid #114e05;
  color: #114e05;
  background-color: #e3efe1;
  text-align: center;
  margin: 10px;
  padding: 10px;
}
.margin-top-0 {
  margin-top: 0px !important;
}
.margin-right-20 {
  margin-right: 20px;
}
.w-100 {
  width: 100vw;
}
.is-loading-full-size {
  position: absolute;
  width: 100%;
  height: 100%;
  background-color: rgba(30,30,30,0.5);
  top: 0;
  left: 0;
  border-radius: 1px;
  display: flex;
  justify-content: center;
  align-items: center;
}
.md-table.table-mini {
  font-size: 11px;
}
.md-table.table-mini .md-table-header .md-table-row .md-table-head .md-table-head-container {
  padding: 0px;
  height: 30px;
  text-align: center;
}
.md-table.table-mini .md-table-head-text {
  padding: 0px;
}
.md-table.table-mini .md-table-cell {
  height: 18px;
  font-weight: 700;
  color: #9a9a9a;
}
.md-table.table-mini .md-table-cell .md-table-cell-container {
  padding: 5px 0px 5px 0px;
}
.color-primary {
  color: #3f51b5;
}
.color-accent {
  color: #e91e63;
}
.card-list {
  box-shadow: 7px 12px 20px 0px #e0e0e0;
  padding: 10px 10px;
}
.vencido-pulso {
  margin-right: 10px;
  display: block;
  width: 22px;
  height: 22px;
  border-radius: 50%;
  background: #fff;
  cursor: pointer;
  box-shadow: 0 0 0 #e91e63;
  animation: pulse 1.3s infinite;
}
.vencido-pulso:hover {
  animation: none;
}
.width-150 {
  width: 150px;
}
.descripcion-con-codigo {
  position: relative;
}
.descripcion-con-codigo .codigo {
  font-size: 9px;
  color: #ccc;
  position: absolute;
  bottom: -11px;
}
.font-size-11 {
  font-size: 11px;
}
.padding-left-10 {
  padding-left: 10px;
}
.md-card.md-consultas {
  box-shadow: 7px 12px 20px 0px #e0e0e0;
  margin: 10px;
  border-radius: 8px;
  background-color: #fff;
}
.margin-10 {
  margin: 10px;
}
.position-relative {
  position: relative;
}
.success-message {
  color: #23d160;
  background-color: #e2ffef;
  text-align: center;
  margin-top: 10px;
  margin-bottom: 10px;
  padding: 10px;
  font-size: 12px;
  font-weight: 700;
  border-radius: 6px;
}
.info-message {
  color: #1736e0 !important;
  background-color: #ecefff !important;
  text-align: center;
  margin-top: 10px;
  margin-bottom: 10px;
  padding: 10px;
  font-size: 12px;
  font-weight: 700;
  border-radius: 6px;
}
.margin-top-0 {
  margin-top: 0px !important;
}
.danger-message {
  color: #e91e63;
  background-color: #ffe8f0;
  text-align: center;
  margin-top: 10px;
  margin-bottom: 10px;
  padding: 10px;
  font-size: 12px;
  font-weight: 700;
  border-radius: 6px;
}
.md-backdrop {
  background-color: rgba(22,51,210,0.16);
}
.md-sidenav .md-backdrop {
  background-color: rgba(22,51,210,0.16);
}
.md-table tbody .md-table-row {
  border-top: 0px;
}
.md-theme-default.md-button:not([disabled]).md-primary.md-raised,
.md-theme-default.md-button:not([disabled]).md-primary.md-fab {
  background-color: #1736e0 !important;
}
.md-theme-default.md-button:not([disabled]).md-accent.md-raised,
.md-theme-default.md-button:not([disabled]).md-accent.md-fab {
  background-color: #f70859 !important;
}
.md-theme-default.md-icon.md-primary {
  color: #1736e0 !important;
}
.md-theme-default.md-tabs.md-transparent>.md-tabs-navigation .md-tab-header.md-active,
.md-theme-default.md-tabs.md-transparent>.md-tabs-navigation .md-tab-header:focus {
  color: #1736e0 !important;
}
.md-theme-default.md-card.md-accent {
  background-color: #f70859 !important;
}
.md-theme-default.md-rating-bar.md-accent>.md-full-icon .md-icon {
  color: #f70859 !important;
}
.md-theme-default.md-checkbox.md-primary.md-checked .md-checkbox-container {
  background-color: #1736e0 !important;
  border-color: #1736e0 !important;
}
.md-theme-default.md-checkbox.md-checked .md-checkbox-container {
  background-color: #f70859 !important;
  border-color: #f70859 !important;
}
.md-theme-default.md-stepper .md-step-header.md-primary .md-step-icon,
.md-theme-default.md-stepper .md-step-header.md-primary .md-step-number,
.md-theme-default.md-stepper .md-step-header.md-active .md-step-icon,
.md-theme-default.md-stepper .md-step-header.md-active .md-step-number {
  background-color: #1736e0 !important;
}
.md-theme-default.md-input-container.md-input-focused label,
.md-theme-default.md-input-container.md-input-focused .md-icon:not(.md-icon-delete) {
  color: #1736e0 !important;
}
.md-theme-default.md-input-container.md-input-focused input,
.md-theme-default.md-input-container.md-input-focused textarea {
  color: #1736e0 !important;
}
.md-theme-default.md-input-container.md-input-focused:after {
  background-color: #1736e0 !important;
}
.md-theme-default.md-chip.md-primary {
  background-color: #1736e0 !important;
}
.md-theme-default.md-chip.md-accent {
  background-color: #f70859 !important;
}
.md-theme-default.md-select-content .md-menu-item.md-selected,
.md-theme-default.md-select-content .md-menu-item.md-checked {
  color: #1736e0 !important;
}
.md-theme-default.md-radio.md-primary.md-checked .md-radio-container {
  border-color: #1736e0 !important;
}
.md-theme-default.md-avatar.md-primary.md-avatar-icon {
  background-color: #1736e0 !important;
}
.md-stepper .md-steps-navigation .md-steps-navigation-container .md-divider {
  margin: 27px 0;
}
.color-primary {
  color: #1736e0;
}
.color-accent {
  color: #f70859;
}
.md-card.md-consultas {
  box-shadow: 1px 14px 20px 0px #c5c3c3;
  margin: 10px;
  border-radius: 8px;
  font-size: 12px;
  background-color: #fff;
}
.filtros-fixed {
  position: fixed;
  background-color: #fff;
  z-index: 20;
  width: 100%;
}
.md-button {
  font-size: 11px;
}
.md-stepper .md-steps-navigation {
  box-shadow: 7px 12px 20px 0px rgba(162,155,155,0.38);
}
.md-whiteframe-1dp {
  box-shadow: none;
}
.md-stepper .md-steps-navigation {
  z-index: 10;
  position: sticky;
  top: 0;
  background-color: #fff;
}
.md-step-actions {
  display: none;
}
.md-stepper .md-steps-navigation {
  overflow: auto;
  height: 54px;
  min-height: 54px;
}
.md-stepper .md-step-header {
  padding: 14px;
}
.md-stepper .md-steps-container .md-steps-wrapper .md-step .md-step-content {
  padding: 0px;
  line-height: 19px;
}
.padding-top-20 {
  padding-top: 20px;
}
.margin-5 {
  margin: 5px;
}
.md-speed-dial.md-direction-top [md-fab-trigger] ~ .md-button {
  margin-bottom: 10px;
}
.md-step-content {
  min-height: 426px;
  height: auto;
}
.md-dialog {
  border-radius: 12px;
  min-width: 348px;
  max-height: 90%;
}
.filters {
  position: sticky;
  top: 0;
  background-color: #fff;
  z-index: 5;
  padding: 12px;
  border-radius: 11px;
  box-shadow: 1px 1px 20px 7px rgba(0,0,0,0.14);
}
.md-dialog-content,
.md-dialog-content:first-child {
  padding: 15px;
  padding-bottom: 10px;
}
.card-seleccionable {
  padding: 12px;
  font-size: 14px;
  margin: 8px;
}
.md-body-2 {
  font-size: 13px;
}
.md-tabs .md-tab-header {
  font-size: 11px;
  padding: 0 5px;
}
.md-input-container label {
  font-size: 14px;
}
.m-p-t {
  margin-top: 20px;
  margin-bottom: 20px;
}
.padding-top-0 {
  padding-top: 0px;
}
.fd-row {
  flex-direction: row !important;
}
.md-stepper .md-steps-container .md-steps-wrapper {
  background-color: #fff;
}
.box-shadow-none {
  box-shadow: none !important;
}
input[type=number]::-webkit-inner-spin-button,
input[type=number]::-webkit-outer-spin-button {
  -webkit-appearance: none;
  margin: 0;
}
input[type=number] {
  -moz-appearance: textfield;
}
@-moz-keyframes pulse {
  0% {
    -moz-box-shadow: 0 0 0 0 #e91e63;
    box-shadow: 0 0 0 0 #e91e63;
  }
  70% {
    -moz-box-shadow: 0 0 0 10px rgba(233,30,99,0.61);
    box-shadow: 0 0 0 10px rgba(204,169,44,0);
  }
  100% {
    -moz-box-shadow: 0 0 0 0 rgba(204,169,44,0);
    box-shadow: 0 0 0 0 rgba(204,169,44,0);
  }
}
@-webkit-keyframes pulse {
  0% {
    -moz-box-shadow: 0 0 0 0 #e91e63;
    box-shadow: 0 0 0 0 #e91e63;
  }
  70% {
    -moz-box-shadow: 0 0 0 10px rgba(233,30,99,0.61);
    box-shadow: 0 0 0 10px rgba(204,169,44,0);
  }
  100% {
    -moz-box-shadow: 0 0 0 0 rgba(204,169,44,0);
    box-shadow: 0 0 0 0 rgba(204,169,44,0);
  }
}
@-o-keyframes pulse {
  0% {
    -moz-box-shadow: 0 0 0 0 #e91e63;
    box-shadow: 0 0 0 0 #e91e63;
  }
  70% {
    -moz-box-shadow: 0 0 0 10px rgba(233,30,99,0.61);
    box-shadow: 0 0 0 10px rgba(204,169,44,0);
  }
  100% {
    -moz-box-shadow: 0 0 0 0 rgba(204,169,44,0);
    box-shadow: 0 0 0 0 rgba(204,169,44,0);
  }
}
@keyframes pulse {
  0% {
    -moz-box-shadow: 0 0 0 0 #e91e63;
    box-shadow: 0 0 0 0 #e91e63;
  }
  70% {
    -moz-box-shadow: 0 0 0 10px rgba(233,30,99,0.61);
    box-shadow: 0 0 0 10px rgba(204,169,44,0);
  }
  100% {
    -moz-box-shadow: 0 0 0 0 rgba(204,169,44,0);
    box-shadow: 0 0 0 0 rgba(204,169,44,0);
  }
}

.flex {
  display: flex !important;
}

.text-align-justify {
  text-align: justify !important;
}

.text-align-last-end {
  text-align-last: end;
}

.text-align-center {
  text-align: center !important;
}

.text-align-right {
  text-align: right !important;
}

.text-align-left {
  text-align: left !important;
}

.absolute {
  position: absolute !important;
}
.relative {
  position: relative !important;
}

.margin-top-50 {
  margin-top: 50px !important;
}

.padding-15 {
  padding: 15px !important;
}

.padding-10 {
  padding: 10px !important;
}

.padding-5 {
  padding: 5px !important;
}

.font-weight-500 {
  font-weight: 500 !important;
}

.margin-5 {
  margin: 5px !important
}

.margin-right-5 {
  margin-right: 10px !important
}

// .el-input--medium .el-input__inner {
//   // height: 36px;
//   // line-height: 36px;
//   text-transform: uppercase;
// }

// .v-modal {
//   position: unset;
//   left: 0;
//   top: 0;
//   width: 100%;
//   height: 100%;
//   opacity: 0.5;
//   background: #000000;
// }

.z-index-2000 {
  z-index: 2000 !important;
}
</style>
