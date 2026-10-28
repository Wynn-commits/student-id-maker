<template>
  <div class="card form-card" v-if="!successData">
    <h2>Registration form</h2>
    <form @submit.prevent="handleSubmit">
      <label>
        Student number
        <input v-model="form.student_number" type="text" required />
      </label>
      <label>
        First name
        <input v-model="form.first_name" type="text" required />
      </label>
      <label>
        Last name
        <input v-model="form.last_name" type="text" required />
      </label>
      <label>
        Course / program
        <input v-model="form.course" type="text" required />
      </label>
      <label>
        Year & section
        <input v-model="form.year_section" type="text" required />
      </label>

      <p v-if="errorMessage" class="error-text">{{ errorMessage }}</p>

      <div class="form-actions">
        <button type="submit" class="btn btn-primary" :disabled="loading">
          {{ loading ? 'Submitting…' : 'Submit' }}
        </button>
        <RouterLink to="/" class="btn btn-ghost">Cancel</RouterLink>
      </div>
    </form>
  </div>

  <div class="card form-card" v-else>
    <h2>Registration complete</h2>
    <QrCodeDisplay
      :value="successData.qr_value"
      :studentName="`${form.first_name} ${form.last_name}`"
    />
    <div class="form-actions">
      <button class="btn btn-ghost" @click="printId">Print ID</button>
      <button class="btn btn-primary" @click="resetForm">Register another</button>
      <RouterLink to="/" class="btn btn-ghost">Back to main menu</RouterLink>
    </div>
  </div>
</template>

<script setup>
import { reactive, ref } from 'vue';
import { RouterLink } from 'vue-router';
import api from '../services/api';
import QrCodeDisplay from '../components/QrCodeDisplay.vue';

const form = reactive({
  student_number: '',
  first_name: '',
  last_name: '',
  course: '',
  year_section: '',
});

const errorMessage = ref('');
const loading = ref(false);
const successData = ref(null);

function resetForm() {
  form.student_number = '';
  form.first_name = '';
  form.last_name = '';
  form.course = '';
  form.year_section = '';
  successData.value = null;
  errorMessage.value = '';
}

function printId() {
  window.print();
}

async function handleSubmit() {
  errorMessage.value = '';
  loading.value = true;
  try {
    const { data } = await api.post('/students', form);
    successData.value = data;
  } catch (err) {
    if (err.response) {
      // responding backend pero may error
      errorMessage.value = err.response.data?.error || `Server error (${err.response.status}).`;
    } else if (err.request) {
      // kung request naa pero wa response
      errorMessage.value = 'Could not reach the backend. Is it running on http://localhost:4000?';
    } else {
      errorMessage.value = err.message;
    }
  } finally {
    loading.value = false;
  }
}
</script>

<style scoped>
.form-card {
  width: 100%;
  max-width: 480px;
}
form {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}
label {
  display: flex;
  flex-direction: column;
  gap: 0.35rem;
  font-size: 0.9rem;
  color: var(--color-text-muted);
}
input {
  padding: 0.6rem 0.75rem;
  border: 1px solid var(--color-border);
  border-radius: 6px;
  font-size: 1rem;
  color: var(--color-text);
}
.form-actions {
  display: flex;
  flex-wrap: wrap;
  gap: 0.75rem;
  margin-top: 0.5rem;
}
</style>
