import { Router } from 'express';
import pool from '../db.js';

const router = Router();

// GET /api/students/:code -> look up a single student by student number or QR value
router.get('/:code', async (req, res) => {
  const { code } = req.params;
  try {
    const [rows] = await pool.query(
      'SELECT * FROM students WHERE student_number = ? OR qr_value = ? LIMIT 1',
      [code, code]
    );
    if (rows.length === 0) return res.status(404).json({ error: 'Student not found' });
    res.json(rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// POST /api/students -> registration flow (Valid data? / Enrolled? / Already registered? / Save / Generate QR)
router.post('/', async (req, res) => {
  const { student_number, first_name, last_name, course, year_section } = req.body;

  // Valid data?
  if (!student_number || !first_name || !last_name || !course || !year_section) {
    return res.status(400).json({ error: 'Please fill in all required fields.' });
  }

  try {
    // Enrolled in school?
    const [enrolled] = await pool.query(
      "SELECT * FROM enrollment_masterlist WHERE student_number = ? AND status = 'enrolled'",
      [student_number]
    );
    if (enrolled.length === 0) {
      return res.status(403).json({ error: 'Student is not enrolled in school.' });
    }

    // Already registered?
    const [existing] = await pool.query(
      'SELECT * FROM students WHERE student_number = ?',
      [student_number]
    );
    if (existing.length > 0) {
      return res.status(409).json({ error: 'Student is already registered.' });
    }

    // Save to database + Generate QR code (QR simply encodes the student number)
    const qr_value = student_number;
    await pool.query(
      'INSERT INTO students (student_number, first_name, last_name, course, year_section, qr_value) VALUES (?, ?, ?, ?, ?, ?)',
      [student_number, first_name, last_name, course, year_section, qr_value]
    );

    res.status(201).json({ message: 'Registered successfully', qr_value });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

export default router;
