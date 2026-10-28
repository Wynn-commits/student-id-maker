import mysql from 'mysql2/promise';
import dotenv from 'dotenv';

dotenv.config();

const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'attendance_system',
  port: process.env.DB_PORT || 3306,
  waitForConnections: true,
  connectionLimit: 10,
  // Without this, mysql2 hands back DATE columns (like events.event_date)
  // as full JS Date objects, which JSON-serialize as e.g.
  // "2026-09-07T16:00:00.000Z" — a timezone-shifted timestamp for what's
  // actually just a calendar date. Keeping DATETIME/TIMESTAMP columns
  // (time_in, time_out, flagged_at, etc.) as real Dates is still correct;
  // this only affects plain dates.
  dateStrings: ['DATE'],
});

export default pool;
