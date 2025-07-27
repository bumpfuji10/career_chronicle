<template>
  <div class="resume-form">
    <transition name="slide" mode="out-in">
      <div v-if="step === 1" key="step1" class="step">
        <h2>Step 1: 会社名と役職</h2>
        <input v-model="form.company" placeholder="会社名" />
        <input v-model="form.position" placeholder="役職" />
        <button class="next" @click="nextStep">次へ</button>
      </div>
      <div v-else-if="step === 2" key="step2" class="step">
        <h2>Step 2: やったこと</h2>
        <textarea v-model="form.tasks" />
        <div class="buttons">
          <button class="prev" @click="prevStep">戻る</button>
          <button class="next" @click="nextStep">次へ</button>
        </div>
      </div>
      <div v-else-if="step === 3" key="step3" class="step">
        <h2>Step 3: 工夫したこと</h2>
        <textarea v-model="form.improvements" />
        <div class="buttons">
          <button class="prev" @click="prevStep">戻る</button>
          <button class="next" @click="nextStep">次へ</button>
        </div>
      </div>
      <div v-else-if="step === 4" key="step4" class="step">
        <h2>Step 4: 成果・実績</h2>
        <textarea v-model="form.achievements" />
        <div class="buttons">
          <button class="prev" @click="prevStep">戻る</button>
          <button class="next" @click="nextStep">次へ</button>
        </div>
      </div>
      <div v-else-if="step === 5" key="step5" class="step">
        <h2>Step 5: 文章整形</h2>
        <textarea v-model="summary" />
        <div class="buttons">
          <button class="prev" @click="prevStep">戻る</button>
          <button class="next" @click="submitForm">保存</button>
        </div>
      </div>
    </transition>
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
      const response = await fetch('/resumes', {
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

<style scoped lang="scss">
$base-color: #486896;

.resume-form {
  max-width: 600px;
  margin: 0 auto;
  padding: 1.5rem;
  background: #fff;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  position: relative;

  .step {
    margin-bottom: 1rem;

    h2 {
      margin-bottom: 0.75rem;
      color: $base-color;
      font-size: 1.25rem;
    }

    textarea,
    input {
      display: block;
      width: 100%;
      margin-bottom: 0.75rem;
      padding: 0.5rem;
      border: 1px solid #d1d5db;
      border-radius: 4px;
    }

    .buttons {
      display: flex;
      justify-content: space-between;
      margin-top: 0.5rem;
    }

    button {
      padding: 0.5rem 1rem;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      &.next {
        background: $base-color;
        color: #fff;
      }

      &.prev {
        background: #f3f4f6;
        color: $base-color;
      }
    }
  }

  .done {
    text-align: center;
  }
}

/* slide transition */
.slide-enter-active,
.slide-leave-active {
  transition: transform 0.4s ease;
  position: absolute;
  width: 100%;
}

.slide-enter-from {
  transform: translateX(100%);
}

.slide-leave-to {
  transform: translateX(-100%);
}
</style>
