import { createRouter, createWebHistory } from 'vue-router';
import LoginView from '../views/LoginView.vue';
import DashboardView from '../views/DashboardView.vue';
import auth from '../services/auth';

const routes = [
  { path: '/login', name: 'login', component: LoginView },
  { path: '/', name: 'dashboard', component: DashboardView, meta: { requiresAuth: true } },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

// Route-level guard. This makes the app FEEL gated, but it's not the real
// lock — a person could still call the API directly. The actual
// enforcement lives in requireAdmin.js on the backend.
router.beforeEach((to) => {
  if (to.meta.requiresAuth && !auth.isAuthenticated()) {
    return { name: 'login' };
  }
  if (to.name === 'login' && auth.isAuthenticated()) {
    return { name: 'dashboard' };
  }
  return true;
});

export default router;
