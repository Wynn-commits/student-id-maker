import { createApp } from 'vue';
import App from './App.vue';
import router from './router';
import auth from './services/auth';
import './style.css';

auth.restoreSession();
createApp(App).use(router).mount('#app');
