import { reactive } from 'vue';
import api from './api';

const state = reactive({
  token: null,
  admin: null,
});

function restoreSession() {
  const token = localStorage.getItem('admin_token');
  const profile = localStorage.getItem('admin_profile');
  if (token && profile) {
    state.token = token;
    state.admin = JSON.parse(profile);
  }
}

async function login(username, password) {
  const { data } = await api.post('/auth/login', { username, password });
  state.token = data.token;
  state.admin = data.admin;
  localStorage.setItem('admin_token', data.token);
  localStorage.setItem('admin_profile', JSON.stringify(data.admin));
}

function logout() {
  state.token = null;
  state.admin = null;
  localStorage.removeItem('admin_token');
  localStorage.removeItem('admin_profile');
}

function isAuthenticated() {
  return Boolean(state.token);
}

export default { state, restoreSession, login, logout, isAuthenticated };
