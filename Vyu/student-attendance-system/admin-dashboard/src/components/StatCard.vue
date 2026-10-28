<template>
  <div class="stat-card" :class="variant">
    <p class="stat-label">{{ label }}</p>
    <p class="stat-value">{{ value }}</p>
  </div>
</template>

<script setup>
defineProps({
  label: { type: String, required: true },
  value: { type: [String, Number], required: true },
  variant: { type: String, default: 'neutral' },
});
</script>

<style scoped>
.stat-card {
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius);
  padding: 1rem 1.25rem;
}
.stat-label {
  margin: 0 0 0.35rem;
  font-size: 0.8rem;
  color: var(--color-text-muted);
}
.stat-value {
  margin: 0;
  font-size: 1.5rem;
  font-weight: 600;
  color: var(--color-text);
}
.stat-card.success {
  background: rgba(61, 139, 125, 0.1);
}
.stat-card.success .stat-label,
.stat-card.success .stat-value {
  color: var(--color-accent);
}
.stat-card.warning {
  background: rgba(198, 138, 30, 0.1);
}
.stat-card.warning .stat-label,
.stat-card.warning .stat-value {
  color: var(--color-warning);
}
.stat-card.danger {
  background: rgba(192, 57, 43, 0.1);
}
.stat-card.danger .stat-label,
.stat-card.danger .stat-value {
  color: var(--color-danger);
}
</style>
