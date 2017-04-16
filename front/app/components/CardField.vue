<template>
  <p>
    <b>{{field}}</b>: {{value}}
    <button class="close"
            @click="removeField">
      <span aria-hidden="true">&times;</span>
    </button>
  </p>
</template>

<script>
export default {
  name: "CardField",
  props: ['value', 'field', 'card_id'],
  methods: {
    removeField() {
      this.$store.dispatch('cards_removeField', {
        field: this.field,
        card_id: this.card_id
      })
    }
  }
}
</script>

<style>

</style>