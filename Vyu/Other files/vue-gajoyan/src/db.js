import Database from 'better-sqlite3';
import bcrypt from 'bcryptjs';

export const db = new Database(process.env.DB_PATH || 'library.sqlite');
db.pragma('journal_mode = WAL');
db.pragma('foreign_keys = ON');
db.exec(`
CREATE TABLE IF NOT EXISTS users (
 id INTEGER PRIMARY KEY, name TEXT NOT NULL, email TEXT NOT NULL UNIQUE,
 password_hash TEXT NOT NULL, role TEXT NOT NULL CHECK(role IN ('member','librarian','admin')),
 created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS books (
 id INTEGER PRIMARY KEY, isbn TEXT UNIQUE, title TEXT NOT NULL, author TEXT NOT NULL,
 category TEXT NOT NULL DEFAULT '', total_copies INTEGER NOT NULL CHECK(total_copies>=0),
 available_copies INTEGER NOT NULL CHECK(available_copies>=0 AND available_copies<=total_copies),
 created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS loans (
 id INTEGER PRIMARY KEY, member_id INTEGER NOT NULL REFERENCES users(id),
 book_id INTEGER NOT NULL REFERENCES books(id), issued_by INTEGER NOT NULL REFERENCES users(id),
 returned_by INTEGER REFERENCES users(id), borrowed_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
 due_at TEXT NOT NULL, returned_at TEXT
);
CREATE INDEX IF NOT EXISTS idx_loans_member ON loans(member_id,returned_at);
CREATE INDEX IF NOT EXISTS idx_loans_open ON loans(returned_at,due_at);
`);
if (!db.prepare("SELECT 1 FROM users WHERE role='admin'").get()) {
  const email = process.env.ADMIN_EMAIL?.trim().toLowerCase();
  const password = process.env.ADMIN_PASSWORD;
  if (!email || !password || password.length < 12) {
    throw new Error('First run requires ADMIN_EMAIL and ADMIN_PASSWORD (12+ characters)');
  }
  db.prepare("INSERT INTO users(name,email,password_hash,role) VALUES(?,?,?,'admin')")
    .run('Library Administrator',email,bcrypt.hashSync(password,12));
}
