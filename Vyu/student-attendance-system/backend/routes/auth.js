import { Router } from 'express';
import jwt from 'jsonwebtoken';
import pool from '../db.js';
import { verifyPassword } from '../utils/password.js';
import { loginLimiter } from '../middleware/loginLimiter.js';

const router = Router();

// POST /api/auth/login -> the only unauthenticated route in this file.
// Everything under /api/admin requires the token this issues.
router.post('/login', loginLimiter, async (req, res) => {
  const { username, password } = req.body;
  if (!username || !password) {
    return res.status(400).json({ error: 'Username and password are required.' });
  }

  try {
    const [rows] = await pool.query('SELECT * FROM admins WHERE username = ? LIMIT 1', [username]);
    if (rows.length === 0) {
      return res.status(401).json({ error: 'Invalid username or password.' });
    }

    const admin = rows[0];
    const valid = verifyPassword(password, admin.password_hash, admin.password_salt);
    if (!valid) {
      return res.status(401).json({ error: 'Invalid username or password.' });
    }

    const token = jwt.sign(
      { id: admin.id, username: admin.username, role: 'admin' },
      process.env.JWT_SECRET,
      { expiresIn: '8h' }
    );

    res.json({
      token,
      admin: { id: admin.id, username: admin.username, full_name: admin.full_name },
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

export default router;
