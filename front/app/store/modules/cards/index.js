import Vue from 'vue'

// initial state
const state = {
  cards: {
    cards: {
      "1": { "name": "asdf", "id": "1" },
      "2": { "name": "asdf2", "id": "2" }
    },
    field_names: [
      {
        text: 'Select field name',
        value: null
      },
      {
        text: 'Name',
        value: 'name'
      },
      {
        text: 'Description',
        value: 'description'
      },
      {
        text: 'ID',
        value: 'id'
      },
      {
        text: 'Priority',
        value: 'priority'
      }
    ]
  }
}

// getters
const getters = {
  cards_cards: state => {
    return state.cards.cards
  },
  cards_filled_field_names: (state, getters) => {
    return getters.cards_field_names.filter(
      f => { return f.value != null && f.value.length > 0 }
    )
  },
  cards_field_names: state => {
    return state.cards.field_names
  },
  cards_card: (state) => (id) => {
    return state.cards.cards[id]
  }
}

// actions
const actions = {
  cards_addCard(context, card) {
    context.commit('cards_addCard', card)
  },
  cards_removeField(context, payload) {
    if (payload.field == "id") {
      context.dispatch('alerts_addError', { msg: `${Date.now()} Field 'id' cannot be deleted.` })
    }
    else {
      context.commit('cards_removeField', payload)
    }
  },
  cards_upsertFieldOnCard(context, payload) {
    context.commit('cards_upsertFieldOnCard', payload)
  }
}

// mutations
const mutations = {
  cards_addCard(state, card) {
    state.cards.cards.push(card)
  },
  cards_upsertFieldOnCard(state, { field, value, card_id }) {
    // needed to keep newly created fields reactive
    // see https://vuejs.org/v2/guide/reactivity.html
    Vue.set(state.cards.cards[card_id], field, value)
  },
  cards_removeField(state, { field, card_id }) {
    Vue.delete(state.cards.cards[card_id], field)
  }
}

export default {
  state,
  getters,
  actions,
  mutations
}