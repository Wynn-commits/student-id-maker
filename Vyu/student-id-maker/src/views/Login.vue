<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { DEMO_ACCOUNTS, login, session } from '../store'
import IdCard from '../components/IdCard.vue'
const router = useRouter(), u = ref(''), p = ref(''), err = ref('')
const demo = { last: 'Dela Cruz', first: 'Juan', middle: 'P.', idNo: '2026-0000', type: 'Student', program: 'BS Information Technology', photo: '' }
function go() {
  if (!login(u.value, p.value)) { err.value = 'Username or password is incorrect. Check both and try again.'; return }
  router.push(session.user.role === 'student' ? '/my-id' : '/dashboard')
}
</script>

<template>
  <main class="login">
    <section class="intro">
      <div class="demo"><IdCard :r="demo" /></div>
      <div>
        <h1>University ID Maker System</h1>
        <p>Central Philippines State University, San Carlos Campus. Submit your details, track your ID application, and get a print-ready card.</p>
      </div>
    </section>
    <form class="panel" @submit.prevent="go">
      <h2>Sign in</h2>
      <label>Username<input v-model="u" autocomplete="username" required /></label>
      <label>Password<input v-model="p" type="password" autocomplete="current-password" required /></label>
      <p v-if="err" class="err">{{ err }}</p>
      <button class="btn primary">Sign in</button>
      <section class="demo-credentials" aria-labelledby="demo-credentials-title">
        <h3 id="demo-credentials-title">Demo account credentials</h3>
        <div class="demo-accounts">
          <div v-for="account in DEMO_ACCOUNTS" :key="account.username" class="demo-account">
            <strong>{{ account.label }}</strong>
            <p>Username: <code>{{ account.username }}</code></p>
            <p>Password: <code>{{ account.password }}</code></p>
          </div>
        </div>
      </section>
    </form>
  </main>
</template>
