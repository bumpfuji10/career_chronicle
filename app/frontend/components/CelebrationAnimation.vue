<template>
  <div v-if="show" class="celebration-overlay" @click="handleOverlayClick">
    <div class="celebration-content" @click.stop>
      <div class="celebration-message">
        <button class="close-button" @click="close">×</button>
        <h2>🎉 職務経歴書が完成しました！ 🎉</h2>
        <p>保存が正常に完了しました</p>
        <button class="base-btn base-btn__form" @click="close">職務経歴書を確認する</button>
      </div>
      
      <!-- 紙吹雪 -->
      <div class="confetti-container">
        <div v-for="n in 50" :key="n" class="confetti" :style="getConfettiStyle(n)"></div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'CelebrationAnimation',
  props: {
    show: {
      type: Boolean,
      default: false
    },
    resumeId: {
      type: Number,
      default: null
    }
  },
  methods: {
    close() {
      if (this.resumeId) {
        // resume詳細画面へリダイレクト
        window.location.href = `/resumes/${this.resumeId}`
      } else {
        this.$emit('hide')
      }
    },
    handleOverlayClick() {
      this.close()
    },
    getConfettiStyle(index) {
      const colors = ['#ff6b6b', '#4ecdc4', '#45b7d1', '#f9ca24', '#6c5ce7', '#a55eea']
      const color = colors[index % colors.length]
      const left = Math.random() * 100
      const animationDelay = Math.random() * 3
      const animationDuration = 5 + Math.random() * 3
      
      return {
        left: `${left}%`,
        backgroundColor: color,
        animationDelay: `${animationDelay}s`,
        animationDuration: `${animationDuration}s`
      }
    }
  }
}
</script>

<style scoped>
@import '../stylesheets/base.scss';

.celebration-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  background-color: rgba(0, 0, 0, 0.8);
  z-index: 1000;
  display: flex;
  justify-content: center;
  align-items: center;
  animation: fadeIn 0.3s ease-out;
}

.celebration-content {
  position: relative;
  text-align: center;
  z-index: 1001;
}

.celebration-message {
  background: white;
  padding: 2rem;
  border-radius: 16px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
  animation: bounceIn 0.8s ease-out;
  margin-bottom: 2rem;
}

.celebration-message h2 {
  color: #333;
  margin-bottom: 1rem;
  font-size: 2rem;
}

.celebration-message p {
  color: #666;
  margin: 1rem 0;
  font-size: 1.1rem;
}

/* 閉じるボタン */
.close-button {
  position: absolute;
  top: 1rem;
  right: 1rem;
  background: none;
  border: none;
  font-size: 2rem;
  color: #666;
  cursor: pointer;
  line-height: 1;
  padding: 0;
  width: 2rem;
  height: 2rem;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s ease;
}

.close-button:hover {
  color: #333;
  transform: scale(1.1);
}

/* base-btnの追加スタイル調整 */
.celebration-message .base-btn {
  margin-top: 1.5rem;
}

/* 紙吹雪 */
.confetti-container {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
  overflow: hidden;
}

.confetti {
  position: absolute;
  width: 10px;
  height: 10px;
  top: -10px;
  animation: confettiFall linear infinite;
  border-radius: 2px;
}

/* アニメーション定義 */
@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes bounceIn {
  0% {
    opacity: 0;
    transform: scale(0.3) translateY(-50px);
  }
  50% {
    opacity: 1;
    transform: scale(1.05);
  }
  70% {
    transform: scale(0.9);
  }
  100% {
    opacity: 1;
    transform: scale(1) translateY(0);
  }
}

@keyframes crackerPop {
  0% {
    transform: scale(0) rotate(0deg);
    opacity: 0;
  }
  50% {
    transform: scale(1.2) rotate(180deg);
    opacity: 1;
  }
  100% {
    transform: scale(1) rotate(360deg);
    opacity: 1;
  }
}

@keyframes confettiFall {
  0% {
    transform: translateY(-100vh) rotate(0deg);
    opacity: 1;
  }
  100% {
    transform: translateY(100vh) rotate(720deg);
    opacity: 0;
  }
}

/* レスポンシブ対応 */
@media (max-width: 768px) {
  .celebration-message {
    padding: 1.5rem;
  }
  
  .celebration-message h2 {
    font-size: 1.2rem;
    white-space: nowrap;
  }
  
  .celebration-message p {
    font-size: 0.9rem;
  }
  
  .cracker {
    font-size: 3rem;
  }
}

@media (max-width: 480px) {
  .celebration-message h2 {
    font-size: 1rem;
  }
  
  .celebration-message p {
    font-size: 0.85rem;
  }
}
</style>