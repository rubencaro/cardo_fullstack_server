import Vue from 'vue'

// initial state
const state = {
  alerts: {
    list: [{
      level: "danger",
      msg: "0: Field 'id' cannot be deleted."
    }]
  }
}

// getters
const getters = {
  alerts_list: state => {
    return state.alerts.list
  }
}

// actions
const actions = {
  alerts_addError(context, data) {
    context.commit('alerts_addAlert', { level: 'danger', ...data })
  },
  alerts_removeAlert(context, data) {
    context.commit('alerts_removeAlert', data)
  }
}

// mutations
const mutations = {
  alerts_addAlert(state, data) {
    state.alerts.list.push(data)
  },
  alerts_removeAlert(state, item) {
    const index = state.alerts.list.indexOf(item)
    console.log(state.alerts.list.map(a => { return a.msg }).join())
    console.log(index)
    var removed = []
    if (index !== -1) removed = state.alerts.list.splice(index, 1)
    console.log(state.alerts.list.map(a => { return a.msg }).join())
    console.log(removed[0].msg)
  }
}

export default {
  state,
  getters,
  actions,
  mutations
}