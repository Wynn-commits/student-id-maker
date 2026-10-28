import { Router } from 'express';
import pool from '../db.js';

const router = Router();

// POST /api/attendance/scan -> the only scan endpoint, but what a scan DOES
// depends entirely on the active event's phase, not on the student's own
// history. This is what makes it impossible to scan twice in a row to grab
// both a time-in and a time-out: during time_in_open a second scan just
// finds an existing log and refuses; a time-out can only close an EXISTING
// time-in unless this event never had a time-in phase at all (a genuine
// time-out-only event — see the time_out_open branch below).
router.post('/scan', async (req, res) => {
  const { code } = req.body;
  if (!code) return res.status(400).json({ error: 'No code provided.' });

  try {
    // QR/ID recognized?
    const [students] = await pool.query(
      'SELECT * FROM students WHERE student_number = ? OR qr_value = ? LIMIT 1',
      [code, code]
    );
    if (students.length === 0) {
      return res.status(404).json({ error: 'Invalid QR/ID.' });
    }
    const student = students[0];

    // Is there an event currently open for scanning at all?
    const [activeEvents] = await pool.query(
      `SELECT * FROM events WHERE status IN ('time_in_open', 'time_out_open') ORDER BY id DESC LIMIT 1`
    );
    if (activeEvents.length === 0) {
      return res.status(409).json({ error: 'No event is currently open for attendance.' });
    }
    const event = activeEvents[0];

    const [logs] = await pool.query(
      'SELECT * FROM attendance_logs WHERE student_id = ? AND event_id = ?',
      [student.id, event.id]
    );

    if (event.status === 'time_in_open') {
      if (logs.length > 0) {
        return res.status(409).json({
          error: 'You have already logged in for this event. Please wait for time-out to open.',
          student,
          event,
        });
      }
      const [result] = await pool.query(
        'INSERT INTO attendance_logs (student_id, event_id, time_in) VALUES (?, ?, NOW())',
        [student.id, event.id]
      );
      const [logRows] = await pool.query('SELECT * FROM attendance_logs WHERE id = ?', [result.insertId]);
      return res.json({ action: 'time-in', student, event, log: logRows[0] });
    }

    // event.status === 'time_out_open'
    if (logs.length > 0) {
      if (logs[0].time_out) {
        return res.status(409).json({ error: 'You have already logged out for this event.', student, event });
      }
      // Closing out an existing time-in — the normal full time-in/time-out flow.
      await pool.query('UPDATE attendance_logs SET time_out = NOW() WHERE id = ?', [logs[0].id]);
      const [logRows] = await pool.query('SELECT * FROM attendance_logs WHERE id = ?', [logs[0].id]);
      return res.json({ action: 'time-out', student, event, log: logRows[0] });
    }

    // No existing log for this student at this event. Whether that's allowed
    // depends on whether this event ever had a time-in phase at all:
    // - time_in_opened_at is null -> the admin opened time-out directly from
    //   "not started" (a time-out-only event, e.g. logging dismissal times
    //   with no arrival check). A fresh time-out-only record is expected.
    // - time_in_opened_at is set -> this event DID have a time-in window,
    //   and this student just never showed up for it. Letting them scan
    //   straight into a time-out here would defeat the whole point.
    if (!event.time_in_opened_at) {
      const [result] = await pool.query(
        'INSERT INTO attendance_logs (student_id, event_id, time_out) VALUES (?, ?, NOW())',
        [student.id, event.id]
      );
      const [logRows] = await pool.query('SELECT * FROM attendance_logs WHERE id = ?', [result.insertId]);
      return res.json({ action: 'time-out', student, event, log: logRows[0] });
    }

    return res.status(409).json({
      error: 'No time-in record found for this event — you cannot time out.',
      student,
      event,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

export default router;
