import { createRouter, createWebHistory } from 'vue-router';
import MainMenu from '../views/MainMenu.vue';
import RegisterView from '../views/RegisterView.vue';
import ScanView from '../views/ScanView.vue';

const routes = [
  { path: '/', name: 'main-menu', component: MainMenu },
  { path: '/register', name: 'register', component: RegisterView },
  { path: '/scan', name: 'scan', component: ScanView },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
