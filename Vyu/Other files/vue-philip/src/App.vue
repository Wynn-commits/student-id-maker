<script setup lang="ts">
import Header from './components/AppHeader.vue'
import Hero from './components/AppHero.vue'
import About from './components/AppAbout.vue'
import Skills from './components/AppSkills.vue'
import Contact from './components/AppContact.vue'
import Footer from './components/AppFooter.vue'

</script>

<template>
  <div id="app">
    <Header />

    <main>
      <Hero />
      <About />
      <Skills />
      <Contact />
    </main>

    <Footer />
  </div>
</template>

<style scoped>
#app {
  font-family: Arial, sans-serif;
  margin: 0;
  padding: 0;
}
main {
  padding: 2rem;
}
</style>