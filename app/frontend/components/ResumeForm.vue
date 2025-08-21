<template>
  <div>
    <ProgressBar :step="step" :stepLabels="stepLabels" />
    
    <CelebrationAnimation :show="showCelebration" :resumeId="savedResumeId" @hide="handleCelebrationHide" />

    <div class="resume-form">
      <div v-if="step === 1" class="step">
        <h2>会社名と役職を入力してください</h2>
        <p>どこで、どんな役割で働いていたかを教えてください</p>

        <label for="company">会社名<span class="required">*</span></label>
        <input id="company" v-model="form.company" placeholder="例: 株式会社キャリクロ" />

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
        <h2>やったことを入力してください</h2>
        <p>具体的な業務内容や担当したプロジェクトなどを教えて下さい</p>
        <label for="tasks">業務内容・プロジェクト<span class="required">*</span></label>
        <textarea id="tasks" v-model="form.tasks" placeholder="例: Webサイトのデザインとコーディングを担当。クライアントとの打ち合わせから納品まで、一貫して対応。" />
        <div class="button-group">
          <button @click="prevStep" class="base-btn base-btn__white">戻る</button>
          <button @click="nextStep" class="base-btn base-btn__form">次へ</button>
        </div>
      </div>
      <div v-else-if="step === 3" class="step">
        <h2>工夫したことを入力してください</h2>
        <p>業務における創意工夫や独自のアプローチなどを教えて下さい</p>
        <label for="improvements">工夫・プロジェクトアプローチ<span class="required">*</span></label>
        <textarea id="improvements" v-model="form.improvements" placeholder="例: デザイン効率化のため独自のコンポーネントライブラリを構築。チーム内での共有を促進するためのするためドキュメント整備にも注力。" />
        <div class="button-group">
          <button @click="prevStep" class="base-btn base-btn__white">戻る</button>
          <button @click="nextStep" class="base-btn base-btn__form">次へ</button>
        </div>
      </div>
      <div v-else-if="step === 4" class="step">
        <h2>成果や実績を入力してください</h2>
        <p>あなたの貢献によって生まれた具体的な成果を教えて下さい</p>
        <label for="achievements">成果・実績<span class="required">*</span></label>
        <textarea id="achievements" v-model="form.achievements" placeholder="リニューアルしたWebサイトのCVRが前年比150%に向上。制作期間を30%短縮し、年間で10件以上の追加案件を受注できるようになった。" />
        <div class="button-group">
          <button @click="prevStep" class="base-btn base-btn__white">戻る</button>
          <button @click="nextStep" class="base-btn base-btn__form">次へ</button>
        </div>
      </div>
      <div v-else-if="step === 5" class="step">
        <h2>文章を確認・編集してください</h2>
        <p>これまで入力いただいた内容をもとに生成した文章を、必要に応じて編集することができます。</p>
        <label for="summary">職務経歴書用テキスト<span class="required">*</span></label>
        <textarea v-model="summary" />
        <div class="button-group">
          <button @click="prevStep" class="base-btn base-btn__white">戻る</button>
          <button @click="submitForm" class="base-btn base-btn__form">保存</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import ProgressBar from './ProgressBar.vue'
import CelebrationAnimation from './CelebrationAnimation.vue'

export default {
  name: 'ResumeForm',
  components: {
    ProgressBar,
    CelebrationAnimation
  },
  data() {
    return {
      step: 1,
      done: false,
      showCelebration: false,
      savedResumeId: null,
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
  methods: {
    handleCelebrationHide() {
      this.showCelebration = false
      this.done = true
    },
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
      try {
        const response = await fetch('/api/v1/resumes', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({ resume: { ...this.form } })
        })
        
        if (response.ok) {
          const json_response = await response.json()
          this.summary = json_response.data.summary
          this.savedResumeId = json_response.data.id
          this.showCelebration = true
        } else {
          const errorData = await response.json()
          console.error('Save failed:', errorData)
          alert('保存に失敗しました')
        }
      } catch (error) {
        console.error('Error in submitForm:', error)
        alert('保存中にエラーが発生しました')
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
</style>
