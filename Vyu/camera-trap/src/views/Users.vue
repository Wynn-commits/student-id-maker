<script setup>
import { users } from '../data.js'
</script>
<template>
  <h1>Users</h1><p style="color:var(--mut)">Authorized users such as the research team and conservation personnel.</p>
  <div class="wrap"><table class="tbl"><thead><tr><th>Username</th><th>Role</th></tr></thead><tbody><tr v-for="u in users" :key="u[0]"><td>{{ u[0] }}</td><td>{{ u[1] }}</td></tr></tbody></table></div>
</template>
