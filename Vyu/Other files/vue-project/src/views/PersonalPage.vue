<script setup lang="ts">
import HeroSection from '@/components/HeroSection.vue'
import SkillsSection from '@/components/SkillsSection.vue'
import ContactSection from '@/components/ContactSection.vue'
</script>

<template>
  <main class="page">
    <HeroSection />
    <SkillsSection />
    <ContactSection />
  </main>
</template>

<style scoped>
.page {
  max-width: 1000px;
  margin: 0 auto;
  padding: 2rem;
}
</style>
