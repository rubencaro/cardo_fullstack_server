<template>
  <div class="row">
    <b-form-select class="col"
                   :options="cards_field_names()"
                   v-model="field">
    </b-form-select>
    <b-form-input class="col"
                  placeholder="Enter value"
                  v-model="value"
                  @keyup.enter="submitField"></b-form-input>
      <b-btn class="col-sm" size="sm"
             @click="submitField">Submit</b-btn>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  name: "CardInput",
  methods: {
    submitField() {
      this.$store.dispatch('cards_upsertFieldOnCard', {
        field: this.field,
        value: this.value,
        card_id: this.card.id
      })
    },
    ...mapGetters(['cards_field_names'])
  },
  props: ['card'],
  data() {  //local data
    return {
      field: null,
      value: ""
    }
  }
}
</script>

<style>

</style>