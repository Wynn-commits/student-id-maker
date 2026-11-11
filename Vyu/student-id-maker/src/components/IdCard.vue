<script setup>
import { computed } from 'vue'
import { AY } from '../store'
const props = defineProps({ r: Object, side: { type: String, default: 'front' } })
// Code 39 patterns (n = narrow, w = wide), so the printed barcode is scannable
const P = Object.fromEntries('0:nnnwwnwnn,1:wnnwnnnnw,2:nnwwnnnnw,3:wnwwnnnnn,4:nnnwwnnnw,5:wnnwwnnnn,6:nnwwwnnnn,7:nnnwnnwnw,8:wnnwnnwnn,9:nnwwnnwnn,A:wnnnnwnnw,B:nnwnnwnnw,C:wnwnnwnnn,D:nnnnwwnnw,E:wnnnwwnnn,F:nnwnwwnnn,G:nnnnnwwnw,H:wnnnnwwnn,I:nnwnnwwnn,J:nnnnwwwnn,K:wnnnnnnww,L:nnwnnnnww,M:wnwnnnnwn,N:nnnnwnnww,O:wnnnwnnwn,P:nnwnwnnwn,Q:nnnnnnwww,R:wnnnnnwwn,S:nnwnnnwwn,T:nnnnwnwwn,U:wwnnnnnnw,V:nwwnnnnnw,W:wwwnnnnnn,X:nwnnwnnnw,Y:wwnnwnnnn,Z:nwwnwnnnn,-:nwnnnnwnw,*:nwnnwnwnn'.split(',').map(s => s.split(':')))
const bars = computed(() => {
  let x = 0; const out = []
  for (const ch of '*' + String(props.r.idNo || '').toUpperCase() + '*') {
    const p = P[ch] || P['-']
    for (let i = 0; i < 9; i++) { const w = p[i] === 'w' ? 3 : 1; if (i % 2 === 0) out.push({ x, w }); x += w }
    x += 1
  }
  return { out, W: x }
})
</script>

<template>
  <div class="idc">
    <template v-if="side === 'front'">
      <header>
        <svg class="seal" viewBox="0 0 40 40"><circle cx="20" cy="20" r="18" fill="#fff" stroke="#e2a62b" stroke-width="3" /><text x="20" y="24" text-anchor="middle" font-size="10" font-weight="700" fill="#0f5a3a">CPSU</text></svg>
        <div><b>Central Philippines<br />State University</b><small>San Carlos Campus</small></div>
      </header>
      <div class="ph">
        <img v-if="r.photo" :src="r.photo" alt="" />
        <svg v-else viewBox="0 0 30 40"><rect width="30" height="40" fill="#e4ebe7" /><circle cx="15" cy="15" r="6" fill="#9db3a7" /><path d="M3 40c0-10 6-14 12-14s12 4 12 14z" fill="#9db3a7" /></svg>
      </div>
      <div class="nm"><b>{{ r.last || 'Last name' }}</b>, {{ r.first || 'First name' }} {{ r.middle }}</div>
      <div class="no">{{ r.idNo || '0000-0000' }}</div>
      <div class="pg">{{ r.program }}</div>
      <footer>{{ r.type }}</footer>
    </template>
    <template v-else>
      <div class="bk">
        <b>Terms of use</b>
        <p>This card is non-transferable and remains the property of Central Philippines State University, San Carlos Campus. Report a lost card to the ID office. If found, please return it to the campus.</p>
        <div class="sg"></div>
        <small>Authorized signatory</small>
        <svg :viewBox="`0 0 ${bars.W} 10`" preserveAspectRatio="none" class="code"><rect v-for="b in bars.out" :key="b.x" :x="b.x" y="0" :width="b.w" height="10" fill="#000" /></svg>
        <small>{{ r.idNo }}</small>
        <small>Valid for {{ AY }}</small>
      </div>
    </template>
  </div>
</template>

<style scoped>
.idc { width: 100%; aspect-ratio: 54 / 85.6; container-type: inline-size; background: #fff; border: 1px solid #d8e0db; border-radius: 5%; overflow: hidden; display: flex; flex-direction: column; align-items: center; text-align: center; color: #1b2a24; print-color-adjust: exact; -webkit-print-color-adjust: exact; }
header { background: #0f5a3a; color: #fff; width: 100%; display: flex; gap: 3cqw; align-items: center; padding: 4cqw 5cqw; border-bottom: 1.6cqw solid #e2a62b; text-align: left; }
.seal { width: 13cqw; flex: none; }
header b { font-size: 5.2cqw; line-height: 1.15; display: block; }
header small { font-size: 4cqw; color: #f4d98f; }
.ph { width: 46cqw; aspect-ratio: 3 / 4; margin-top: 6cqw; border: 1cqw solid #e2a62b; overflow: hidden; }
.ph img, .ph svg { width: 100%; height: 100%; object-fit: cover; display: block; }
.nm { margin-top: 5cqw; font-size: 6.6cqw; padding: 0 4cqw; line-height: 1.15; }
.no { font-size: 8cqw; font-weight: 700; color: #0f5a3a; margin-top: 2cqw; letter-spacing: .04em; }
.pg { font-size: 4.4cqw; padding: 0 5cqw; margin-top: 1cqw; }
footer { margin-top: auto; width: 100%; background: #0f5a3a; color: #fff; font-size: 5cqw; padding: 2.5cqw; letter-spacing: .2em; text-transform: uppercase; }
.bk { padding: 8cqw 7cqw; display: flex; flex-direction: column; gap: 3cqw; align-items: center; width: 100%; height: 100%; }
.bk b { font-size: 6cqw; }
.bk p { font-size: 4.2cqw; margin: 0; line-height: 1.4; }
.bk small { font-size: 4cqw; color: #4a5d54; }
.sg { width: 60%; border-bottom: .4cqw solid #1b2a24; margin-top: 10cqw; }
.code { width: 80%; height: 14cqw; margin-top: auto; }
</style>
