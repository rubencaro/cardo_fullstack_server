import Vue from 'vue'
import store from './store'

import BootstrapVue from 'bootstrap-vue'
Vue.use(BootstrapVue)

// import VueRouter from 'vue-router'

// Vue.use(VueRouter)

import Cardo from './Cardo'

const app = new Vue({
  el: '#app',
  store,
  render: (h) => h(Cardo),
  components: {
    'cardo': Cardo
  }
})
