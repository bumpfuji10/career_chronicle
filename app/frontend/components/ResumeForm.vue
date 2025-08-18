<template>
  <div>
    <!-- プログレスバー -->
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

    <div class="resume-form">
      <div v-if="step === 1" class="step">
      <h2>会社名と役職を入力してください</h2>
      <p>どこで、どんな役割で働いていたかを教えてください</p>

      <label for="company">会社名<span class="required">*</span></label>
      <input id="company" v-model="form.company" placeholder="株式会社キャリクロ" />

      <label for="position">職種・役職<span class="required">*</span></label>
      <input id="position" v-model="form.position" placeholder="例: Webデザイナー/プロジェクトマネージャー" />

      <div class="date-fields-container">
        <div class="date-field">
          <label for="start_at">開始日<span class="required">*</span></label>
          <input 
            id="start_at" 
            type="date" 
            v-model="form.start_at"
            placeholder="開始日を選択"
          />
        </div>
        
        <div class="date-field">
          <label for="end_at">終了日<span v-if="!form.is_current" class="required">*</span></label>
          <input 
            id="end_at" 
            type="date" 
            v-model="form.end_at"
            :disabled="form.is_current"
            :required="!form.is_current"
            placeholder="終了日を選択"
          />
        </div>
      </div>
      
      <div class="checkbox-wrapper">
        <input 
          id="is_current" 
          type="checkbox" 
          v-model="form.is_current"
          @change="handleCurrentJobChange"
        />
        <label for="is_current" class="checkbox-label">現在この職場で勤務中</label>
      </div>

      <button @click="nextStep" class="base-btn base-btn__form">次へ</button>
    </div>
    <div v-else-if="step === 2" class="step">
      <h2>Step 2: やったこと</h2>
      <textarea v-model="form.tasks" />
      <div class="button-group">
        <button @click="prevStep" class="base-btn base-btn__white">戻る</button>
        <button @click="nextStep" class="base-btn base-btn__form">次へ</button>
      </div>
    </div>
    <div v-else-if="step === 3" class="step">
      <h2>Step 3: 工夫したこと</h2>
      <textarea v-model="form.improvements" />
      <div class="button-group">
        <button @click="prevStep" class="base-btn base-btn__white">戻る</button>
        <button @click="nextStep" class="base-btn base-btn__form">次へ</button>
      </div>
    </div>
    <div v-else-if="step === 4" class="step">
      <h2>Step 4: 成果・実績</h2>
      <textarea v-model="form.achievements" />
      <div class="button-group">
        <button @click="prevStep" class="base-btn base-btn__white">戻る</button>
        <button @click="nextStep" class="base-btn base-btn__form">次へ</button>
      </div>
    </div>
    <div v-else-if="step === 5" class="step">
      <h2>Step 5: 文章整形</h2>
      <textarea v-model="summary" />
      <div class="button-group">
        <button @click="prevStep" class="base-btn base-btn__white">戻る</button>
        <button @click="submitForm" class="base-btn base-btn__form">保存</button>
      </div>
    </div>
    <div v-if="done" class="done">
      <h2>保存しました</h2>
      <p>{{ summary }}</p>
    </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ResumeForm',
  data() {
    return {
      step: 1,
      done: false,
      form: {
        company: '',
        position: '',
        start_at: '',
        end_at: '',
        is_current: false,
        tasks: '',
        improvements: '',
        achievements: ''
      },
      summary: '',
      stepLabels: ['基本情報', 'やったこと', '工夫したこと', '成果・実績', '文章整形']
    }
  },
  computed: {
    progressPercentage() {
      return (this.step / 5) * 100
    }
  },
  methods: {
    handleCurrentJobChange() {
      if (this.form.is_current) {
        this.form.end_at = ''
      }
    },
    nextStep() {
      if (this.step < 5) {
        this.step++
        if (this.step === 5) {
          this.summary = `私は${this.form.company}で${this.form.position}として、${this.form.tasks}。その中で${this.form.improvements}。結果として${this.form.achievements}。`
        }
      }
    },
    prevStep() {
      if (this.step > 1) {
        this.step--
      }
    },
    async submitForm() {
      const response = await fetch('/api/v1/resumes', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ resume: { ...this.form } })
      })
      if (response.ok) {
        const data = await response.json()
        this.summary = data.summary
        this.done = true
      } else {
        alert('保存に失敗しました')
      }
    }
  }
}
</script>

<style scoped>
@import '../stylesheets/base.scss';
.resume-form {
  max-width: 600px;
  margin: 0 auto;
  padding: 2rem;
  border: 1px solid #f2f2f2;
  border-radius: 8px;
}
.resume-form .step {
  margin-bottom: 1rem;
}
.resume-form .step h2,
.resume-form .step p {
  text-align: center;
}
.resume-form textarea,
.resume-form input {
  display: block;
  width: 100%;
  margin-bottom: 0.5rem;
  padding: 0.75rem;
  border: 1px solid #9ca3af;
  border-radius: 6px;
  font-size: 1rem;
  box-sizing: border-box;
}
.resume-form input[type="text"],
.resume-form input[type="date"] {
  height: 20px;
}
.resume-form .required {
  color: #ff0000;
  margin-left: 4px;
}
.resume-form .date-fields-container {
  display: flex;
  justify-content: space-around;
  gap: 1rem;
  margin-bottom: 0.5rem;
}
.resume-form .date-field {
  flex: 0 1 200px;
}
.resume-form .date-field input[type="date"] {
  width: 100%;
}
.resume-form .checkbox-wrapper {
  display: flex;
  align-items: center;
  margin-bottom: 1rem;
}
.resume-form .checkbox-wrapper input[type="checkbox"] {
  width: auto;
  margin-right: 0.5rem;
  margin-bottom: 0;
  box-sizing: border-box;
}
.resume-form .checkbox-label {
  margin-bottom: 0;
  font-size: 0.9rem;
}
.resume-form input[type="date"]:disabled {
  background-color: #f0f0f0;
  cursor: not-allowed;
}

/* ボタングループのスタイル */
.button-group {
  display: flex;
  gap: 1rem;
  margin-top: 1rem;
  justify-content: space-between;
}

.button-group .base-btn {
  flex: 0 1 48%;
}

.button-group .base-btn__white {
  margin: 20px auto;
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
