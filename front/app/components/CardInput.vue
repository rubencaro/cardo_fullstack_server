<template>
  <div>
    <b-form-select :options="options"
                   v-model="field">
    </b-form-select>
    <b-form-input v-model="value"></b-form-input>
    <b-btn @click="addField">Add</b-btn>
  </div>
</template>

<script>
export default {
  name: "CardInput",
  methods: {
    addField() {
      this.$store.dispatch('addFieldToCard', {
        field: this.field,
        value: this.value,
        card_id: this.card.id
      })
    }
  },
  props: ['card'],
  data() {  //local data
    return {
      field: null,
      value: "",
      options: [
        {
          text: 'Field name',
          value: null
        },
        {
          text: 'Name',
          value: 'name'
        }, {
          text: 'Description',
          value: 'description'
        }, {
          text: 'Priority',
          value: 'priority'
        }
      ]
    }
  }
}
</script>

<style>

</style>