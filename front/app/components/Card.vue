<template>
  <div>
    <p>
      <b-btn @click="clicked"
             variant="primary">Toggle Collapse</b-btn>
    </p>

    <p v-if="visible">
      <b-form-input :rows="rows"
                    textarea></b-form-input>
    </p>
  </div>
</template>

<script>
export default {
  name: "Card",
  data() {  //local data
    return {
      rows: 5,
      visible: false
    }
  },
  methods: {
    clicked() {
      this.visible = !this.visible
    }
  }
}
</script>

<style>

</style>