<template>
  <div>
    <p>
      <b-btn @click="clicked"
             variant="primary">Toggle Collapse</b-btn>
      <p>{{ card.name }}</p>
    </p>

    <p v-if="visible">
      <ul>
        <li v-for="(value, key, index) in card">
          <card-field :value="value"
                      :field="key"></card-field>
        </li>
      </ul>
      <card-input :card="card"></card-input>
    </p>
  </div>
</template>

<script>
import CardField from './CardField'
import CardInput from './CardInput'

export default {
  name: "Card",
  props: ['card'],
  methods: {
    clicked() {
      this.visible = !this.visible
    }
  },
  components: {
    'card-field': CardField,
    'card-input': CardInput
  },
  data() {  //local data
    return {
      visible: false
    }
  }
}
</script>

<style>

</style>