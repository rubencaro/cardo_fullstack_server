<template>
  <div>
    <b-form-input @keyup.enter="addMessage"/>
    <div v-for="message in messages">
      <p>{{ message }}</p>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'

export default {
  name: 'Messages',
  computed: { ...mapGetters(['messages']) },
  methods: {
    // ...mapActions(['addMessage']),
    addMessage(e) {
      const text = e.target.value
      if (text.trim()) {
        this.$store.dispatch('addMessage', text)
        this.$store.dispatch('addLogLine', text)
        e.target.value = ''
      }
    }
  }
}
</script>

<style>

</style>