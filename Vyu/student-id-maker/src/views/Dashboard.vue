<script setup>
import { computed } from 'vue'
import { db, STATUSES, PROGRAMS } from '../store'
const counts = computed(() => STATUSES.map(s => ({ s, n: db.records.filter(r => r.status === s).length })))
const byProgram = computed(() => PROGRAMS.map(p => ({ p, n: db.records.filter(r => r.program === p).length })))
const when = t => new Date(t).toLocaleString()
</script>

<template>
  <h1>Dashboard</h1>
  <p>{{ db.records.length }} ID records in the central database.</p>
  <div class="stats">
    <div v-for="c in counts" :key="c.s" :class="['stat', c.s]"><b>{{ c.n }}</b>{{ c.s }}</div>
  </div>
  <div class="two">
    <section class="panel">
      <h2>Records by course or department</h2>
      <table><tr v-for="b in byProgram" :key="b.p"><td>{{ b.p }}</td><td class="num">{{ b.n }}</td></tr></table>
      <br /><router-link class="btn primary" to="/records/new">Add ID record</router-link>
    </section>
    <section class="panel">
      <h2>Recent ID transactions</h2>
      <table>
        <tr v-for="(l, i) in db.log.slice(0, 8)" :key="i"><td>{{ l.action }}<small>{{ l.by }}, {{ when(l.t) }}</small></td></tr>
        <tr v-if="!db.log.length"><td>No transactions yet.</td></tr>
      </table>
    </section>
  </div>
</template>
