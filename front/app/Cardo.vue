<template>
  <div class="container">
    <h1>Cardo</h1>
    <messages></messages>
    <log></log>
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import Log from './components/Log'
import Messages from './components/Messages'

export default {
  name: 'Cardo',
  components: {
    'log': Log,
    'messages': Messages
  }
}
</script>

<style>

</style>
