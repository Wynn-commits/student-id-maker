<template>
  <div class="card scan-card">
    <h2>Scan QR or enter ID</h2>

    <div class="event-banner" :class="eventBannerClass">
      <p class="event-banner-text">{{ eventBannerText }}</p>
    </div>

    <template v-if="canScan">
      <div class="mode-toggle">
        <button
          :class="['btn', mode === 'camera' ? 'btn-primary' : 'btn-ghost']"
          @click="mode = 'camera'"
        >
          Camera
        </button>
        <button
          :class="['btn', mode === 'manual' ? 'btn-primary' : 'btn-ghost']"
          @click="mode = 'manual'"
        >
          Manual / scanner device
        </button>
      </div>

      <QrScanner v-if="mode === 'camera'" @decoded="handleCode" />
      <ManualIdInput v-else @submit="handleCode" :disabled="busy" />
    </template>
    <p v-else class="waiting-text">
      Scanning is locked until the admin starts the next step. Check back in a moment.
    </p>

    <p v-if="busy" class="processing-text">Checking…</p>

    <div v-if="result" class="result" :class="resultClass">
      <p class="result-title">{{ resultTitle }}</p>
      <p v-if="result.student" class="result-name">
        {{ result.student.first_name }} {{ result.student.last_name }} — {{ result.student.course }}
      </p>
      <button v-if="result.ok" class="btn btn-ghost" @click="printAttendance">
        Print attendance
      </button>
    </div>

    <RouterLink to="/" class="btn btn-ghost back-link">Back to main menu</RouterLink>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onBeforeUnmount } from 'vue';
import { RouterLink } from 'vue-router';
import api from '../services/api';
import QrScanner from '../components/QrScanner.vue';
import ManualIdInput from '../components/ManualIdInput.vue';

const mode = ref('manual');
const result = ref(null);
const busy = ref(false);
const activeEvent = ref(null);
let pollTimer;

// Public endpoint — no login needed, this is what the kiosk checks before
// letting anyone scan at all. Returns null unless an admin has opened
// time-in or time-out for some event.
async function refreshActiveEvent() {
  try {
    const { data } = await api.get('/events/active');
    activeEvent.value = data.event;
  } catch (err) {
    // A transient network hiccup shouldn't silently lock the kiosk out;
    // leave the last known state in place and let the next poll retry.
  }
}

onMounted(() => {
  refreshActiveEvent();
  pollTimer = setInterval(refreshActiveEvent, 8000);
});

onBeforeUnmount(() => {
  if (pollTimer) clearInterval(pollTimer);
});

const canScan = computed(() => activeEvent.value !== null);

const eventBannerText = computed(() => {
  if (!activeEvent.value) return 'No event is currently open for attendance.';
  const label = activeEvent.value.status === 'time_in_open' ? 'Time-In is open' : 'Time-Out is open';
  return `${label} — ${activeEvent.value.name}`;
});

const eventBannerClass = computed(() => {
  if (!activeEvent.value) return 'banner-closed';
  return activeEvent.value.status === 'time_in_open' ? 'banner-time-in' : 'banner-time-out';
});

async function handleCode(code) {
  if (busy.value) return;
  busy.value = true;
  result.value = null;
  try {
    const { data } = await api.post('/attendance/scan', { code });
    result.value = { ok: true, action: data.action, student: data.student };
  } catch (err) {
    if (err.response) {
      result.value = {
        ok: false,
        error: err.response.data?.error || `Server error (${err.response.status}).`,
        student: err.response.data?.student,
      };
    } else if (err.request) {
      result.value = {
        ok: false,
        error: 'Could not reach the backend. Is it running on http://localhost:4000?',
      };
    } else {
      result.value = { ok: false, error: err.message };
    }
  } finally {
    busy.value = false;
    // Pick up any phase change the admin made while this scan was in flight.
    refreshActiveEvent();
  }
}

const resultTitle = computed(() => {
  if (!result.value) return '';
  if (!result.value.ok) return result.value.error;
  return result.value.action === 'time-in' ? 'Time-in recorded' : 'Time-out recorded';
});

const resultClass = computed(() => (result.value?.ok ? 'result-success' : 'result-error'));

function printAttendance() {
  window.print();
}
</script>

<style scoped>
.scan-card {
  width: 100%;
  max-width: 420px;
  text-align: center;
}
.event-banner {
  padding: 0.6rem 0.9rem;
  border-radius: 8px;
  margin-bottom: 1.25rem;
}
.event-banner-text {
  margin: 0;
  font-size: 0.9rem;
  font-weight: 600;
}
.banner-closed {
  background: rgba(107, 114, 128, 0.12);
  color: var(--color-text-muted);
}
.banner-time-in {
  background: rgba(0, 119, 182, 0.12);
  color: var(--color-accent);
}
.banner-time-out {
  background: rgba(198, 138, 30, 0.14);
  color: var(--color-warning);
}
.waiting-text {
  color: var(--color-text-muted);
  font-size: 0.9rem;
  padding: 1rem 0;
}
.mode-toggle {
  display: flex;
  gap: 0.5rem;
  justify-content: center;
  margin-bottom: 1.25rem;
}
.processing-text {
  color: var(--color-text-muted);
  font-size: 0.9rem;
  margin: 0.75rem 0 0;
}
.result {
  margin-top: 1.25rem;
  padding: 1rem;
  border-radius: 8px;
}
.result-success {
  background: rgba(61, 139, 125, 0.12);
  color: var(--color-accent);
}
.result-error {
  background: rgba(192, 57, 43, 0.1);
  color: var(--color-danger);
}
.result-title {
  font-weight: 600;
  margin: 0 0 0.35rem;
}
.result-name {
  margin: 0;
  font-size: 0.9rem;
}
.back-link {
  margin-top: 1.5rem;
  display: inline-block;
}
</style>
