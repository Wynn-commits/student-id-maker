<template>
  <div class="qr-wrap">
    <QrcodeVue :value="value" :size="180" level="M" />
    <p class="qr-caption">{{ studentName }}</p>
    <p class="qr-value">{{ value }}</p>
  </div>
</template>

<script setup>
import QrcodeVue from 'qrcode.vue';

defineProps({
  value: { type: String, required: true },
  studentName: { type: String, default: '' },
});
</script>

<style scoped>
.qr-wrap {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
  padding: 1rem 0;
}
.qr-caption {
  font-weight: 600;
  margin: 0;
}
.qr-value {
  color: var(--color-text-muted);
  font-size: 0.85rem;
  margin: 0;
}
</style>
