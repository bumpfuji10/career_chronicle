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
      console.log("hoge")
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
