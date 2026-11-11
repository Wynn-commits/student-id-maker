import { createApp } from 'vue'
import { createRouter, createWebHashHistory } from 'vue-router'
import App from './App.vue'
import { session } from './store'
import './styles.css'

const staff = ['admin', 'staff']
const routes = [
  { path: '/login', component: () => import('./views/Login.vue') },
  { path: '/dashboard', component: () => import('./views/Dashboard.vue'), meta: { roles: staff } },
  { path: '/records', component: () => import('./views/Records.vue'), meta: { roles: staff } },
  { path: '/records/new', component: () => import('./views/RecordForm.vue'), meta: { roles: staff } },
  { path: '/records/:id', component: () => import('./views/RecordForm.vue'), meta: { roles: staff } },
  { path: '/print', component: () => import('./views/Print.vue'), meta: { roles: staff } },
  { path: '/my-id', component: () => import('./views/RecordForm.vue'), meta: { roles: ['student'] } },
  { path: '/:pathMatch(.*)*', redirect: '/login' }
]
const router = createRouter({ history: createWebHashHistory(), routes })
const home = u => (u.role === 'student' ? '/my-id' : '/dashboard')

// Access control: only signed-in users, and only the pages their role allows
router.beforeEach(to => {
  const u = session.user
  if (!u) return to.path === '/login' ? true : '/login'
  if (to.path === '/login') return home(u)
  if (to.meta.roles && !to.meta.roles.includes(u.role)) return home(u)
})
createApp(App).use(router).mount('#app')
