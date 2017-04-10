<template>
  <div id="log">
    <ul v-for="line in lines">
      <li>{{ line }}</li>
    </ul>
  </div>
</template>

<script>
export default {
  name: 'Log',
  data: () => {
    return {
      lines: ["Logger ready."]
    }
  }
}
</script>

<style>
</style>