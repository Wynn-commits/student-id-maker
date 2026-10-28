<script setup lang="ts">
const currentYear = new Date().getFullYear()
</script>

<template>
  <footer class="footer">
    <p class="footer__text">
      &copy; {{ currentYear }} Erwin Orquillano. All rights reserved.
    </p>
  </footer>
</template>

<style scoped>
.footer {
  background: #000000;
  color: #ffffff;
  text-align: center;
  padding: 1rem;
  margin-top: auto;
}

.footer__text {
  margin: 0;
}
</style>
