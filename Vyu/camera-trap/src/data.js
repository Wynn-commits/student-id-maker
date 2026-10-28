import { reactive } from 'vue'

export const auth = reactive({ user: null })

export const stats = { population: 38, individuals: 31, sightings30: 124, camerasActive: '6 / 8' }
export const weekly = [18, 25, 16, 32, 28, 40, 22, 34]
export const recent = [['M-007', 'CT-03', '06:42'], ['M-012', 'CT-01', '06:15'], ['M-003', 'CT-05', '05:58'], ['New', 'CT-02', '05:31'], ['M-019', 'CT-04', '05:07']]
export const profiles = [['M-001', 14, 'CT-02'], ['M-002', 9, 'CT-03'], ['M-003', 22, 'CT-04'], ['M-007', 31, 'CT-03'], ['M-012', 6, 'CT-03'], ['M-015', 11, 'CT-01'], ['M-019', 17, 'CT-05'], ['M-021', 4, 'CT-02']].map(([id, sightings, last]) => ({ id, sightings, last }))
export const cameras = reactive([
  { id: 'CT-01', loc: 'Site A', ok: true, bat: 82, up: 'Today 06:15' }, { id: 'CT-02', loc: 'Site A', ok: true, bat: 64, up: 'Today 05:31' },
  { id: 'CT-03', loc: 'Site B', ok: true, bat: 91, up: 'Today 06:42' }, { id: 'CT-04', loc: 'Site B', ok: true, bat: 47, up: 'Today 05:07' },
  { id: 'CT-05', loc: 'Site C', ok: true, bat: 73, up: 'Today 05:58' }, { id: 'CT-06', loc: 'Site C', ok: false, bat: 12, up: '3 days ago' }])
export const queue = { total: 342, start: 128, items: [{ cam: 'CT-03', time: '06:42', id: 'M-007', conf: 91, det: 0.94 }, { cam: 'CT-01', time: '06:15', id: 'M-012', conf: 88, det: 0.92 }, { cam: 'CT-05', time: '05:58', id: 'M-003', conf: 86, det: 0.9 }] }
export const users = [['Admin', 'Administrator'], ['researcher01', 'Research team']]
