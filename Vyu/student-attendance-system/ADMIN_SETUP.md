# Student Attendance System — event-based admin dashboard

```
student-attendance-system/
├── backend/           Express API — students, kiosk scanning, admin + event control
├── kiosk/              Student-facing app (was "frontend") — registration + scanning
└── admin-dashboard/    Staff-only app (was "admin") — event control + attendance report
```

Renamed both frontend folders so nothing reads as similar: `kiosk` is what students
touch, `admin-dashboard` is what staff touch. Update any shortcuts/scripts you had
pointing at the old `frontend/`/`admin/` paths.

## What changed: attendance is now per-event, not per-date

Previously a scan just logged whatever time it happened at, for "today." Now
scanning only does anything while an admin has an event open, and what a scan
*does* depends on which phase the admin has opened:

```
not started ──[Start time-in]──> time-in open ──[Start time-out]──> time-out open ──[End event]──> ended
```

- **Time-in open** — scanning creates a time-in record. Scanning again just
  says "already logged in" — it can't also grab a time-out, because time-out
  isn't open yet.
- **Time-out open** — scanning closes out an *existing* time-in. A student
  with no time-in record can't scan their way into one; they get "no time-in
  record found."
- **Ended** — scanning is closed entirely. Anyone still showing "timed in
  only" in the report genuinely didn't log out — that's your sanction list.

This is what makes the two-scan trick (scan once immediately, then scan again
seconds later, to fake a full day's attendance) impossible: the two actions
are only reachable in two separate, admin-controlled windows.

## 1. Update the database

`attendance_logs` and `sanction_flags` now key off `event_id` instead of
`log_date`. Run the migration once against your existing database:

```bash
mysql -u root -p attendance_system < backend/migrate_to_events.sql
```

This drops and recreates just those two tables — any test scans you already
made won't carry forward, but `students`, `enrollment_masterlist`, and
`admins` (and all their data) are untouched. `backend/schema.sql` has also
been updated to the same structure, for anyone setting up fresh.

A ready-to-use admin account is now seeded automatically — see below.

There's one more migration on top of that, purely additive this time — it
adds the sanction flag audit trail (see further down) and touches nothing
else:

```bash
mysql -u root -p attendance_system < backend/migrate_add_flag_history.sql
```

## 2. Run everything

`npm install` in `backend/` now also picks up `express-rate-limit`, used to
throttle the admin login endpoint — no separate install step needed.

```bash
# terminal 1
cd backend && npm install && npm run dev

# terminal 2 — student kiosk
cd kiosk && npm install && npm run dev          # http://localhost:5173

# terminal 3 — admin dashboard
cd admin-dashboard && npm install && copy .env.example .env && npm run dev   # http://localhost:5174
```

(If you already have an admin account from before, it still works — accounts
weren't touched by the migration.)

**Log in with:**
- username: `admin`
- password: `vLfMnP56oeUS`

This account is seeded by `backend/schema.sql` on a fresh install. If you're
running this against your existing database instead, load it directly:

```bash
mysql -u root -p attendance_system < backend/seed_admin.sql
```

Change the password after your first login:

```bash
node scripts/resetAdminPassword.js admin "your-new-password"
```

## 3. Running an event

There are three shapes an event can take, chosen by which button you press
while it's still "not started":

**Full flow — log both arrival and departure**
1. Create an event, then click **Start time-in**. The kiosk shows "Time-In is
   open" and accepts scans.
2. When it's time, click **Start time-out**. The kiosk switches to "Time-Out
   is open." Students who already timed in can now scan to time out.
3. Click **End event**. The report now treats every remaining "timed in
   only" row as flaggable — they genuinely didn't log out.

**Time-in only — just an arrival record**
1. Create an event, click **Start time-in**.
2. When done, click **End event early** instead of ever opening time-out.
   The report marks anyone with a time-in as complete — it won't ask them
   to have logged out, since that was never part of this event.

**Time-out only — just a departure record, no arrival check**
1. Create an event, click **Start time-out only** right away (skipping
   time-in entirely). The kiosk shows "Time-Out is open" immediately.
2. A scan creates a fresh time-out record on the spot — no prior time-in is
   required or possible for this event.
3. Click **End event** when done. Anyone who never scanned shows as having
   no log, same as any other flagging case.

The kiosk polls for the active event every few seconds, so it picks up phase
changes on its own — no refresh needed, though a scan attempt also re-checks
immediately after.

## 4. Editing, deleting, and reading the report

**Editing** — click **Edit** next to an event's name to change its name or
date. Works regardless of status; it only relabels the event, so it can't
disturb anything already scanned. (This also fixed a display bug: event
dates were coming back from the database as full timestamps like
`2026-09-07T16:00:00.000Z` instead of a plain date — `backend/db.js` now
tells the driver to keep `DATE` columns as plain strings, which is what
made the Edit form's date field usable in the first place.)

**Deleting** — the **Delete event** button only appears while an event is
"not started." That's deliberate: by definition, nothing can have been
scanned for an event that hasn't opened yet, so deleting it is always a
clean removal with nothing left behind. Once an event has started, "delete"
isn't offered — **End event** is the right action instead, since it closes
scanning while keeping every attendance and sanction record intact for
later reference.

**Reading the report** — there are now four real outcomes instead of three:
`Complete`, `Timed in only`, `Timed out only`, and `No log`, each with its
own filter tab. What counts as "fine" vs. "flaggable" for `Timed in only`
and `Timed out only` depends on what the event actually asked for — a
`Timed out only` row is a perfectly normal, complete result for a
time-out-only event, and only becomes flaggable if the event actually
expected a time-in that never happened (which, given how scanning is
gated, is effectively unreachable — see below). `AttendanceTable.vue`'s
`classify()` function is the one place that logic lives.

## Sanction flag audit trail

Flagging or unflagging a student now writes to two places in one
transaction:
- `sanction_flags` — current state only, one row per student+event, what
  the report joins against.
- `sanction_flag_history` — append-only, never updated or deleted. Every
  flag and unflag gets its own permanent row: who did it, when, and with
  what reason.

Click **History** next to any flag button to see that student's full
history for the event inline. If a sanction is ever disputed, this is
where the record lives — not just "flagged," but the reason given at the
time and whether it was later reversed.

## Where the "no two-scan trick" logic actually lives

`backend/routes/attendance.js` — the `/api/attendance/scan` endpoint decides
what a scan does purely from the *event's* current status and how it was
opened, never from anything the request itself claims. There's no
`type: "time-in"` field a student could send to force one outcome or the
other. A time-out can only ever do one of two things: close an existing
time-in, or (only when the event was deliberately opened as time-out-only)
create a fresh time-out-only record — it can never create a backdated
time-in to go with it.

## Access control (unchanged from before, plus one addition)

- `backend/middleware/requireAdmin.js` still guards every `/api/admin/*`
  route, including the new event controls — a valid admin token is required
  regardless of what the frontend sends.
- `GET /api/events/active` is the one intentionally public endpoint — the
  kiosk needs to know the current phase before anyone has logged in.
- Admin accounts are still only created via `npm run create-admin -- username
  password "Name"` — no sign-up screen.
- New: `POST /api/auth/login` is now rate-limited to 5 attempts per 15
  minutes per IP (`backend/middleware/loginLimiter.js`), so the `admin`
  account isn't an open door to brute-forcing.
