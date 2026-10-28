import { createRouter, createWebHashHistory } from 'vue-router'
import { auth } from './data.js'
const routes = [
  { path: '/', component: () => import('./views/Proposal.vue') },
  { path: '/login', component: () => import('./views/Login.vue') },
  { path: '/system', component: () => import('./views/Shell.vue'), meta: { auth: true }, redirect: '/system/dashboard',
    children: [
      { path: 'dashboard', component: () => import('./views/Dashboard.vue') },
      { path: 'profiles', component: () => import('./views/Profiles.vue') },
      { path: 'review', component: () => import('./views/Review.vue') },
      { path: 'cameras', component: () => import('./views/Cameras.vue') },
      { path: 'users', component: () => import('./views/Users.vue') } ] },
  { path: '/:p(.*)*', redirect: '/' } ]
const router = createRouter({ history: createWebHashHistory(), routes, scrollBehavior: (to) => to.hash ? { el: to.hash } : { top: 0 } })
router.beforeEach((to) => (to.meta.auth && !auth.user ? '/login' : true))
export default router
