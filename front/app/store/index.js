import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

const state = {
  messages: ['some', 'messages'],
  logs: ['Logger is ready']
}

const getters = {
  messages: state => {
    return state.messages
  },
  logs: state => {
    return state.logs
  }
}

export default new Vuex.Store({
  state,
  // actions,
  getters,
  // modules: {
  //   card
  // }
})