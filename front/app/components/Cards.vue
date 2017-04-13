<template>
  <div>
    <ul>
      <li v-for="card in cards_cards">
        <card :card="card"></card>
      </li>
    </ul>
  </div>
</template>

<script>
import Card from './Card'
import { mapGetters } from 'vuex'

export default {
  name: "Cards",
  computed: { ...mapGetters(['cards_cards']) },
  components: {
    'card': Card
  }
}
</script>

<style>

</style>