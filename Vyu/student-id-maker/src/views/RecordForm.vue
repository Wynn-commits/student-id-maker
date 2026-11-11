<script setup>
import { reactive, computed, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { db, session, save, PROGRAMS, TYPES } from '../store'
import IdCard from '../components/IdCard.vue'
const route = useRoute(), router = useRouter()
const mine = route.path === '/my-id'
const existing = mine ? db.records.find(r => r.ownerId === session.user.id) : db.records.find(r => r.id === route.params.id)
const f = reactive({ id: '', ownerId: mine ? session.user.id : null, last: '', first: '', middle: '', idNo: '', type: 'Student', program: PROGRAMS[0], photo: '', status: 'Pending', remarks: '', ...JSON.parse(JSON.stringify(existing || {})) })
const locked = computed(() => Boolean(mine && f.id && ['Approved', 'Printed', 'Released'].includes(f.status)))
const err = ref(''), ok = ref('')
const steps = ['Pending', 'Approved', 'Printed', 'Released']

function onPhoto(e) {
  const file = e.target.files[0]; if (!file) return
  const img = new Image()
  img.onload = () => {
    const c = document.createElement('canvas'); c.width = 300; c.height = 400
    const s = Math.max(300 / img.width, 400 / img.height)
    c.getContext('2d').drawImage(img, (300 - img.width * s) / 2, (400 - img.height * s) / 2, img.width * s, img.height * s)
    f.photo = c.toDataURL('image/jpeg', 0.85)
  }
  img.src = URL.createObjectURL(file)
}
function submit() {
  err.value = ok.value = ''
  if (!/^[A-Za-z0-9-]+$/.test(f.idNo)) { err.value = 'ID number may only contain letters, numbers, and hyphens.'; return }
  if (mine) { f.status = 'Pending'; f.remarks = '' }
  const e = save(f)
  if (e) { err.value = e; return }
  if (mine) ok.value = 'Application submitted. Staff will verify your details.'
  else router.push('/records')
}
</script>

<template>
  <h1>{{ mine ? 'My ID application' : f.id ? 'Edit ID record' : 'Add ID record' }}</h1>
  <ol v-if="mine && f.id" class="steps">
    <li v-for="s in steps" :key="s" :class="{ on: steps.indexOf(s) <= steps.indexOf(f.status) }">{{ s }}</li>
  </ol>
  <p v-if="mine && f.status === 'Rejected'" class="err">Your application was returned: {{ f.remarks }}. Fix the details below and resubmit.</p>
  <div class="two">
    <form class="panel" @submit.prevent="submit">
      <fieldset :disabled="locked">
        <label>Last name<input v-model="f.last" required /></label>
        <label>First name<input v-model="f.first" required /></label>
        <label>Middle initial<input v-model="f.middle" maxlength="4" /></label>
        <label>ID number<input v-model="f.idNo" required /></label>
        <label v-if="!mine">ID type<select v-model="f.type"><option v-for="t in TYPES" :key="t">{{ t }}</option></select></label>
        <label>Course or department<select v-model="f.program"><option v-for="p in PROGRAMS" :key="p">{{ p }}</option></select></label>
        <label>Profile photo<input type="file" accept="image/*" @change="onPhoto" /></label>
      </fieldset>
      <p v-if="locked">Your ID is {{ f.status }}. Records can only be changed by authorized personnel after approval.</p>
      <p v-if="err" class="err">{{ err }}</p>
      <p v-if="ok" class="ok">{{ ok }}</p>
      <button v-if="!locked" class="btn primary">{{ mine ? 'Submit application' : 'Save record' }}</button>
    </form>
    <div class="cards"><IdCard :r="f" /><IdCard :r="f" side="back" /></div>
  </div>
</template>
