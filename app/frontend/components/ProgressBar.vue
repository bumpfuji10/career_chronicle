<template>
  <div class="progress-container">
    <div class="progress-bar">
      <div class="progress-track"></div>
      <div class="progress-fill" :style="{ width: progressPercentage + '%' }"></div>
    </div>
    <div class="progress-steps">
      <div 
        v-for="n in 5" 
        :key="n"
        class="progress-step"
        :class="{ 
          'active': n === step,
          'completed': n < step 
        }"
      >
        <div class="step-circle">{{ n }}</div>
        <div class="step-label">{{ stepLabels[n - 1] }}</div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { defineProps, computed } from "vue"

const props = defineProps({
  step: {
    type: Number,
    default: 1
  },
  stepLabels: {
    type: Array,
    default: () => ['基本情報', 'やったこと', '工夫したこと', '成果・実績', '文章整形']
  }
})

const progressPercentage = computed(() => {
  return ((props.step - 1) / 4) * 100
})
</script>

<style scoped>
/* プログレスバーのスタイル */
.progress-container {
  width: 100%;
  max-width: 900px;
  margin: 20px auto;
  padding: 0 10% 20px;
  box-sizing: border-box;
}

.progress-bar {
  position: relative;
  height: 4px;
  background-color: #e5e7eb;
  border-radius: 2px;
  margin-bottom: 1.5rem;
}

.progress-track {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: #e5e7eb;
  border-radius: 2px;
}

.progress-fill {
  position: absolute;
  top: 0;
  left: 0;
  height: 100%;
  background-color: #486896;
  border-radius: 2px;
  transition: width 0.3s ease;
}

.progress-steps {
  display: flex;
  justify-content: space-between;
  position: relative;
}

.progress-step {
  display: flex;
  flex-direction: column;
  align-items: center;
  flex: 1;
}

.step-circle {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background-color: #e5e7eb;
  color: #9ca3af;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
  font-size: 0.875rem;
  margin-bottom: 0.5rem;
  transition: all 0.3s ease;
}

.progress-step.completed .step-circle {
  background-color: #486896;
  color: white;
}

.progress-step.active .step-circle {
  background-color: #486896;
  color: white;
  box-shadow: 0 0 0 4px rgba(72, 104, 150, 0.2);
}

.step-label {
  font-size: 0.75rem;
  color: #6b7280;
  text-align: center;
  white-space: nowrap;
}

.progress-step.active .step-label {
  color: #486896;
  font-weight: 600;
}

.progress-step.completed .step-label {
  color: #4b5563;
}

/* モバイルレスポンシブ対応 */
@media (max-width: 640px) {
  .resume-form {
    padding: 1rem;
  }
  .resume-form .date-fields-container {
    flex-direction: column;
    gap: 0;
  }
  .resume-form .date-field {
    flex: 1 1 100%;
    max-width: 100%;
  }
}

/* モバイル対応 */
@media (max-width: 768px) {
  .progress-container {
    padding: 0 5% 20px;
    box-sizing: border-box;
  }
}

@media (max-width: 640px) {
  .progress-container {
    padding: 0 1rem 20px;
    box-sizing: border-box;
  }
  
  .step-label {
    font-size: 0.65rem;
  }
  
  .step-circle {
    width: 28px;
    height: 28px;
    font-size: 0.75rem;
  }
  
  .progress-steps {
    padding: 0;
  }
}
</style>