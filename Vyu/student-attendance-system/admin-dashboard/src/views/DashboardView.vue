<template>
  <div class="dashboard">
    <div class="card events-card">
      <div class="events-header">
        <h2>Events</h2>
        <select v-if="events.length" v-model.number="selectedEventId" class="event-select">
          <option v-for="ev in events" :key="ev.id" :value="ev.id">
            {{ ev.name }} — {{ ev.event_date }} ({{ statusLabel(ev.status) }})
          </option>
        </select>
      </div>

      <form class="new-event-form" @submit.prevent="createEvent">
        <input v-model="newEventName" type="text" placeholder="Event name" required />
        <input v-model="newEventDate" type="date" required />
        <button type="submit" class="btn btn-primary" :disabled="creatingEvent">
          {{ creatingEvent ? 'Creating…' : 'Create event' }}
        </button>
      </form>

      <div v-if="selectedEvent" class="event-controls">
        <div class="event-status">
          <span class="status-badge" :class="statusClass(selectedEvent.status)">
            {{ statusLabel(selectedEvent.status) }}
          </span>

          <template v-if="!editingEvent">
            <span class="event-name">{{ selectedEvent.name }} — {{ selectedEvent.event_date }}</span>
            <button class="icon-btn" @click="startEdit">Edit</button>
          </template>
          <form v-else class="edit-event-form" @submit.prevent="saveEdit">
            <input v-model="editName" type="text" required />
            <input v-model="editDate" type="date" required />
            <button type="submit" class="btn btn-primary btn-sm" :disabled="savingEdit">
              {{ savingEdit ? 'Saving…' : 'Save' }}
            </button>
            <button type="button" class="btn btn-ghost btn-sm" @click="editingEvent = false">Cancel</button>
          </form>
        </div>

        <div class="control-actions">
          <template v-if="selectedEvent.status === 'not_started'">
            <button class="btn btn-primary" :disabled="controlBusy" @click="runControl('start-time-in')">
              Start time-in
            </button>
            <button class="btn btn-ghost" :disabled="controlBusy" @click="runControl('start-time-out')">
              Start time-out only
            </button>
            <button class="btn btn-danger-ghost" :disabled="controlBusy" @click="deleteEvent">Delete event</button>
          </template>

          <template v-else-if="selectedEvent.status === 'time_in_open'">
            <button class="btn btn-primary" :disabled="controlBusy" @click="runControl('start-time-out')">
              Start time-out
            </button>
            <button class="btn btn-ghost" :disabled="controlBusy" @click="runControl('end')">
              End event early
            </button>
          </template>

          <button
            v-else-if="selectedEvent.status === 'time_out_open'"
            class="btn btn-primary"
            :disabled="controlBusy"
            @click="runControl('end')"
          >
            End event
          </button>

          <span v-else class="ended-note">
            Ended{{ selectedEvent.ended_at ? ' at ' + formatTime(selectedEvent.ended_at) : '' }}.
          </span>
        </div>

        <p v-if="selectedEvent.status === 'not_started'" class="mode-hint">
          "Start time-in" if you want both arrival and departure logged. "Start time-out only" skips straight to
          logging departures — no prior time-in scan is required. "Delete event" is only available here, before
          anyone has scanned — once it's started, end it instead, so any attendance and sanction history stays intact.
        </p>
      </div>
    </div>

    <template v-if="selectedEventId">
      <div class="toolbar">
        <button class="btn btn-ghost" @click="exportFlagged">Export flagged list</button>
      </div>

      <div class="stats-grid">
        <StatCard label="Enrolled" :value="stats.total" />
        <StatCard label="Complete" :value="stats.complete" variant="success" />
        <StatCard label="Timed in only" :value="stats.timedInOnly" variant="warning" />
        <StatCard label="Timed out only" :value="stats.timedOutOnly" variant="warning" />
        <StatCard label="No log" :value="stats.absent" variant="danger" />
      </div>

      <div class="filters">
        <div class="tabs">
          <button
            v-for="tab in tabs"
            :key="tab.value"
            class="tab-btn"
            :class="{ active: activeTab === tab.value }"
            @click="activeTab = tab.value"
          >
            {{ tab.label }}
          </button>
        </div>
        <input v-model="search" type="text" placeholder="Search name or student number" class="search-input" />
      </div>

      <p v-if="errorMessage" class="error-text">{{ errorMessage }}</p>
      <p v-if="loading" class="muted">Loading attendance…</p>

      <div class="card table-card" v-else>
        <AttendanceTable
          :rows="filteredRows"
          :event="selectedEvent || {}"
          :history-open-id="historyOpenId"
          :history-loading="historyLoading"
          :history-entries="historyEntries"
          @toggle-flag="toggleFlag"
          @toggle-history="toggleHistory"
        />
      </div>
    </template>
  </div>
