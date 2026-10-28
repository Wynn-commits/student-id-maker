<template>
  <div class="app-shell">
    <header class="app-header">
      <h1>Attendance admin</h1>
      <div v-if="auth.isAuthenticated()" class="header-right">
        <span class="admin-name">{{ auth.state.admin?.full_name || auth.state.admin?.username }}</span>
        <button class="btn btn-ghost btn-ghost-invert" @click="handleLogout">Log out</button>
      </div>
    </header>
    <main class="app-main">
      <router-view />
    </main>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router';
import auth from './services/auth';

const router = useRouter();

function handleLogout() {
  auth.logout();
  router.push({ name: 'login' });
}
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
  padding: 1.1rem 2rem;
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.app-header h1 {
  margin: 0;
  font-size: 1.25rem;
  font-weight: 600;
}
.header-right {
  display: flex;
  align-items: center;
  gap: 1rem;
}
.admin-name {
  font-size: 0.9rem;
  opacity: 0.9;
}
.app-main {
  flex: 1;
  padding: 2rem;
}
</style>
