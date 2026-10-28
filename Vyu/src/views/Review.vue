<script setup>
import { ref, computed } from 'vue'
import { queue, profiles } from '../data.js'
const n = ref(0), msg = ref(''), pick = ref(queue.items[0].id)
const cur = computed(() => queue.items[n.value % queue.items.length])
const pos = computed(() => queue.start + n.value)
function act(text) {
  msg.value = `${text} (image ${pos.value}).`
  n.value++; pick.value = cur.value.id
}
</script>
<template>
  <h1>Sighting Review</h1>
  <div class="view"><div><div class="shot">Camera trap image<span class="tag">Monkey {{ cur.det.toFixed(2) }}</span><span class="box"></span></div>
    <p style="color:var(--mut)">Camera: {{ cur.cam }} | Captured: {{ cur.time }} | Image {{ pos }} of {{ queue.total }} pending</p></div>
    <div class="card" style="background:#fff"><b>Identity suggested by the model</b><div style="font-size:2rem;font-weight:700;color:var(--g)">{{ cur.id }}</div>
      <div style="color:var(--mut)">Match confidence: {{ cur.conf }}%</div>
      <p><label for="id">Correct identity</label><br><select id="id" class="in" style="width:100%" v-model="pick"><option :value="cur.id">{{ cur.id }} (suggested)</option><option v-for="p in profiles.filter(x => x.id !== cur.id)" :key="p.id">{{ p.id }}</option></select></p>
      <div class="row"><button class="btn" @click="act('Confirmed ' + cur.id)">Confirm</button><button class="btn o" @click="act('Corrected to ' + pick)">Correct</button></div>
      <p><button class="btn o" @click="act('Registered as a new individual')">Register as new individual</button></p>
      <p><button class="btn d" @click="act('Marked as not a monkey')">Not a monkey</button></p>
      <p v-if="msg" role="status" style="color:var(--g)">{{ msg }}</p></div></div>
</template>
