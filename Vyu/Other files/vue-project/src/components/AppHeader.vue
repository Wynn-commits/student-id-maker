<script setup lang="ts">
import { usePortfolio } from '@/composables/usePortfolio'

const { name } = usePortfolio()

const navLinks = [
  { label: 'About', href: '#about' },
  { label: 'Skills', href: '#skills' },
  { label: 'Contact', href: '#contact' },
]
</script>

<template>
  <header class="header">
    <div class="container">
      <h1 class="header__brand">{{ name }}</h1>
      <nav class="header__nav" aria-label="Primary navigation">
        <a
          v-for="link in navLinks"
          :key="link.href"
          :href="link.href"
          class="header__link"
        >
          {{ link.label }}
        </a>
      </nav>
    </div>
  </header>
</template>

<style scoped>
.header {
  background: #000000;
  color: #ffffff;
  padding: 1rem 2rem;
}

.container {
  max-width: 1000px;
  margin: 0 auto;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header__nav {
  display: flex;
  gap: 1rem;
}

.header__link {
  color: #ffffff;
  text-decoration: none;
  transition: 0.2s ease;
}

.header__link:hover {
  text-decoration: underline;
}
</style>
