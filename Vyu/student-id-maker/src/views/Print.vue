<script setup>
import { ref, computed } from 'vue'
import { db, setStatus } from '../store'
import IdCard from '../components/IdCard.vue'
const sel = ref([])
const ready = computed(() => db.records.filter(r => ['Approved', 'Printed'].includes(r.status)))
const chosen = computed(() => ready.value.filter(r => sel.value.includes(r.id)))
// 9 cards per A4 sheet; back rows are mirrored so duplex (long-edge) printing lines up
const pages = computed(() => {
  const out = []
  for (let i = 0; i < chosen.value.length; i += 9) {
    const front = chosen.value.slice(i, i + 9), back = []
    for (let j = 0; j < 9; j += 3) { const row = front.slice(j, j + 3); while (row.length < 3) row.push(null); back.push(...row.reverse()) }
    out.push({ front, back })
  }
  return out
})
function doPrint() {
  const list = [...chosen.value]
  window.print()
  if (confirm('Mark ' + list.length + ' ID(s) as printed?')) {
    list.filter(r => r.status === 'Approved').forEach(r => setStatus(r.id, 'Printed'))
    sel.value = []
  }
}
</script>

<template>
  <div class="no-print">
    <div class="bar"><h1>Print queue</h1><button class="btn primary" :disabled="!chosen.length" @click="doPrint">Print {{ chosen.length }} selected</button></div>
    <p>Approved IDs are laid out 9 per A4 sheet at card size (54 x 85.6 mm), fronts first, then backs.</p>
    <div class="panel scroll">
      <table>
        <thead><tr><th></th><th>ID number</th><th>Name</th><th>Status</th></tr></thead>
        <tbody>
          <tr v-for="r in ready" :key="r.id">
            <td><input type="checkbox" v-model="sel" :value="r.id" :aria-label="'Select ' + r.idNo" /></td>
            <td>{{ r.idNo }}</td><td>{{ r.last }}, {{ r.first }}</td><td><span :class="['badge', r.status]">{{ r.status }}</span></td>
          </tr>
          <tr v-if="!ready.length"><td colspan="4">No approved IDs yet. Approve records first.</td></tr>
        </tbody>
      </table>
    </div>
  </div>
  <div class="sheets">
    <template v-for="(pg, i) in pages" :key="i">
      <div class="sheet"><div v-for="r in pg.front" :key="r.id"><IdCard :r="r" /></div></div>
      <div class="sheet"><div v-for="(r, k) in pg.back" :key="k"><IdCard v-if="r" :r="r" side="back" /></div></div>
    </template>
  </div>
</template>

<style>
.sheets { display: none; }
@page { size: A4; margin: 8mm; }
@media print {
  body { background: #fff; }
  .side, .no-print { display: none !important; }
  .shell { display: block; }
  .main { padding: 0; max-width: none; }
  .sheets { display: block; }
  .sheet { display: grid; grid-template-columns: repeat(3, 54mm); gap: 6mm; justify-content: center; break-after: page; }
}
</style>
