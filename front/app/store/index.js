import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

const state = {
  messages: [],
  logs: []
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
  checkinMessage(state, message) {
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
  },
  receiveData(context, data) {
    console.log(`Received: ${data}`)
    context.commit('checkinMessage', data)
    context.dispatch('addLogLine', data)
  }
}

import inbound from './inbound'
import outbound from './outbound'

import cards from './modules/cards'
import alerts from './modules/alerts'

export default new Vuex.Store({
  state,
  actions,
  getters,
  mutations,
  modules: {
    cards,
    alerts
  },
  plugins: [outbound, inbound],
  strict: process.env.NODE_ENV !== 'production'
})