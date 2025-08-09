<template>
  <div v-if="isOpen" class="modal-overlay" @click="closeModal">
    <div class="modal-content" @click.stop>
      <div class="modal-header">
        <h2>キャリクロとは？</h2>
        <button class="close-button" @click="closeModal">&times;</button>
      </div>
      <div class="modal-body">
        <p>キャリクロ！は、職務経歴書を記録から書くのが難しい人のために、5ステップで職務経歴を自然に言語化できるようサポートするWebサービスです。</p>
        
        <div class="step-section">
          <h3>ステップ1: 会社名・職種</h3>
          <p>どこで、どんな役割で働いていたか入力します。</p>
        </div>

        <div class="step-section">
          <h3>ステップ2: やったこと</h3>
          <p>具体的な業務内容や担当したプロジェクトを入力します。</p>
        </div>

        <div class="step-section">
          <h3>ステップ3: 工夫したこと</h3>
          <p>業務における創意工夫や特徴的なアプローチを入力します。</p>
        </div>

        <div class="step-section">
          <h3>ステップ4: 成果</h3>
          <p>あなたの貢献によって生まれた具体的な成果を入力します。</p>
        </div>

        <div class="step-section">
          <h3>ステップ5: 文言整形</h3>
          <p>入力した内容を自然な文章に整形します。</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "AboutModal",
  props: {
    isOpen: {
      type: Boolean,
      default: true
    }
  },
  emits: ['close'],
  methods: {
    closeModal() {
      this.$emit('close');
    }
  }
}
</script>

<style scoped>
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.6);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.modal-content {
  background-color: white;
  border-radius: 8px;
  max-width: 450px;
  width: 90%;
  max-height: 80vh;
  overflow-y: auto;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
  animation: modalSlideIn 0.3s ease-out;
}

@keyframes modalSlideIn {
  from {
    opacity: 0;
    transform: translateY(-20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.modal-header {
  position: relative;
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 16px 20px;
  border-bottom: 1px solid #e5e5e5;
  background-color: #f8f8f8;
}

.modal-header h2 {
  margin: 0;
  font-size: 18px;
  color: #333;
  font-weight: 600;
}

.close-button {
  position: absolute;
  right: 20px;
  background: none;
  border: none;
  font-size: 24px;
  color: #999;
  cursor: pointer;
  padding: 0;
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: color 0.2s;
  line-height: 1;
}

.close-button:hover {
  color: #333;
}

.modal-body {
  padding: 20px;
  color: #333;
  line-height: 1.5;
}

.modal-body > p:first-child {
  margin-top: 0;
  margin-bottom: 20px;
  font-size: 14px;
  color: #666;
  line-height: 1.6;
}

.step-section {
  margin-bottom: 16px;
}

.step-section h3 {
  color: #333;
  margin: 0 0 4px 0;
  font-size: 14px;
  font-weight: 600;
}

.step-section p {
  margin: 0;
  font-size: 13px;
  color: #666;
  padding-left: 8px;
}

.step-section:last-child {
  margin-bottom: 0;
}
</style>