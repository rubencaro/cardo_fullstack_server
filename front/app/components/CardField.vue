<template>
  <p>
    <b>{{field}}</b>: {{value}}
  </p>
</template>

<script>
export default {
  name: "CardField",
  props: ['value', 'field']
}
</script>

<style>

</style>