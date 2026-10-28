import { Router } from 'express';
import pool from '../db.js';
import { requireAdmin } from '../middleware/requireAdmin.js';

const router = Router();

// Every route below this line requires a valid admin token.
router.use(requireAdmin);

// POST /api/admin/flag  { student_id, event_id, reason? }
// Flags (or re-flags with a new reason) a student for sanction on an event.
//
// sanction_flags holds only the CURRENT state (one row per student+event,
// overwritten on re-flag) so the attendance report can join against it
// cheaply. sanction_flag_history is separate and append-only — every flag
// and unflag action gets its own permanent row there, so if a sanction is
// ever disputed, there's a full record of who flagged it, when, with what
// reason, and whether it was later undone. Both writes happen in one
// transaction so they can't drift apart.
router.post('/flag', async (req, res) => {
  const { student_id, event_id, reason } = req.body;
  if (!student_id || !event_id) {
    return res.status(400).json({ error: 'student_id and event_id are required.' });
  }

  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();
    await conn.query(
      `INSERT INTO sanction_flags (student_id, event_id, flagged_by, reason)
       VALUES (?, ?, ?, ?)
       ON DUPLICATE KEY UPDATE reason = VALUES(reason), flagged_by = VALUES(flagged_by), flagged_at = CURRENT_TIMESTAMP`,
      [student_id, event_id, req.admin.id, reason || null]
    );
    await conn.query(
      `INSERT INTO sanction_flag_history (student_id, event_id, action, reason, performed_by)
       VALUES (?, ?, 'flagged', ?, ?)`,
      [student_id, event_id, reason || null, req.admin.id]
    );
    await conn.commit();
    res.status(201).json({ message: 'Student flagged for sanction.' });
  } catch (err) {
    await conn.rollback();
    res.status(500).json({ error: err.message });
  } finally {
    conn.release();
  }
});

// DELETE /api/admin/flag/:studentId/:eventId
router.delete('/flag/:studentId/:eventId', async (req, res) => {
  const { studentId, eventId } = req.params;

  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();
    // Capture the reason that's being undone before it's gone, so the
    // history entry records what was actually removed.
    const [existing] = await conn.query(
      'SELECT reason FROM sanction_flags WHERE student_id = ? AND event_id = ?',
      [studentId, eventId]
    );
    await conn.query('DELETE FROM sanction_flags WHERE student_id = ? AND event_id = ?', [studentId, eventId]);
    await conn.query(
      `INSERT INTO sanction_flag_history (student_id, event_id, action, reason, performed_by)
       VALUES (?, ?, 'unflagged', ?, ?)`,
      [studentId, eventId, existing[0]?.reason || null, req.admin.id]
    );
    await conn.commit();
    res.json({ message: 'Flag removed.' });
  } catch (err) {
    await conn.rollback();
    res.status(500).json({ error: err.message });
  } finally {
    conn.release();
  }
});

// GET /api/admin/flag-history/:studentId/:eventId -> full audit trail for
// one student's flag status on one event, oldest first.
router.get('/flag-history/:studentId/:eventId', async (req, res) => {
  const { studentId, eventId } = req.params;
  try {
    const [rows] = await pool.query(
      `SELECT h.action, h.reason, h.performed_at, a.username AS performed_by
       FROM sanction_flag_history h
       JOIN admins a ON a.id = h.performed_by
       WHERE h.student_id = ? AND h.event_id = ?
       ORDER BY h.performed_at ASC`,
      [studentId, eventId]
    );
    res.json({ history: rows });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// GET /api/admin/me -> lets the frontend confirm a token is still valid.
router.get('/me', (req, res) => {
  res.json({ id: req.admin.id, username: req.admin.username });
});

export default router;
