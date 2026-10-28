<template>
  <div class="app">
    <AppHeader />

    <main>
      <HomeView />
    </main>

    <AppFooter />
  </div>
</template>

<script setup lang="ts">
import AppHeader from './components/AppHeader.vue'
import HomeView from './views/HomeView.vue'
import AppFooter from './components/AppFooter.vue'
</script>

<style>
*{
  margin:0;
  padding:0;
  box-sizing:border-box;
}

body{
  font-family:Arial, Helvetica, sans-serif;
  background:#f5f5f5;
}

#app{
  display:flex;
  justify-content:center;
}

.app{
  width:100%;
  max-width:1200px;
  min-height:100vh;
  display:flex;
  flex-direction:column;
}

main{
  flex:1;
}
</style>