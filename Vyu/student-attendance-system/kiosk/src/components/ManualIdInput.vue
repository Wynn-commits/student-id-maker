<template>
  <form class="manual-input" @submit.prevent="submit">
    <input
      ref="inputRef"
      v-model="code"
      type="text"
      placeholder="Type or scan ID, then press Enter"
      autocomplete="off"
      :disabled="disabled"
    />
    <button type="submit" class="btn btn-primary" :disabled="disabled">Submit</button>
  </form>
</template>

<script setup>
import { ref, onMounted, nextTick, watch } from 'vue';

const props = defineProps({ disabled: { type: Boolean, default: false } });
const emit = defineEmits(['submit']);
const code = ref('');
const inputRef = ref(null);

function submit() {
  const value = code.value.trim();
  if (!value || props.disabled) return;
  emit('submit', value);
  code.value = '';
  nextTick(() => inputRef.value?.focus());
}

onMounted(() => {
  inputRef.value?.focus();
});

// Once a request finishes (disabled flips back to false), put focus back
// in the field so the next scan/typed ID doesn't need a manual click.
watch(
  () => props.disabled,
  (isDisabled) => {
    if (!isDisabled) nextTick(() => inputRef.value?.focus());
  }
);

defineExpose({ focus: () => inputRef.value?.focus() });
</script>

<style scoped>
.manual-input {
  display: flex;
  gap: 0.5rem;
}
.manual-input input {
  flex: 1;
  padding: 0.6rem 0.75rem;
  border: 1px solid var(--color-border);
  border-radius: 6px;
  font-size: 1rem;
}
</style>
