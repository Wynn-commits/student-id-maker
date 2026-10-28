<script setup>
import { doc } from '../data.js'
const sections = [['summary', 'Executive Summary'], ['introduction', 'Introduction'], ['problem', 'Statement of the Problem'], ['objectives', 'Objectives'], ['scope', 'Scope and Limitation'], ['methodology', 'Methodology']]
const jump = (id) => document.getElementById(id)?.scrollIntoView({ behavior: 'smooth' })
const fig = (n) => `${import.meta.env.BASE_URL}figures/fig${n}.png`
</script>
<template>
  <header class="bar"><b>{{ doc.university }}</b><router-link to="/login" class="btn o">Open the monitoring system</router-link></header>
  <div class="hero"><div>
    <p>{{ doc.campus }} · {{ doc.college }}<br>{{ doc.course }} · {{ doc.output }}</p>
    <h1>{{ doc.title }}</h1>
    <dl class="meta">
      <dt>Group</dt><dd>{{ doc.group }}</dd>
      <template v-for="(m, i) in doc.team" :key="i"><dt>{{ m[1] }}</dt><dd>{{ m[0] }}</dd></template>
      <dt>Submitted to</dt><dd>{{ doc.adviser[0] }}, {{ doc.adviser[1] }}</dd>
      <dt>A.Y.</dt><dd>{{ doc.ay }}</dd>
    </dl>
    <nav class="toc" aria-label="Contents"><a v-for="(s, i) in sections" :key="s[0]" :href="'#' + s[0]" @click.prevent="jump(s[0])">{{ ['I', 'II', 'III', 'IV', 'V', 'VI'][i] }}. {{ s[1] }}</a></nav>
  </div></div>

  <section id="summary" class="sec"><h2>I. Executive Summary</h2><p v-for="p in doc.summary" :key="p">{{ p }}</p></section>
  <section id="introduction" class="sec"><h2>II. Introduction</h2><p v-for="p in doc.intro" :key="p">{{ p }}</p></section>
  <section id="problem" class="sec"><h2>III. Statement of the Problem</h2><p>{{ doc.problem }}</p>
    <p>This proposal seeks to answer the following questions:</p><ul><li v-for="q in doc.questions" :key="q">{{ q }}</li></ul></section>
  <section id="objectives" class="sec"><h2>IV. Objectives</h2><p>{{ doc.general }}</p><h3>Specific Objectives</h3>
    <ul><li v-for="(o, i) in doc.specific" :key="i"><template v-if="typeof o === 'string'">{{ o }}</template>
      <template v-else>{{ o[0] }}<ol type="a"><li>{{ o[1] }}</li><li>{{ o[2] }}</li></ol></template></li></ul></section>
  <section id="scope" class="sec"><h2>V. Scope and Limitation</h2><p>{{ doc.scopeIntro }}</p>
    <div v-for="m in doc.modules" :key="m.name"><h3>{{ m.name }}</h3><p>{{ m.text }}</p><p><b>Limitation:</b> {{ m.limit }}</p></div></section>
  <section id="methodology" class="sec"><h2>VI. Methodology</h2><p>{{ doc.sdlc }}</p>
    <div v-for="ph in doc.phases" :key="ph.name"><h3>{{ ph.name }}</h3><p v-for="t in ph.text" :key="t">{{ t }}</p>
      <template v-if="ph.name === 'Requirement Analysis'"><p>The functional requirements of the system are as follows:</p><ul><li v-for="r in doc.requirements" :key="r">{{ r }}</li></ul></template>
      <figure v-for="f in ph.figs" :key="f[0]"><img :src="fig(f[0])" :alt="`Figure ${f[0]}. ${f[1]}`" loading="lazy"><figcaption>Figure {{ f[0] }}. {{ f[1] }}</figcaption></figure>
      <template v-if="ph.name === 'Development'"><p>The user interface follows the functions shown in the flow chart: the sign-in page (Figure 7), the dashboard (Figure 8), the monkey profiles page (Figure 9), the sighting review page (Figure 10), and the camera trap management page (Figure 11). These pages are built in this project with sample data.</p>
        <p><router-link class="btn" to="/login">Open the monitoring system</router-link></p>
        <p>The outline of the planned image-processing pipeline is shown in Figure 12.</p><pre>{{ doc.pseudo }}</pre><p class="note" style="text-align:left">Figure 12. Outline of the planned image-processing pipeline (pseudocode).</p></template></div></section>
</template>
