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

const mutations = {
  addMessage(state, message) {
    state.messages.push(message)
  },
  addLogLine(state, text) {
    state.logs.push(text)
  }
}

const actions = {
  addMessage(context, text) {
    context.commit('addMessage', text)
  },
  addLogLine(context, text) {
    const formatted = `${Date.now()}: ${text}`
    context.commit('addLogLine', formatted)
  }
}

export default new Vuex.Store({
  state,
  actions,
  getters,
  mutations,
  // modules: {
  //   card
  // }
  strict: process.env.NODE_ENV !== 'production'
})