<script setup>
import { stats, weekly, recent } from '../data.js'
const max = Math.max(...weekly)
</script>
<template>
  <h1>Dashboard</h1>
  <div class="stats">
    <div class="card">Estimated population<b>{{ stats.population }}</b></div><div class="card">Recognized individuals<b>{{ stats.individuals }}</b></div>
    <div class="card">Sightings (last 30 days)<b>{{ stats.sightings30 }}</b></div><div class="card">Active camera traps<b>{{ stats.camerasActive }}</b></div></div>
  <div class="two">
    <div class="card"><h3 style="margin-top:0;color:var(--ink)">Sighting frequency per week</h3>
      <div class="chart" role="img" aria-label="Weekly sighting frequency, weeks 1 to 8"><div v-for="(v, i) in weekly" :key="i" :title="v + ' sightings'"><i :style="{ height: (v / max) * 150 + 'px' }"></i>W{{ i + 1 }}</div></div></div>
    <div class="card"><h3 style="margin-top:0;color:var(--ink)">Recent sightings</h3><div class="wrap"><table class="tbl"><thead><tr><th>Individual</th><th>Camera</th><th>Time</th></tr></thead>
      <tbody><tr v-for="r in recent" :key="r[2]"><td>{{ r[0] }}</td><td>{{ r[1] }}</td><td>{{ r[2] }}</td></tr></tbody></table></div></div></div>
</template>
