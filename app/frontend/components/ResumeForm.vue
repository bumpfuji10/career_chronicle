<template>
  <div>
    <ProgressBar :step="step" :stepLabels="stepLabels" />

    <CelebrationAnimation
      :show="showCelebration"
      :resumeId="savedResumeId"
      @hide="handleCelebrationHide"
    />

    <div class="resume-form">
      <div v-if="step === 1" class="step">
        <CompanyForm :form="form" @nextStep="nextStep" />
      </div>
      <div v-else-if="step === 2" class="step">
        <RoleProjectForm
          :form="form"
          @nextStep="nextStep"
          @prevStep="prevStep"
        />
      </div>
      <div v-else-if="step === 3" class="step">
        <ApproachForm :form="form" @nextStep="nextStep" @prevStep="prevStep" />
      </div>
      <div v-else-if="step === 4" class="step">
        <AchievementForm
          :form="form"
          @nextStep="nextStep"
          @prevStep="prevStep"
        />
      </div>
      <div v-else-if="step === 5" class="step">
        <SummaryForm
          :form="form"
          @submit="submit"
          @prevStep="prevStep"
          @celebration="turnOnShowCelebration"
          @savedResumeId="onSavedResumeId"
        />
      </div>
    </div>
  </div>
</template>

<script>
import ProgressBar from "./ProgressBar.vue";
import CelebrationAnimation from "./CelebrationAnimation.vue";

import CompanyForm from "./Resume/CompanyForm.vue";
import RoleProjectForm from "./Resume/RoleProjectForm.vue";
import ApproachForm from "./Resume/ApproachForm.vue";
import AchievementForm from "./Resume/AchievementForm.vue";
import SummaryForm from "./Resume/SummaryForm.vue";

export default {
  name: "ResumeForm",
  components: {
    ProgressBar,
    CelebrationAnimation,
    CompanyForm,
    RoleProjectForm,
    ApproachForm,
    AchievementForm,
    SummaryForm,
  },
  data() {
    return {
      step: 1,
      done: false,
      showCelebration: false,
      savedResumeId: null,
      form: {
        company: "",
        position: "",
        start_at: "",
        end_at: "",
        is_current: false,
        tasks: "",
        improvements: "",
        achievements: "",
      },
      summary: "",
      stepLabels: [
        "基本情報",
        "やったこと",
        "工夫したこと",
        "成果・実績",
        "文章整形",
      ],
    };
  },
  methods: {
    handleCelebrationHide() {
      this.showCelebration = false;
      this.done = true;
    },
    handleCurrentJobChange() {
      if (this.form.is_current) {
        this.form.end_at = "";
      }
    },
    nextStep() {
      if (this.step < 5) {
        this.step++;
        if (this.step === 5) {
          this.summary = `私は${this.form.company}で${this.form.position}として、${this.form.tasks}。その中で${this.form.improvements}。結果として${this.form.achievements}。`;
        }
      }
    },
    prevStep() {
      if (this.step > 1) {
        this.step--;
      }
    },
    turnOnShowCelebration() {
      this.showCelebration = true;
    },
    onSavedResumeId(resumeId) {
      this.savedResumeId = resumeId;
    },
  },
};
</script>

<style>
@import "../stylesheets/base.scss";
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
