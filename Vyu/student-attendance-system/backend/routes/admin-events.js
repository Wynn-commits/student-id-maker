import { Router } from 'express';
import pool from '../db.js';
import { requireAdmin } from '../middleware/requireAdmin.js';

const router = Router();

// Every route below requires a valid admin token.
router.use(requireAdmin);

// POST /api/admin/events  { name, event_date }
// Creates an event in "not_started" — scanning stays closed until the
// admin explicitly opens time-in.
router.post('/', async (req, res) => {
  const { name, event_date } = req.body;
  if (!name || !event_date) {
    return res.status(400).json({ error: 'name and event_date are required.' });
  }
  try {
    const [result] = await pool.query(
      `INSERT INTO events (name, event_date, status) VALUES (?, ?, 'not_started')`,
      [name, event_date]
    );
    const [rows] = await pool.query('SELECT * FROM events WHERE id = ?', [result.insertId]);
    res.status(201).json(rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// GET /api/admin/events -> most recent first, for the events list in the dashboard.
router.get('/', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM events ORDER BY id DESC LIMIT 50');
    res.json({ events: rows });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// GET /api/admin/events/:id/attendance -> full roster for this event, joined
// against attendance_logs and sanction_flags for THIS event only.
// Left-joined so students who never scanned at all still show up as "absent".
//
// Status is always one of the 4 literal categories below, based purely on
// which timestamps exist — it does NOT try to guess whether that's "good"
// or "bad" for this particular event. That judgment (e.g. "timed_out_only
// is actually the successful outcome for a time-out-only event") depends
// on the event's shape (time_in_opened_at / time_out_opened_at, included
// in the `event` object below) and is made by the dashboard when it
// decides whether to show a flag button. Keeping the raw status honest
// here is what makes a "Timed out only" filter tab meaningful instead of
// just an always-empty category.
router.get('/:id/attendance', async (req, res) => {
  const { id } = req.params;
  try {
    const [eventRows] = await pool.query('SELECT * FROM events WHERE id = ?', [id]);
    if (eventRows.length === 0) return res.status(404).json({ error: 'Event not found.' });
    const event = eventRows[0];

    const [rows] = await pool.query(
      `SELECT
         s.id AS student_id,
         s.student_number,
         s.first_name,
         s.last_name,
         s.course,
         s.year_section,
         l.time_in,
         l.time_out,
         f.id AS flag_id,
         f.reason AS flag_reason
       FROM students s
       LEFT JOIN attendance_logs l ON l.student_id = s.id AND l.event_id = ?
       LEFT JOIN sanction_flags f ON f.student_id = s.id AND f.event_id = ?
       ORDER BY s.last_name, s.first_name`,
      [id, id]
    );

    const students = rows.map((r) => {
      let status;
      if (r.time_in && r.time_out) status = 'complete';
      else if (r.time_in) status = 'timed_in_only';
      else if (r.time_out) status = 'timed_out_only';
      else status = 'absent';

      return {
        id: r.student_id,
        student_number: r.student_number,
        name: `${r.first_name} ${r.last_name}`,
        course: r.course,
        year_section: r.year_section,
        time_in: r.time_in,
        time_out: r.time_out,
        status,
        flagged: Boolean(r.flag_id),
        flag_id: r.flag_id,
        flag_reason: r.flag_reason,
      };
    });

    res.json({ event, students });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// POST /api/admin/events/:id/start-time-in
// Only legal from "not_started", and only one event can be open at a time —
// otherwise the kiosk's "which event is active" lookup would be ambiguous.
router.post('/:id/start-time-in', async (req, res) => {
  const { id } = req.params;
  try {
    const [openElsewhere] = await pool.query(
      `SELECT id FROM events WHERE status IN ('time_in_open', 'time_out_open') AND id != ?`,
      [id]
    );
    if (openElsewhere.length > 0) {
      return res.status(409).json({ error: 'Another event is already open. End it before starting a new one.' });
    }

    const [result] = await pool.query(
      `UPDATE events SET status = 'time_in_open', time_in_opened_at = NOW()
       WHERE id = ? AND status = 'not_started'`,
      [id]
    );
    if (result.affectedRows === 0) {
      return res.status(409).json({ error: 'This event has already been started.' });
    }
    const [rows] = await pool.query('SELECT * FROM events WHERE id = ?', [id]);
    res.json(rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// POST /api/admin/events/:id/start-time-out
// Legal from "time_in_open" (the normal continuation) OR directly from
// "not_started" (a time-out-only event — e.g. logging when students leave,
// with no arrival check at all). Either way, only one event may be open
// at a time.
router.post('/:id/start-time-out', async (req, res) => {
  const { id } = req.params;
  try {
    const [openElsewhere] = await pool.query(
      `SELECT id FROM events WHERE status IN ('time_in_open', 'time_out_open') AND id != ?`,
      [id]
    );
    if (openElsewhere.length > 0) {
      return res.status(409).json({ error: 'Another event is already open. End it before starting a new one.' });
    }

    const [result] = await pool.query(
      `UPDATE events SET status = 'time_out_open', time_out_opened_at = NOW()
       WHERE id = ? AND status IN ('not_started', 'time_in_open')`,
      [id]
    );
    if (result.affectedRows === 0) {
      return res.status(409).json({ error: 'This event cannot move to time-out from its current status.' });
    }
    const [rows] = await pool.query('SELECT * FROM events WHERE id = ?', [id]);
    res.json(rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// POST /api/admin/events/:id/end
// Closes scanning entirely. After this, "timed in only" in the report means
// the student genuinely didn't log out — not just that the event is ongoing.
router.post('/:id/end', async (req, res) => {
  const { id } = req.params;
  try {
    const [result] = await pool.query(
      `UPDATE events SET status = 'ended', ended_at = NOW()
       WHERE id = ? AND status IN ('time_in_open', 'time_out_open')`,
      [id]
    );
    if (result.affectedRows === 0) {
      return res.status(409).json({ error: 'This event is not currently open.' });
    }
    const [rows] = await pool.query('SELECT * FROM events WHERE id = ?', [id]);
    res.json(rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// PATCH /api/admin/events/:id  { name?, event_date? }
// Just relabels the event — doesn't touch status or any timestamp, so it's
// safe to use regardless of what phase the event is in.
router.patch('/:id', async (req, res) => {
  const { id } = req.params;
  const { name, event_date } = req.body;
  if (!name && !event_date) {
    return res.status(400).json({ error: 'Provide a name and/or event_date to update.' });
  }
  try {
    const fields = [];
    const values = [];
    if (name) {
      fields.push('name = ?');
      values.push(name);
    }
    if (event_date) {
      fields.push('event_date = ?');
      values.push(event_date);
    }
    values.push(id);

    const [result] = await pool.query(`UPDATE events SET ${fields.join(', ')} WHERE id = ?`, values);
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Event not found.' });
    }
    const [rows] = await pool.query('SELECT * FROM events WHERE id = ?', [id]);
    res.json(rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// DELETE /api/admin/events/:id
// Only allowed while status is "not_started". By that point in the
// lifecycle no attendance_logs or sanction_flags row could possibly
// reference this event yet (both only ever get written once time-in or
// time-out has opened), so this is always a clean delete — no cascading,
// no orphaned records, no audit history lost. An event that already ran
// should be ENDED, not deleted, so its attendance data and any sanction
// history stay intact for as long as anyone might need to reference it.
router.delete('/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const [result] = await pool.query(`DELETE FROM events WHERE id = ? AND status = 'not_started'`, [id]);
    if (result.affectedRows === 0) {
      return res.status(409).json({
        error: 'Only an event that has not been started yet can be deleted. End a started event instead.',
      });
    }
    res.json({ message: 'Event deleted.' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

export default router;
