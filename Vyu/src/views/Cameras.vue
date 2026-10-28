<script setup>
import { ref } from 'vue'
import { cameras } from '../data.js'
const adding = ref(false), loc = ref(''), upd = ref('')
function add() {
  if (!loc.value.trim()) return
  cameras.push({ id: 'CT-' + String(cameras.length + 1).padStart(2, '0'), loc: loc.value.trim(), ok: false, bat: 100, up: 'No upload yet' })
  loc.value = ''; adding.value = false
}
const refresh = () => (upd.value = 'Status refreshed at ' + new Date().toLocaleTimeString())
</script>
<template>
  <h1>Camera Traps</h1>
  <div class="row"><button class="btn" @click="adding = !adding">Add camera trap</button><button class="btn o" @click="refresh">Refresh status</button><span v-if="upd" role="status" style="color:var(--mut)">{{ upd }}</span></div>
  <p v-if="adding" class="row"><input class="in" v-model="loc" placeholder="Location (e.g. Site D)" aria-label="Location" @keyup.enter="add"><button class="btn" @click="add">Save</button></p>
  <div class="wrap" style="margin-top:18px"><table class="tbl"><thead><tr><th>Camera ID</th><th>Location</th><th>Status</th><th>Battery</th><th>Last upload</th></tr></thead>
    <tbody><tr v-for="c in cameras" :key="c.id"><td>{{ c.id }}</td><td>{{ c.loc }}</td><td><span class="pill" :class="{ off: !c.ok }">{{ c.ok ? 'Active' : 'Offline' }}</span></td><td>{{ c.bat }}%</td><td>{{ c.up }}</td></tr></tbody></table></div>
</template>
