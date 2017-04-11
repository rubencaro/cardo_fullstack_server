export default store => {
  const sse = new EventSource("/sse")
  sse.onmessage = e => {
    console.log("Receiving data")
    store.dispatch('receiveData', JSON.parse(e.data).text)
  }
  sse.onerror = () => {
    console.log("EventSource failed.")
  }
  sse.onopen = () => {
    console.log("EventSource opened.")
  }
}