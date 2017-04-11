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

const outboundData = store => {
  // called when the store is initialized
  store.subscribe((mutation, state) => {
    // called after every mutation.
    // The mutation comes in the format of { type, payload }.
    if (mutation.type == "addMessage") {
      console.log(mutation)
      fetch("/entry", {
        "method": "POST",
        "headers": { "content-type": "application/json" },
        "body": JSON.stringify(mutation.payload)
      });
    }
  })
}

const inboundData = store => {
  const sse = new EventSource("/sse")
  sse.onmessage = e => {
    console.log("Receiving data")
    store.dispatch('receiveData', JSON.parse(e.data)._json)
  }
  sse.onerror = () => {
    console.log("EventSource failed.")
  }
  sse.onopen = () => {
    console.log("EventSource opened.")
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
  plugins: [outboundData, inboundData],
  strict: process.env.NODE_ENV !== 'production'
})