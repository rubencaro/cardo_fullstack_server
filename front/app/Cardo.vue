<template>
  <div class="container">
    <h1>Cardo</h1>
    <div v-for="message in messages">
      <p>{{ message }}</p>
    </div>
    <log></log>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import Log from './components/Log'

export default {
  name: 'Cardo',
  components: {
    'log': Log
  },
  computed: {...mapGetters(['messages'])}
}
</script>

<style>

</style>
