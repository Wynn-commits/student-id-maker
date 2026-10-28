<script setup lang="ts">
import { usePortfolio } from '@/composables/usePortfolio'

const { skillsByCategory } = usePortfolio()

const categoryLabels = {
  frontend: 'Frontend',
  backend: 'Backend',
  tools: 'Tools',
  uncategorized: 'Core',
} as const

type CategoryLabel = keyof typeof categoryLabels
</script>

<template>
  <section id="skills" class="section">
    <h3 class="section__title">Skills</h3>

    <div
      v-for="(items, category) in skillsByCategory"
      :key="category"
      class="skills-group"
    >
      <h4 class="skills-group__label">
        {{ categoryLabels[category as CategoryLabel] ?? category }}
      </h4>
      <div class="skills">
        <span v-for="skill in items" :key="skill.name" class="skill-chip">
          {{ skill.name }}
        </span>
      </div>
    </div>
  </section>
</template>

<style scoped>
.skills-group {
  margin-bottom: 1rem;
}

.skills-group__label {
  margin-bottom: 0.5rem;
  color: #555555;
  font-size: 0.9rem;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.skills {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.skill-chip {
  background: #ffffff;
  border: 1px solid #e5e7eb;
  padding: 8px 14px;
  border-radius: 20px;
  font-size: 0.9rem;
  transition: 0.2s ease;
}

.skill-chip:hover {
  background: #2563eb;
  color: #fff;
  border-color: #2563eb;
}
</style>
