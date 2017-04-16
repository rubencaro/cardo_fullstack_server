<template>
  <ul>
    <li v-for="(value, field) in card">
      <card-field :value="value"
                  :field="field"
                  :card_id="card.id"></card-field>
    </li>
  </ul>
</template>

<script>
import CardField from './CardField'

export default {
  name: "CardFieldList",
  components: {
    'card-field': CardField
  },
  props: ['card']
}
</script>

<style>

</style>