</template>

<script setup>
import { ref, computed, watch, onMounted } from 'vue';
import api from '../services/api';
import StatCard from '../components/StatCard.vue';
import AttendanceTable from '../components/AttendanceTable.vue';

const events = ref([]);
const selectedEventId = ref(null);
const newEventName = ref('');
const newEventDate = ref(new Date().toISOString().slice(0, 10));
const creatingEvent = ref(false);
const controlBusy = ref(false);

const editingEvent = ref(false);
const editName = ref('');
const editDate = ref('');
const savingEdit = ref(false);

const students = ref([]);
const loading = ref(false);
const errorMessage = ref('');
const search = ref('');
const activeTab = ref('all');

const historyOpenId = ref(null);
const historyLoading = ref(false);
const historyEntries = ref([]);

const tabs = [
  { value: 'all', label: 'All' },
  { value: 'complete', label: 'Complete' },
  { value: 'timed_in_only', label: 'Timed in only' },
  { value: 'timed_out_only', label: 'Timed out only' },
  { value: 'absent', label: 'No log' },
];

const selectedEvent = computed(() => events.value.find((e) => e.id === selectedEventId.value) || null);

function statusLabel(status) {
  return { not_started: 'Not started', time_in_open: 'Time-in open', time_out_open: 'Time-out open', ended: 'Ended' }[
    status
  ] || status;
}
function statusClass(status) {
  return { not_started: 'status-idle', time_in_open: 'status-in', time_out_open: 'status-out', ended: 'status-ended' }[
    status
  ] || 'status-idle';
}
function formatTime(value) {
  if (!value) return '';
  return new Date(value).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
}

async function loadEvents() {
  try {
    const { data } = await api.get('/admin/events');
    events.value = data.events;
    const stillExists = events.value.some((e) => e.id === selectedEventId.value);
    if (!stillExists) {
      selectedEventId.value = events.value[0]?.id ?? null;
    }
  } catch (err) {
    errorMessage.value = err.response?.data?.error || 'Could not load events.';
  }
}

async function createEvent() {
  creatingEvent.value = true;
  errorMessage.value = '';
  try {
    const { data } = await api.post('/admin/events', { name: newEventName.value, event_date: newEventDate.value });
    newEventName.value = '';
    await loadEvents();
    selectedEventId.value = data.id;
  } catch (err) {
    errorMessage.value = err.response?.data?.error || 'Could not create the event.';
  } finally {
    creatingEvent.value = false;
  }
}

function startEdit() {
  editName.value = selectedEvent.value.name;
  editDate.value = selectedEvent.value.event_date;
  editingEvent.value = true;
}

async function saveEdit() {
  savingEdit.value = true;
  errorMessage.value = '';
  try {
    await api.patch(`/admin/events/${selectedEventId.value}`, { name: editName.value, event_date: editDate.value });
    editingEvent.value = false;
    await loadEvents();
  } catch (err) {
    errorMessage.value = err.response?.data?.error || 'Could not update the event.';
  } finally {
    savingEdit.value = false;
  }
}

