<template>
  <div>
    <p>
      <b-btn @click="clicked"
             variant="secondary"
             size="sm">+</b-btn>
      <p>{{ card.name }}</p>
    </p>

    <p v-if="visible">
      <card-field-list :card="card"></card-field-list>
      <card-input :card="card"></card-input>
    </p>
  </div>
</template>

<script>
import CardFieldList from './CardFieldList'
import CardInput from './CardInput'

export default {
  name: "Card",
  props: ['card'],
  methods: {
    clicked(e) {
      this.visible = !this.visible
      if (this.visible) { e.target.textContent = '-' }
      else { e.target.textContent = '+' }
    }
  },
  components: {
    'card-field-list': CardFieldList,
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