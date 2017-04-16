<template>
  <div class="container-fluid">
    <h1>Cardo</h1>
    <alerts></alerts>
    <cards></cards>
    <!--<messages></messages>-->
    <log></log>
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import Log from './components/Log'
import Messages from './components/Messages'
import Cards from './components/Cards'
import Alerts from './components/Alerts'

export default {
  name: 'Cardo',
  components: {
    'log': Log,
    'alerts': Alerts,
    // 'messages': Messages,
    'cards': Cards
  }
}
</script>

<style>

</style>
