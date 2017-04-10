<template>
  <div id="log">
    <ul v-for="line in logs">
      <li>{{ line }}</li>
    </ul>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  name: 'Log',
  computed: { ...mapGetters(['logs']) }
}
</script>

<style>

</style>