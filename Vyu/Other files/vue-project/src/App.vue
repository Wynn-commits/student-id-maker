<script setup lang="ts">
import AppFooter from '@/components/AppFooter.vue';
import AppHeader from './components/AppHeader.vue';
</script>

<template>
  <div class="app">
    <AppHeader/>

    <main class="app__main">
      <router-view />
    </main>

    <AppFooter />
  </div>
</template>

<style scoped>
.app {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.app__main {
  flex: 1;
}
</style>
