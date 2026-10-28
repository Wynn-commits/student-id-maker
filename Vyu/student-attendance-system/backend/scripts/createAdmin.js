// Run from inside backend/ after copying this file in:
//   node scripts/createAdmin.js <username> <password> "Full Name"
//
// There's no sign-up screen on purpose — admin accounts are provisioned
// this way so a student can't self-register as staff.

import 'dotenv/config';
import pool from '../db.js';
import { hashPassword } from '../utils/password.js';

const [, , username, password, ...rest] = process.argv;
const fullName = rest.join(' ') || username;

if (!username || !password) {
  console.error('Usage: node scripts/createAdmin.js <username> <password> [full name]');
  process.exit(1);
}

if (password.length < 8) {
  console.error('Use a password of at least 8 characters.');
  process.exit(1);
}

const { hash, salt } = hashPassword(password);

try {
  await pool.query(
    'INSERT INTO admins (username, password_hash, password_salt, full_name) VALUES (?, ?, ?, ?)',
    [username, hash, salt, fullName]
  );
  console.log(`Admin "${username}" created.`);
} catch (err) {
  console.error('Failed to create admin:', err.message);
} finally {
  await pool.end();
}
