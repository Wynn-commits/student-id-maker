<script setup>
import { ref, computed } from 'vue'
import { db, session, STATUSES, setStatus, remove } from '../store'
import IdCard from '../components/IdCard.vue'
const q = ref(''), st = ref(''), view = ref(null)
const rows = computed(() => db.records.filter(r =>
  (!st.value || r.status === st.value) &&
  [r.last, r.first, r.idNo, r.program].join(' ').toLowerCase().includes(q.value.toLowerCase())))
function reject(r) { const m = prompt('Reason for rejection (shown to the applicant):'); if (m) setStatus(r.id, 'Rejected', m) }
function del(r) { if (confirm('Delete record ' + r.idNo + '? This cannot be undone.')) remove(r.id) }
</script>

<template>
  <div class="bar"><h1>ID records</h1><router-link class="btn primary" to="/records/new">Add ID record</router-link></div>
  <div class="bar">
    <input v-model="q" placeholder="Search by name, ID number, or course" class="grow" />
    <select v-model="st" style="width:auto"><option value="">All statuses</option><option v-for="s in STATUSES" :key="s">{{ s }}</option></select>
  </div>
  <div class="panel scroll">
    <table>
      <thead><tr><th>ID number</th><th>Name</th><th>Course or department</th><th>Status</th><th>Actions</th></tr></thead>
      <tbody>
        <tr v-for="r in rows" :key="r.id">
          <td>{{ r.idNo }}</td>
          <td>{{ r.last }}, {{ r.first }} {{ r.middle }}<small>{{ r.type }}</small></td>
          <td>{{ r.program }}</td>
          <td><span :class="['badge', r.status]">{{ r.status }}</span><small v-if="r.remarks">{{ r.remarks }}</small></td>
          <td class="acts">
            <button @click="view = r">Preview</button>
            <router-link :to="'/records/' + r.id">Edit</router-link>
            <button v-if="r.status === 'Pending'" @click="setStatus(r.id, 'Approved')">Verify and approve</button>
            <button v-if="r.status === 'Pending'" @click="reject(r)">Reject</button>
            <button v-if="r.status === 'Printed'" @click="setStatus(r.id, 'Released')">Mark released</button>
            <button v-if="session.user.role === 'admin'" class="danger" @click="del(r)">Delete</button>
          </td>
        </tr>
        <tr v-if="!rows.length"><td colspan="5">No records match your search.</td></tr>
      </tbody>
    </table>
  </div>
  <div v-if="view" class="modal" @click.self="view = null">
    <div class="panel pv">
      <div class="cards"><IdCard :r="view" /><IdCard :r="view" side="back" /></div>
      <button class="btn" @click="view = null">Close</button>
    </div>
  </div>
</template>
