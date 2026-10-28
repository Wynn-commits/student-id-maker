<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { auth } from '../data.js'
const router = useRouter(), user = ref('researcher01'), pass = ref(''), err = ref('')
function go() {
  if (!user.value.trim() || !pass.value) { err.value = 'Enter your username and password.'; return }
  auth.user = user.value.trim() === 'researcher01' ? 'Admin' : user.value.trim()
  router.push('/system')
}
</script>
<template>
  <header class="bar"><b>IoT and AI-Based Camera Trap Monitoring System</b><router-link to="/">Proposal</router-link></header>
  <main class="card login" style="background:#fff">
    <h1 style="text-align:center;margin:0">Sign in</h1><p style="text-align:center;color:var(--mut);margin:4px 0 0">Authorized personnel only</p>
    <label for="u">Username</label><input id="u" class="in" v-model="user" autocomplete="username">
    <label for="p">Password</label><input id="p" class="in" type="password" v-model="pass" autocomplete="current-password" @keyup.enter="go">
    <p v-if="err" role="alert" style="color:var(--red)">{{ err }}</p>
    <p><button class="btn" @click="go">Sign in</button></p>
    <p style="color:var(--mut);font-size:.8rem;margin:0">Demo build: any non-empty password signs you in. Real authentication will come from the Node.js/Express REST API.</p>
  </main>
</template>
