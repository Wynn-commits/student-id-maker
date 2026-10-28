<script setup>
import { ref, computed } from 'vue'
import { profiles, cameras } from '../data.js'
const q = ref(''), cam = ref(''), sel = ref(null)
const list = computed(() => profiles.filter((p) => p.id.toLowerCase().includes(q.value.trim().toLowerCase()) && (!cam.value || p.last === cam.value)))
function exportList() {
  const csv = ['Individual,Sightings,Last seen', ...list.value.map((p) => `${p.id},${p.sightings},${p.last}`)].join('\n')
  const a = Object.assign(document.createElement('a'), { href: URL.createObjectURL(new Blob([csv], { type: 'text/csv' })), download: 'monkey-profiles.csv' })
  a.click(); URL.revokeObjectURL(a.href)
}
</script>
<template>
  <h1>Monkey Profiles</h1>
  <div class="row"><input class="in" style="flex:1;min-width:180px" v-model="q" placeholder="Search individual ID" aria-label="Search individual ID">
    <select class="in" v-model="cam" aria-label="Camera"><option value="">All cameras</option><option v-for="c in cameras" :key="c.id">{{ c.id }}</option></select>
    <button class="btn" @click="exportList">Export list</button></div>
  <p v-if="sel" class="card" role="status"><b>{{ sel.id }}</b> — {{ sel.sightings }} sightings, last seen at {{ sel.last }}. <button class="btn o" @click="sel = null">Close</button></p>
  <div class="grid"><div class="card" v-for="p in list" :key="p.id" style="background:#fff"><div class="ph">Photo</div>
    <b>{{ p.id }}</b><div style="color:var(--mut)">Sightings: {{ p.sightings }}<br>Last seen: {{ p.last }}</div><p style="margin:10px 0 0"><button class="btn o" @click="sel = p">View</button></p></div></div>
  <p v-if="!list.length">No individuals match your search.</p>
</template>
