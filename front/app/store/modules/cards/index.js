// initial state
const state = {
  cards: {
    "1": { "name": "asdf", "id": "1" },
    "2": { "name": "asdf2", "id": "2" }
  }
}

// getters
const getters = {
  cards: state => {
    return state.cards
  },
  card: (state) => (id) => {
    return state.cards[id]
  }
}

// actions
const actions = {
  addCard(context, card) {
    context.commit('addCard', card)
  },
  addFieldToCard(context, payload) {
    context.commit('upsertFieldOnCard', payload)
  }
}

// mutations
const mutations = {
  addCard(state, card) {
    state.cards.push(card)
  },
  upsertFieldOnCard(state, { field, value, card_id }) {
    state.cards[card_id][field] = value
  }
}

export default {
  state,
  getters,
  actions,
  mutations
}