import { Router } from 'express';
import pool from '../db.js';

const router = Router();

// GET /api/events/active -> the event currently open for scanning, if any.
// No auth here on purpose — the kiosk needs this before anyone logs in.
router.get('/active', async (req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT * FROM events WHERE status IN ('time_in_open', 'time_out_open') ORDER BY id DESC LIMIT 1`
    );
    res.json({ event: rows[0] || null });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

export default router;
