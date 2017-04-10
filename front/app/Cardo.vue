<template>
  <div class="container">
    <h1>Cardo</h1>
    <log></log>
  </div>
</template>

<script>
  import Log from './components/Log'

  export default {
    name: 'Cardo',
    components: {
      'log': Log
    },
    data: () => {
      return {
        message: "How are you?"
      }
    }
  }
</script>

<style>
</style>
