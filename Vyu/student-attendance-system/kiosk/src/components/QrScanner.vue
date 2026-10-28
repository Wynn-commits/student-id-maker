<template>
  <div class="scanner-wrap">
    <div id="qr-reader"></div>
    <p v-if="paused" class="scanner-status">Scanned — resuming in a moment…</p>
  </div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue';
import { Html5Qrcode } from 'html5-qrcode';

const emit = defineEmits(['decoded']);
const paused = ref(false);
let html5QrCode;
let resumeTimer;

const COOLDOWN_MS = 2500;

onMounted(async () => {
  html5QrCode = new Html5Qrcode('qr-reader');
  try {
    await html5QrCode.start(
      { facingMode: 'environment' },
      { fps: 10, qrbox: 220 },
      (decodedText) => {
        if (paused.value) return;
        paused.value = true;
        html5QrCode.pause(true);
        emit('decoded', decodedText);
        resumeTimer = setTimeout(() => {
          html5QrCode?.resume();
          paused.value = false;
        }, COOLDOWN_MS);
      },
      () => {
        // ignore per-frame scan failures. kani fires constantly while no QR is in view
      }
    );
  } catch (err) {
    console.error('Camera start failed', err);
  }
});

onBeforeUnmount(async () => {
  if (resumeTimer) clearTimeout(resumeTimer);
  if (html5QrCode) {
    try {
      await html5QrCode.stop();
      html5QrCode.clear();
    } catch (e) {
      // scanner already stopped ignores dat.
    }
  }
});
</script>

<style scoped>
.scanner-wrap {
  width: 100%;
  max-width: 320px;
  margin: 0 auto;
}
#qr-reader {
  border-radius: 8px;
  overflow: hidden;
}
.scanner-status {
  text-align: center;
  color: var(--color-text-muted);
  font-size: 0.85rem;
  margin-top: 0.5rem;
}
</style>
