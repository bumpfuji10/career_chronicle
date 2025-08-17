<template>
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

      <button @click="nextStep">次へ</button>
    </div>
    <div v-else-if="step === 2" class="step">
      <h2>Step 2: やったこと</h2>
      <textarea v-model="form.tasks" />
      <button @click="prevStep">戻る</button>
      <button @click="nextStep">次へ</button>
    </div>
    <div v-else-if="step === 3" class="step">
      <h2>Step 3: 工夫したこと</h2>
      <textarea v-model="form.improvements" />
      <button @click="prevStep">戻る</button>
      <button @click="nextStep">次へ</button>
    </div>
    <div v-else-if="step === 4" class="step">
      <h2>Step 4: 成果・実績</h2>
      <textarea v-model="form.achievements" />
      <button @click="prevStep">戻る</button>
      <button @click="nextStep">次へ</button>
    </div>
    <div v-else-if="step === 5" class="step">
      <h2>Step 5: 文章整形</h2>
      <textarea v-model="summary" />
      <button @click="prevStep">戻る</button>
      <button @click="submitForm">保存</button>
    </div>
    <div v-if="done" class="done">
      <h2>保存しました</h2>
      <p>{{ summary }}</p>
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
      summary: ''
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
}
.resume-form .checkbox-label {
  margin-bottom: 0;
  font-size: 0.9rem;
}
.resume-form input[type="date"]:disabled {
  background-color: #f0f0f0;
  cursor: not-allowed;
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
}
</style>
