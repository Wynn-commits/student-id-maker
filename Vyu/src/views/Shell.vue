<script setup>
import { useRouter } from 'vue-router'
import { auth } from '../data.js'
const router = useRouter()
const out = () => { auth.user = null; router.push('/login') }
</script>
<template>
  <header class="bar"><b>IoT and AI-Based Camera Trap Monitoring System</b><span>{{ auth.user }} | <button @click="out">Sign out</button></span></header>
  <div class="layout"><nav class="side" aria-label="Main">
    <router-link to="/system/dashboard">Dashboard</router-link><router-link to="/system/profiles">Monkey Profiles</router-link>
    <router-link to="/system/review">Sighting Review</router-link><router-link to="/system/cameras">Camera Traps</router-link><router-link to="/system/users">Users</router-link></nav>
    <main class="main"><router-view /><p class="note">Sample data</p></main></div>
</template>
