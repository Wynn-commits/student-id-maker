<template>
  <div class="card menu-card">
    <h2>Select action</h2>
    <p class="subtitle">Choose what you'd like to do</p>
    <div class="menu-actions">
      <RouterLink to="/register" class="btn btn-primary">Register a Student QR Code</RouterLink>
      <RouterLink to="/scan" class="btn btn-accent">Scan QR / enter ID</RouterLink>
    </div>
  </div>
</template>

<script setup>
import { RouterLink } from 'vue-router';
</script>

<style scoped>
.menu-card {
  width: 100%;
  max-width: 420px;
  text-align: center;
}
.subtitle {
  color: var(--color-text-muted);
  margin-top: -0.5rem;
  margin-bottom: 1.5rem;
}
.menu-actions {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}
</style>
