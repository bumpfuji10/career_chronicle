<script>
export default {
  props: {
    form: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      summary: "",
    };
  },
  methods: {
    handleNextStep() {
      this.$emit("nextStep");
    },
    handlePrevStep() {
      this.$emit("prevStep");
    },
    handleCelebration() {
      this.$emit("celebration");
    },
    handleSavedResumeId(resumeId) {
      this.$emit("savedResumeId", resumeId);
    },
    async submitForm() {
      try {
        const response = await fetch("/api/v1/resumes", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({ resume: { ...this.form } }),
        });
        if (response.ok) {
          const json_response = await response.json();
          this.summary = json_response.data.summary;
          const resumeId = json_response.data.id;
          this.handleSavedResumeId(resumeId);
          this.handleCelebration();
        } else {
          console.log("not ok");
          const errorData = await response.json();
          console.error("Save failed:", errorData);
          alert("保存に失敗しました");
        }
      } catch (error) {
        console.log("error");
        console.error("Error in submitForm:", error);
        alert("保存中にエラーが発生しました");
      }
    },
  },
};
</script>

<template>
  <h2>文章を確認・編集してください</h2>
  <p>
    これまで入力いただいた内容をもとに生成した文章を、必要に応じて編集することができます。
  </p>
  <label for="summary"
    >職務経歴書用テキスト<span class="required">*</span></label
  >
  <textarea v-model="summary" />
  <div class="button-group">
    <button @click="handlePrevStep" class="base-btn base-btn__white">
      戻る
    </button>
    <button @click="submitForm" class="base-btn base-btn__form">保存</button>
  </div>
</template>
