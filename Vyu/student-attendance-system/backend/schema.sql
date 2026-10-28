CREATE DATABASE IF NOT EXISTS attendance_system;
USE attendance_system;

CREATE TABLE IF NOT EXISTS students (
  id INT PRIMARY KEY AUTO_INCREMENT,
  student_number VARCHAR(20) UNIQUE NOT NULL,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  course VARCHAR(100) NOT NULL,
  year_section VARCHAR(20) NOT NULL,
  qr_value VARCHAR(255) UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS enrollment_masterlist (
  student_number VARCHAR(20) PRIMARY KEY,
  full_name VARCHAR(200),
  status ENUM('enrolled', 'not_enrolled') DEFAULT 'enrolled'
);

-- Sample masterlist rows so registration has something to check against.
-- Replace with your school's real enrollment data (e.g. imported from the registrar's CSV).
INSERT INTO enrollment_masterlist (student_number, full_name, status) VALUES
  ('2024-0433-R', 'Erwin Gail O. Orquillano', 'enrolled'),
  ('2024-0106-R', 'Consuelo Villanueva', 'enrolled'),
  ('2024-0409-R', 'Maria Torres', 'enrolled'),
  ('2024-0434-R', 'Eduardo Mendoza', 'enrolled'),
  ('2024-0488-R', 'Carlos Aguilar', 'enrolled'),
  ('2024-0520-R', 'Teresa Domingo', 'enrolled'),
  ('2024-1424-R', 'Antonio Lazaro', 'enrolled'),
  ('2024-1535-R', 'Isabel Santos', 'enrolled'),
  ('2024-1679-R', 'Miguel Del Rosario', 'enrolled'),
  ('2024-1824-R', 'Juan Dela Cruz', 'enrolled'),
  ('2024-2286-R', 'Carmela Ramos', 'enrolled'),
  ('2024-2615-R', 'Roberto Fernandez', 'enrolled'),
  ('2024-3257-R', 'Francisco Marquez', 'enrolled'),
  ('2024-3582-R', 'Manuel Flores', 'enrolled'),
  ('2024-3611-R', 'Josefina Aquino', 'enrolled'),
  ('2024-3657-R', 'Pedro Pineda', 'enrolled'),
  ('2024-3811-R', 'Corazon Gonzales', 'enrolled'),
  ('2024-4012-R', 'Ana Ocampo', 'enrolled'),
  ('2024-4506-R', 'Jose Rivera', 'enrolled'),
  ('2024-4557-R', 'Fernando Reyes', 'enrolled'),
  ('2024-6873-R', 'Alberto Bautista', 'enrolled'),
  ('2024-6912-R', 'Ramon Castillo', 'enrolled'),
  ('2024-6924-R', 'Victoria Cruz', 'enrolled'),
  ('2024-7359-R', 'Ricardo Salazar', 'enrolled'),
  ('2024-8279-R', 'Rafael Valdez', 'enrolled'),
  ('2024-8928-R', 'Dolores Manalo', 'enrolled'),
  ('2024-8935-R', 'Rosa Navarro', 'enrolled'),
  ('2024-9195-R', 'Beatriz Pascual', 'enrolled'),
  ('2024-9654-R', 'Remedios Espiritu', 'enrolled'),
  ('2024-9674-R', 'Luz Garcia', 'enrolled'),
  ('2024-9863-R', 'Angela Rosario', 'enrolled')
ON DUPLICATE KEY UPDATE student_number = student_number;

