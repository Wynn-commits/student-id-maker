import { Router } from 'express'
import bcrypt from 'bcryptjs'
import jwt from 'jsonwebtoken'
import { db } from '../db.js'
import { requiredText, positiveId, protect, allow, handler } from '../security.js'

const router = Router()
router.post(
  '/login',
  handler((req, res) => {
    const email = requiredText(req.body.email, 'email', 254).toLowerCase()
    const password = req.body.password
    const user = db.prepare('SELECT * FROM users WHERE email=?').get(email)
    if (
      !user ||
      typeof password !== 'string' ||
      !bcrypt.compareSync(password, user.password_hash)
    ) {
      return res.status(401).json({ error: 'Invalid credentials' })
    }
    res.json({
      token: jwt.sign({ id: user.id }, process.env.JWT_SECRET, {
        expiresIn: '8h',
        algorithm: 'HS256',
      }),
      user: { id: user.id, name: user.name, email: user.email, role: user.role },
    })
  }),
)
router.post(
  '/signup',
  handler((req, res) => {
    const name = requiredText(req.body.name, 'name')
    const email = requiredText(req.body.email, 'email', 254).toLowerCase()
    const password = requiredText(req.body.password, 'password', 256)
    if (password.length < 12)
      return res.status(400).json({ error: 'Password must be 12+ characters' })
    const id = db
      .prepare("INSERT INTO users(name,email,password_hash,role) VALUES(?,?,?,'member')")
      .run(name, email, bcrypt.hashSync(password, 12)).lastInsertRowid
    res.status(201).json({ id })
  }),
)
router.get(
  '/me',
  protect,
  handler((req, res) => {
    const user = db.prepare('SELECT id,name,email,role FROM users WHERE id=?').get(req.user.id)
    if (!user) return res.status(401).json({ error: 'Account not found' })
    res.json(user)
  }),
)
router.get(
  '/members',
  protect,
  allow('admin', 'librarian'),
  handler((req, res) => {
    res.json(
      db
        .prepare("SELECT id,name,email FROM users WHERE role='member' ORDER BY name LIMIT 200")
        .all(),
    )
  }),
)
router.post(
  '/members',
  protect,
  allow('admin', 'librarian'),
  handler((req, res) => {
    const name = requiredText(req.body.name, 'name')
    const email = requiredText(req.body.email, 'email', 254).toLowerCase()
    const password = requiredText(req.body.password, 'password', 256)
    if (password.length < 12)
      return res.status(400).json({ error: 'Password must be 12+ characters' })
    const id = db
      .prepare("INSERT INTO users(name,email,password_hash,role) VALUES(?,?,?,'member')")
      .run(name, email, bcrypt.hashSync(password, 12)).lastInsertRowid
    res.status(201).json({ id })
  }),
)
router.post(
  '/staff',
  protect,
  allow('admin'),
  handler((req, res) => {
    const name = requiredText(req.body.name, 'name')
    const email = requiredText(req.body.email, 'email', 254).toLowerCase()
    const password = requiredText(req.body.password, 'password', 256)
    if (password.length < 12)
      return res.status(400).json({ error: 'Password must be 12+ characters' })
    const id = db
      .prepare("INSERT INTO users(name,email,password_hash,role) VALUES(?,?,?,'librarian')")
      .run(name, email, bcrypt.hashSync(password, 12)).lastInsertRowid
    res.status(201).json({ id })
  }),
)
export default router
