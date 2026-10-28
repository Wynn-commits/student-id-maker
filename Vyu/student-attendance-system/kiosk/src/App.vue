<template>
  <div class="app-shell">
    <header class="app-header">
      <h1>Student Attendance Monitoring System</h1>
    </header>
    <main class="app-main">
      <router-view />
    </main>
  </div>
</template>

<script setup>
</script>

<style scoped>
.app-shell {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}
.app-header {
  background: var(--color-primary);
  color: #fff;
  padding: 1.25rem 2rem;
}
.app-header h1 {
  margin: 0;
  font-size: 1.25rem;
  font-weight: 600;
}
.app-main {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 2rem;
}
</style>
