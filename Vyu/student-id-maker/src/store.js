import { reactive, watch } from 'vue'

export const PROGRAMS = ['BS Information Technology', 'BS Computer Science', 'BS Information Systems', 'College of Computer Studies (Faculty)', 'Administrative Office (Staff)']
export const TYPES = ['Student', 'Faculty', 'Staff']
export const STATUSES = ['Pending', 'Approved', 'Printed', 'Released', 'Rejected']
export const AY = 'A.Y. 2026 - 2027'
export const DEMO_ACCOUNTS = [
  { id: 'u1', username: 'admin', password: 'Admin@2026', name: 'System Administrator', role: 'admin', label: 'Administrator' },
  { id: 'u2', username: 'idofficer', password: 'Officer@2026', name: 'ID Officer', role: 'staff', label: 'ID Officer' },
  { id: 'u3', username: 'student', password: 'Student@2026', name: 'Demo Student', role: 'student', label: 'Student' }
]

// Prototype-only password hashing. A real deployment needs a server-side backend.
export const h = s => { let a = 5381, b = 52711; for (const c of 'cpsu' + s) { a = (a * 33) ^ c.charCodeAt(0); b = (b * 31 + c.charCodeAt(0)) | 0 } return (a >>> 0).toString(36) + (b >>> 0).toString(36) }

const rec = (id, last, first, middle, idNo, type, program, status) => ({ id, ownerId: null, last, first, middle, idNo, type, program, photo: '', status, remarks: '', updated: Date.now() })
const seed = () => ({
  users: DEMO_ACCOUNTS.map(({ password, label, ...user }) => ({ ...user, pw: h(password) })),
  records: [
    rec('r1', 'Judiana', 'Lyra Michelle', 'S.', '2026-0001', 'Student', PROGRAMS[0], 'Approved'),
    rec('r2', 'Panunciar', 'Mayome', 'L.', '2026-0002', 'Student', PROGRAMS[1], 'Printed'),
    rec('r3', 'Libongcogon', 'Leah', 'V.', '2026-0003', 'Student', PROGRAMS[2], 'Pending'),
    rec('r4', 'Piala', 'Angeline', 'V.', '2026-0004', 'Student', PROGRAMS[0], 'Released'),
    rec('r5', 'Santiago', 'Feleciano', 'L.', 'F-2026-01', 'Faculty', PROGRAMS[3], 'Approved')
  ],
  log: []
})

const KEY = 'cpsu-idmaker-v1'
export const db = reactive(JSON.parse(localStorage.getItem(KEY) || 'null') || seed())
watch(db, v => localStorage.setItem(KEY, JSON.stringify(v)), { deep: true })
export const session = reactive({ user: JSON.parse(sessionStorage.getItem('cpsu-s') || 'null') })

export function log(action, rid) {
  db.log.unshift({ t: Date.now(), by: session.user ? session.user.name : '-', action, rid })
  db.log.splice(100)
}
export function login(u, p) {
  const x = db.users.find(a => a.username === u.trim() && a.pw === h(p))
  if (!x) return false
  session.user = { id: x.id, name: x.name, role: x.role }
  sessionStorage.setItem('cpsu-s', JSON.stringify(session.user))
  log('Signed in')
  return true
}
export function logout() { log('Signed out'); session.user = null; sessionStorage.removeItem('cpsu-s') }

export function save(f) {
  const dup = db.records.find(r => r.idNo.toLowerCase() === f.idNo.toLowerCase() && r.id !== f.id)
  if (dup) return 'ID number ' + f.idNo + ' already exists.'
  if (f.id) { Object.assign(db.records.find(r => r.id === f.id), f, { updated: Date.now() }); log('Updated record ' + f.idNo, f.id) }
  else { f.id = 'r' + Date.now(); f.updated = Date.now(); db.records.push({ ...f }); log('Created record ' + f.idNo, f.id) }
}
export function setStatus(id, status, remarks = '') {
  const r = db.records.find(x => x.id === id)
  r.status = status; r.remarks = remarks; r.updated = Date.now()
  log(status + ': ' + r.idNo, id)
}
export function remove(id) {
  const i = db.records.findIndex(r => r.id === id)
  log('Deleted record ' + db.records[i].idNo, id)
  db.records.splice(i, 1)
}
