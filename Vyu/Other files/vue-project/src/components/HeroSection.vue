<script setup lang="ts">
import { usePortfolio } from '@/composables/usePortfolio'

const { name, role, tagline, image, imageAlt } = usePortfolio()
</script>

<template>
  <section id="about" class="hero">
    <img
      :src="image"
      :alt="imageAlt"
      class="profile-image"
      width="200"
      height="250"
      loading="lazy"
      decoding="async"
    />

    <div class="hero__content">
      <h2>Hello, I am {{ name }}</h2>
      <p class="hero__role">{{ role }}</p>
      <p class="hero__tagline">{{ tagline }}</p>
      <a
        href="/resume.pdf"
        class="btn btn--primary"
        download
        aria-label="Download Erwin's resume"
      >
        Download Resume
      </a>
    </div>
  </section>
</template>

<style scoped>
.hero {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  padding: 3rem 1rem;
  gap: 1rem;
}

.profile-image {
  width: 200px;
  height: 250px;
  border-radius: 50%;
  object-fit: contain;
  margin-bottom: 0.5rem;
}

.hero__role {
  color: #2563eb;
  font-weight: 600;
  letter-spacing: 0.5px;
  text-transform: uppercase;
}

.hero__tagline {
  max-width: 650px;
  margin: 0 auto;
  color: #555555;
}
p{
  color:black;
}
</style>