-- Admin accounts. No sign-up screen exists on purpose — see backend/scripts/createAdmin.js.
CREATE TABLE IF NOT EXISTS admins (
  id INT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(50) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  password_salt VARCHAR(255) NOT NULL,
  full_name VARCHAR(150),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Ready-to-use account so a fresh setup has something to log in with.
--   username: admin
--   password: vLfMnP56oeUS
-- Change this after your first login (see backend/seed_admin.sql for how).
INSERT INTO admins (username, password_hash, password_salt, full_name)
VALUES (
  'admin',
  'ba8c896d67b64d8321c859f4e9763569f4d878d2ac390d4e01b9d1b1dd3450122eb81c47a52aaa82403ccc32973b757ea4cbbe51f88fdfe29ac69d9eea204a79',
  'b4f15f37da8fddc97c9afbfcfdc8951d',
  'Administrator'
)
ON DUPLICATE KEY UPDATE username = username;

-- One row per school event. The admin drives this through its states:
--   not_started -> time_in_open -> time_out_open -> ended
-- The kiosk only allows scanning while status is time_in_open or time_out_open.
CREATE TABLE IF NOT EXISTS events (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(150) NOT NULL,
  event_date DATE NOT NULL,
  status ENUM('not_started', 'time_in_open', 'time_out_open', 'ended') NOT NULL DEFAULT 'not_started',
  time_in_opened_at DATETIME,
  time_out_opened_at DATETIME,
  ended_at DATETIME,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- One row per student per event (not per day — a student can attend many events).
CREATE TABLE IF NOT EXISTS attendance_logs (
  id INT PRIMARY KEY AUTO_INCREMENT,
  student_id INT NOT NULL,
  event_id INT NOT NULL,
  time_in DATETIME,
  time_out DATETIME,
  FOREIGN KEY (student_id) REFERENCES students(id),
  FOREIGN KEY (event_id) REFERENCES events(id),
  UNIQUE KEY unique_event_attendance (student_id, event_id)
);

-- Sanctions are per event, not per date, matching attendance_logs.
CREATE TABLE IF NOT EXISTS sanction_flags (
  id INT PRIMARY KEY AUTO_INCREMENT,
  student_id INT NOT NULL,
  event_id INT NOT NULL,
  flagged_by INT NOT NULL,
  reason VARCHAR(255),
  flagged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (student_id) REFERENCES students(id),
  FOREIGN KEY (event_id) REFERENCES events(id),
  FOREIGN KEY (flagged_by) REFERENCES admins(id),
  UNIQUE KEY unique_flag (student_id, event_id)
);

-- Append-only. sanction_flags above holds CURRENT state only (one row per
-- student+event, overwritten on re-flag) — this table never gets updated or
-- deleted, only inserted into, so a disputed sanction can always be traced
-- back to who flagged it, when, why, and whether it was later undone.
CREATE TABLE IF NOT EXISTS sanction_flag_history (
  id INT PRIMARY KEY AUTO_INCREMENT,
  student_id INT NOT NULL,
  event_id INT NOT NULL,
  action ENUM('flagged', 'unflagged') NOT NULL,
  reason VARCHAR(255),
  performed_by INT NOT NULL,
  performed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (student_id) REFERENCES students(id),
  FOREIGN KEY (event_id) REFERENCES events(id),
  FOREIGN KEY (performed_by) REFERENCES admins(id)
);


-- Adds one ready-to-use admin account.
--   username: admin
--   password: vLfMnP56oeUS
--
-- Run this against your EXISTING database:
--   mysql -u root -p attendance_system < backend/seed_admin.sql
--
-- Safe to re-run — it will just reset this account back to the password
-- above rather than erroring on a duplicate username.
--
-- Change this password after your first login with:
--   node scripts/resetAdminPassword.js admin "your-new-password"


INSERT INTO admins (username, password_hash, password_salt, full_name)
VALUES (
  'admin',
  'ba8c896d67b64d8321c859f4e9763569f4d878d2ac390d4e01b9d1b1dd3450122eb81c47a52aaa82403ccc32973b757ea4cbbe51f88fdfe29ac69d9eea204a79',
  'b4f15f37da8fddc97c9afbfcfdc8951d',
  'Administrator'
)
ON DUPLICATE KEY UPDATE
  password_hash = VALUES(password_hash),
  password_salt = VALUES(password_salt),
  full_name = VALUES(full_name);


-- Run this ONCE against your existing attendance_system database to move
-- from date-based attendance to event-based attendance.
--
-- attendance_logs and sanction_flags change shape (log_date -> event_id),
-- so this drops and recreates just those two tables. Your students,
-- enrollment_masterlist, and admins tables — and all their data — are
-- untouched. Any attendance/sanction test data you scanned in before this
-- point does not carry forward; that's expected for a schema change like
-- this during development.


DROP TABLE IF EXISTS sanction_flags;
DROP TABLE IF EXISTS attendance_logs;

CREATE TABLE IF NOT EXISTS events (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(150) NOT NULL,
  event_date DATE NOT NULL,
  status ENUM('not_started', 'time_in_open', 'time_out_open', 'ended') NOT NULL DEFAULT 'not_started',
  time_in_opened_at DATETIME,
  time_out_opened_at DATETIME,
  ended_at DATETIME,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE attendance_logs (
  id INT PRIMARY KEY AUTO_INCREMENT,
  student_id INT NOT NULL,
  event_id INT NOT NULL,
  time_in DATETIME,
  time_out DATETIME,
  FOREIGN KEY (student_id) REFERENCES students(id),
  FOREIGN KEY (event_id) REFERENCES events(id),
  UNIQUE KEY unique_event_attendance (student_id, event_id)
);

CREATE TABLE sanction_flags (
  id INT PRIMARY KEY AUTO_INCREMENT,
  student_id INT NOT NULL,
  event_id INT NOT NULL,
  flagged_by INT NOT NULL,
  reason VARCHAR(255),
  flagged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (student_id) REFERENCES students(id),
  FOREIGN KEY (event_id) REFERENCES events(id),
  FOREIGN KEY (flagged_by) REFERENCES admins(id),
  UNIQUE KEY unique_flag (student_id, event_id)
);

-- Adds the audit trail for sanction flags. Purely additive — no existing
-- table is touched, so your students, events, and current flags are safe.
-- Run once against your existing database:
--   mysql -u root -p attendance_system < backend/migrate_add_flag_history.sql


CREATE TABLE IF NOT EXISTS sanction_flag_history (
  id INT PRIMARY KEY AUTO_INCREMENT,
  student_id INT NOT NULL,
  event_id INT NOT NULL,
  action ENUM('flagged', 'unflagged') NOT NULL,
  reason VARCHAR(255),
  performed_by INT NOT NULL,
  performed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (student_id) REFERENCES students(id),
  FOREIGN KEY (event_id) REFERENCES events(id),
  FOREIGN KEY (performed_by) REFERENCES admins(id)
);
