<template>
  <table class="attendance-table">
    <thead>
      <tr>
        <th>Student no.</th>
        <th>Name</th>
        <th>Section</th>
        <th>Time in</th>
        <th>Time out</th>
        <th>Status</th>
      </tr>
    </thead>
    <tbody>
      <template v-for="row in rows" :key="row.id">
        <tr>
          <td class="mono">{{ row.student_number }}</td>
          <td>{{ row.name }}</td>
          <td class="muted">{{ row.year_section }}</td>
          <td :class="{ muted: !row.time_in }">{{ formatTime(row.time_in) }}</td>
          <td :class="{ muted: !row.time_out }">{{ formatTime(row.time_out) }}</td>
          <td>
            <div class="status-cell">
              <span v-if="classify(row).kind === 'good'" class="badge badge-success">{{ classify(row).label }}</span>
              <span v-else-if="classify(row).kind === 'pending'" class="badge badge-neutral">{{ classify(row).label }}</span>
              <template v-else>
                <button class="flag-btn" :class="{ flagged: row.flagged }" @click="$emit('toggle-flag', row)">
                  {{ row.flagged ? 'Flagged' : 'Flag' }}{{ classify(row).label ? ' — ' + classify(row).label : '' }}
                </button>
                <button class="history-link" @click="$emit('toggle-history', row)">
                  {{ historyOpenId === row.id ? 'Hide history' : 'History' }}
                </button>
              </template>
            </div>
          </td>
        </tr>
        <tr v-if="historyOpenId === row.id" class="history-row">
          <td colspan="6">
            <p v-if="historyLoading" class="muted history-note">Loading history…</p>
            <p v-else-if="!historyEntries.length" class="muted history-note">
              No flag history for this student on this event.
            </p>
            <ul v-else class="history-list">
              <li v-for="(entry, i) in historyEntries" :key="i">
                <span class="history-action" :class="entry.action">{{
                  entry.action === 'flagged' ? 'Flagged' : 'Unflagged'
                }}</span>
                by {{ entry.performed_by }} — {{ formatDateTime(entry.performed_at) }}
                <span v-if="entry.reason"> — "{{ entry.reason }}"</span>
              </li>
            </ul>
          </td>
        </tr>
      </template>
    </tbody>
  </table>
  <p v-if="rows.length === 0" class="empty-state">No students match this filter.</p>
</template>

<script setup>
const props = defineProps({
  rows: { type: Array, required: true },
  // The full event object (status, time_in_opened_at, time_out_opened_at) —
  // needed because whether a given status counts as "fine" or "flaggable"
  // depends on what THIS event ever required, not just the status name.
  event: { type: Object, required: true },
  historyOpenId: { type: [Number, String], default: null },
  historyLoading: { type: Boolean, default: false },
  historyEntries: { type: Array, default: () => [] },
});
defineEmits(['toggle-flag', 'toggle-history']);

// Turns a raw status (complete / timed_in_only / timed_out_only / absent)
// into what to actually show, given what this event ever asked for:
// - "good": the student did everything this event required. Green badge.
// - "pending": too early to judge — the event's still running, or its
//   final shape (was this ever going to have a time-out phase?) isn't
//   knowable yet. Neutral badge, no flag button.
// - "flaggable": did NOT do what this event required, and that verdict is
//   final. Renders the flag button, with a label describing what's missing.
function classify(row) {
  const ended = props.event?.status === 'ended';
  const hadTimeIn = Boolean(props.event?.time_in_opened_at);
  const hadTimeOut = Boolean(props.event?.time_out_opened_at);

  if (row.status === 'complete') {
    return { kind: 'good', label: 'Complete' };
  }

  if (row.status === 'timed_in_only') {
    // A time-in-only event's final shape is only knowable once it's
    // ended — while it's still "time_in_open", it might yet go on to
    // open time-out, so we can't judge it early.
    if (ended && !hadTimeOut) return { kind: 'good', label: 'Timed in' };
    if (!ended) return { kind: 'pending', label: 'Timed in — event ongoing' };
    return { kind: 'flaggable', label: 'did not log out' };
  }

  if (row.status === 'timed_out_only') {
    // A time-out-only event's shape IS knowable immediately — skipping
    // time-in is a decision made before the event ever opens.
    if (!hadTimeIn) return { kind: 'good', label: 'Timed out' };
    if (!ended) return { kind: 'pending', label: 'Timed out — event ongoing' };
    return { kind: 'flaggable', label: 'no time-in record' };
  }

  // absent
  if (!ended) return { kind: 'pending', label: 'No log yet' };
  return { kind: 'flaggable', label: '' };
}

function formatTime(value) {
  if (!value) return '—';
  return new Date(value).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
}
function formatDateTime(value) {
  if (!value) return '—';
  return new Date(value).toLocaleString([], { dateStyle: 'medium', timeStyle: 'short' });
}
</script>

<style scoped>
.attendance-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 0.9rem;
}
.attendance-table th {
  text-align: left;
  padding: 0.6rem 0.5rem;
  color: var(--color-text-muted);
  font-weight: 600;
  border-bottom: 1px solid var(--color-border);
}
.attendance-table td {
  padding: 0.6rem 0.5rem;
  border-bottom: 1px solid var(--color-border);
}
.mono {
  font-family: 'Courier New', monospace;
  font-size: 0.85rem;
}
.muted {
  color: var(--color-text-muted);
}
.status-cell {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  flex-wrap: wrap;
}
.badge {
  display: inline-flex;
  align-items: center;
  font-size: 0.78rem;
  font-weight: 600;
  padding: 0.2rem 0.6rem;
  border-radius: 999px;
}
.badge-success {
  background: rgba(61, 139, 125, 0.12);
  color: var(--color-accent);
}
.badge-neutral {
  background: rgba(107, 114, 128, 0.12);
  color: var(--color-text-muted);
}
.flag-btn {
  border: 1px solid var(--color-danger);
  background: rgba(192, 57, 43, 0.08);
  color: var(--color-danger);
  font-size: 0.78rem;
  font-weight: 600;
  padding: 0.25rem 0.65rem;
  border-radius: 6px;
  cursor: pointer;
}
.flag-btn.flagged {
  background: var(--color-danger);
  color: #fff;
}
.history-link {
  border: none;
  background: none;
  color: var(--color-primary);
  font-size: 0.78rem;
  text-decoration: underline;
  cursor: pointer;
  padding: 0;
}
.history-row td {
  background: var(--color-bg);
  padding: 0.75rem 1rem;
}
.history-note {
  margin: 0;
  font-size: 0.85rem;
}
.history-list {
  margin: 0;
  padding-left: 1.1rem;
  font-size: 0.85rem;
  display: flex;
  flex-direction: column;
  gap: 0.3rem;
}
.history-action {
  font-weight: 600;
}
.history-action.flagged {
  color: var(--color-danger);
}
.history-action.unflagged {
  color: var(--color-text-muted);
}
.empty-state {
  text-align: center;
  color: var(--color-text-muted);
  padding: 2rem 0;
  font-size: 0.9rem;
}
</style>