async function deleteEvent() {
  if (!selectedEvent.value) return;
  const confirmed = window.confirm(
    `Delete "${selectedEvent.value.name}"? This cannot be undone. (Only available because it hasn't started yet — nothing has been scanned for it.)`
  );
  if (!confirmed) return;
  errorMessage.value = '';
  try {
    await api.delete(`/admin/events/${selectedEventId.value}`);
    selectedEventId.value = null;
    await loadEvents();
  } catch (err) {
    errorMessage.value = err.response?.data?.error || 'Could not delete the event.';
  }
}

async function runControl(action) {
  if (!selectedEventId.value) return;
  controlBusy.value = true;
  errorMessage.value = '';
  try {
    await api.post(`/admin/events/${selectedEventId.value}/${action}`);
    await loadEvents();
    await loadAttendance();
  } catch (err) {
    errorMessage.value = err.response?.data?.error || 'Could not update the event.';
  } finally {
    controlBusy.value = false;
  }
}

async function loadAttendance() {
  if (!selectedEventId.value) {
    students.value = [];
    return;
  }
  loading.value = true;
  errorMessage.value = '';
  try {
    const { data } = await api.get(`/admin/events/${selectedEventId.value}/attendance`);
    students.value = data.students;
  } catch (err) {
    errorMessage.value = err.response?.data?.error || 'Could not load attendance for this event.';
  } finally {
    loading.value = false;
  }
}

async function toggleFlag(row) {
  try {
    if (row.flagged) {
      await api.delete(`/admin/flag/${row.id}/${selectedEventId.value}`);
    } else {
      await api.post('/admin/flag', { student_id: row.id, event_id: selectedEventId.value });
    }
    await loadAttendance();
    if (historyOpenId.value === row.id) {
      await fetchHistoryFor(row.id);
    }
  } catch (err) {
    errorMessage.value = err.response?.data?.error || 'Could not update the flag.';
  }
}

async function fetchHistoryFor(studentId) {
  historyLoading.value = true;
  historyEntries.value = [];
  try {
    const { data } = await api.get(`/admin/flag-history/${studentId}/${selectedEventId.value}`);
    historyEntries.value = data.history;
  } catch (err) {
    errorMessage.value = err.response?.data?.error || 'Could not load flag history.';
  } finally {
    historyLoading.value = false;
  }
}

function toggleHistory(row) {
  if (historyOpenId.value === row.id) {
    historyOpenId.value = null;
    historyEntries.value = [];
    return;
  }
  historyOpenId.value = row.id;
  fetchHistoryFor(row.id);
}

const stats = computed(() => ({
  total: students.value.length,
  complete: students.value.filter((s) => s.status === 'complete').length,
  timedInOnly: students.value.filter((s) => s.status === 'timed_in_only').length,
  timedOutOnly: students.value.filter((s) => s.status === 'timed_out_only').length,
  absent: students.value.filter((s) => s.status === 'absent').length,
}));

const filteredRows = computed(() => {
  let rows = students.value;
  if (activeTab.value !== 'all') {
    rows = rows.filter((s) => s.status === activeTab.value);
  }
  const q = search.value.trim().toLowerCase();
  if (q) {
    rows = rows.filter((s) => s.name.toLowerCase().includes(q) || s.student_number.toLowerCase().includes(q));
  }
  return rows;
});

function exportFlagged() {
  const flaggedRows = students.value.filter((s) => s.flagged);
  if (flaggedRows.length === 0) {
    errorMessage.value = 'No students are flagged for this event yet.';
    return;
  }
  const header = 'Student number,Name,Section,Event,Date\n';
  const body = flaggedRows
    .map(
      (s) =>
        `${s.student_number},"${s.name}",${s.year_section},"${selectedEvent.value?.name || ''}",${
          selectedEvent.value?.event_date || ''
        }`
    )
    .join('\n');
  const blob = new Blob([header + body], { type: 'text/csv' });
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = `sanction-list-event-${selectedEventId.value}.csv`;
  a.click();
  URL.revokeObjectURL(url);
}

