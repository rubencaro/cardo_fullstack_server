import axios from 'axios'

export default store => {
  // called when the store is initialized
  store.subscribe((mutation, state) => {
    // The mutation comes in the format of { type, payload }.
    if (mutation.type == "addMessage") {
      console.log(mutation)

      axios.post("/entry", { "text": mutation.payload })
        .catch(error => { console.error(error) })
    }
  })
}