<script setup lang="ts">
import { usePortfolio } from '@/composables/usePortfolio'

const { contact } = usePortfolio()
</script>

<template>
  <section id="contact" class="section">
    <h3 class="section__title">Contact</h3>

    <ul class="contact-list">
      <li>
        <span class="contact-list__label">Email</span>
        <a :href="`mailto:${contact.email}`">{{ contact.email }}</a>
      </li>
      <li>
        <span class="contact-list__label">GitHub</span>
        <a :href="contact.github" target="_blank" rel="noopener noreferrer">
          {{ contact.github }}
        </a>
      </li>
      <li>
        <span class="contact-list__label">LinkedIn</span>
        <a :href="contact.linkedin" target="_blank" rel="noopener noreferrer">
          {{ contact.linkedin }}
        </a>
      </li>
    </ul>
  </section>
</template>

<style scoped>
.contact-list {
  list-style: none;
  padding: 0;
}

.contact-list li {
  display: flex;
  gap: 0.5rem;
  margin-bottom: 0.5rem;
}

.contact-list__label {
  min-width: 90px;
  color: #555555;
  font-weight: 600;
}

.contact-list a {
  color: #2563eb;
  text-decoration: none;
  word-break: break-all;
}

.contact-list a:hover {
  text-decoration: underline;
}
</style>