watch(selectedEventId, () => {
  historyOpenId.value = null;
  historyEntries.value = [];
  editingEvent.value = false;
  loadAttendance();
});
onMounted(async () => {
  await loadEvents();
  await loadAttendance();
});
</script>

<style scoped>
.dashboard {
  max-width: 1100px;
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}
.events-card {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}
.events-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
  flex-wrap: wrap;
}
.events-header h2 {
  margin: 0;
  font-size: 1.1rem;
}
.event-select {
  flex: 1;
  min-width: 260px;
  max-width: 420px;
  padding: 0.5rem 0.65rem;
  border: 1px solid var(--color-border);
  border-radius: 6px;
  font-size: 0.9rem;
}
.new-event-form {
  display: flex;
  gap: 0.6rem;
  flex-wrap: wrap;
}
.new-event-form input[type='text'] {
  flex: 1;
  min-width: 200px;
}
.new-event-form input {
  padding: 0.55rem 0.7rem;
  border: 1px solid var(--color-border);
  border-radius: 6px;
  font-size: 0.9rem;
}
.event-controls {
  border-top: 1px solid var(--color-border);
  padding-top: 1rem;
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}
.event-status {
  display: flex;
  align-items: center;
  gap: 0.6rem;
  flex-wrap: wrap;
}
.event-name {
  font-weight: 600;
}
.icon-btn {
  border: none;
  background: none;
  color: var(--color-primary);
  font-size: 0.82rem;
  text-decoration: underline;
  cursor: pointer;
  padding: 0;
}
.edit-event-form {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  flex-wrap: wrap;
}
.edit-event-form input {
  padding: 0.4rem 0.55rem;
  border: 1px solid var(--color-border);
  border-radius: 6px;
  font-size: 0.85rem;
}
.btn-sm {
  padding: 0.35rem 0.7rem;
  font-size: 0.85rem;
}
.status-badge {
  font-size: 0.78rem;
  font-weight: 600;
  padding: 0.25rem 0.65rem;
  border-radius: 999px;
}
.status-idle {
  background: rgba(107, 114, 128, 0.12);
  color: var(--color-text-muted);
}
.status-in {
  background: rgba(61, 139, 125, 0.12);
  color: var(--color-accent);
}
.status-out {
  background: rgba(198, 138, 30, 0.12);
  color: var(--color-warning);
}
.status-ended {
  background: rgba(192, 57, 43, 0.1);
  color: var(--color-danger);
}
.control-actions {
  display: flex;
  align-items: center;
  gap: 0.6rem;
  flex-wrap: wrap;
}
.btn-danger-ghost {
  background: transparent;
  color: var(--color-danger);
  border: 1px solid var(--color-danger);
}
.ended-note {
  font-size: 0.85rem;
  color: var(--color-text-muted);
  max-width: 420px;
}
.mode-hint {
  font-size: 0.82rem;
  color: var(--color-text-muted);
  margin: 0;
}
.toolbar {
  display: flex;
  justify-content: flex-end;
}
.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
  gap: 0.9rem;
}
.filters {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
  flex-wrap: wrap;
}
.tabs {
  display: flex;
  gap: 0.4rem;
  flex-wrap: wrap;
}
.tab-btn {
  border: 1px solid var(--color-border);
  background: transparent;
  color: var(--color-text-muted);
  font-size: 0.85rem;
  padding: 0.4rem 0.8rem;
  border-radius: 999px;
  cursor: pointer;
}
.tab-btn.active {
  background: var(--color-primary);
  border-color: var(--color-primary);
  color: #fff;
}
.search-input {
  flex: 1;
  min-width: 220px;
  padding: 0.5rem 0.75rem;
  border: 1px solid var(--color-border);
  border-radius: 6px;
  font-size: 0.9rem;
}
.table-card {
  padding: 0.5rem 1.25rem 1.25rem;
}
.muted {
  color: var(--color-text-muted);
}
</style>
