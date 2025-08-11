<template>
  <div class="resume-form">
    <div v-if="step === 1" class="step">
      <h2>Step 1: 会社名と役職</h2>
      <input v-model="form.company" placeholder="会社名" />
      <input v-model="form.position" placeholder="役職" />
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
        tasks: '',
        improvements: '',
        achievements: ''
      },
      summary: ''
    }
  },
  methods: {
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
.resume-form .step {
  margin-bottom: 1rem;
}
.resume-form textarea,
.resume-form input {
  display: block;
  width: 100%;
  margin-bottom: 0.5rem;
}
</style>
