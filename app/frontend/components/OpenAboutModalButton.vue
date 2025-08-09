<template>
  <div class="about-button-container">
    <div class="about-button-wrapper">
      <div @click="showAboutModal" class="flex base-btn base-btn__white">キャリクロとは？</div>
    </div>
    <AboutModal :isOpen="showModal" @close="closeModal" />
  </div>
</template>

<script>
import AboutModal from './AboutModal.vue';

export default {
  name: "OpenAboutModalButton",
  components: { AboutModal },
  data() {
    return {
      showModal: false
    }
  },
  methods: {
    showAboutModal() {
      this.showModal = true
    },
    closeModal() {
      this.showModal = false
    }
  }
}
</script>

<style scoped>
.about-button-container {
  width: 100%;
}

.about-button-wrapper {
  display: flex;
  justify-content: flex-end;
  padding-right: 15%;
  margin-top: 20px;
  margin-bottom: 20px;
}

@media (max-width: 768px) {
  .about-button-wrapper {
    padding-right: 5%;
  }
}
</style>