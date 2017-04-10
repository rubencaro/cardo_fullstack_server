import Vue from 'vue'
// import Vuex from 'vuex'
// import VueRouter from 'vue-router'

// Vue.use(Vuex)
// Vue.use(VueRouter)

import Cardo from './Cardo'

const app = new Vue({
  el: '#app',
  render: (h) => h(Cardo),
  components: {
    'cardo': Cardo
  }
})
