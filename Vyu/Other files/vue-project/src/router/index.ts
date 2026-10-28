import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      // Route-level code splitting: this generates a separate chunk for the
      // home page, lazy-loaded only when visited.
      component: () => import('@/views/PersonalPage.vue'),
      meta: { title: 'Home' },
    },
  ],
})

// Set the document title per route for better UX & SEO.
router.afterEach((to) => {
  const baseTitle = 'Erwin Orquillano'
  document.title = to.meta.title ? `${to.meta.title} | ${baseTitle}` : baseTitle
})

export default router
