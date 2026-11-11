<script setup>
import { useRoute, useRouter } from 'vue-router'
import { session, logout } from './store'
const route = useRoute(), router = useRouter()
const out = () => { logout(); router.push('/login') }
</script>

<template>
  <div v-if="session.user" class="shell">
    <nav class="side">
      <b class="brand">ID Maker</b>
      <small>CPSU San Carlos Campus</small>
      <router-link v-if="session.user.role === 'student'" to="/my-id">My ID application</router-link>
      <template v-else>
        <router-link to="/dashboard">Dashboard</router-link>
        <router-link to="/records">ID records</router-link>
        <router-link to="/print">Print queue</router-link>
      </template>
      <div class="who">{{ session.user.name }}<small>{{ session.user.role }}</small><button @click="out">Sign out</button></div>
    </nav>
    <main class="main"><router-view /></main>
  </div>
  <router-view v-else-if="route.path === '/login'" />
</template>
