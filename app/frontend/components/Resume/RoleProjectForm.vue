<script>
export default {
  props: {
    form: {
      type: Object,
      required: true,
    },
  },
  methods: {
    handleNextStep() {
      this.$emit("nextStep");
    },
    handlePrevStep() {
      this.$emit("prevStep");
    },
  },
};
</script>

<template>
  <h2>やったことを入力してください</h2>
  <p>具体的な業務内容や担当したプロジェクトなどを教えて下さい</p>
  <label for="tasks"
    >業務内容・プロジェクト<span class="required">*</span></label
  >
  <textarea
    id="tasks"
    v-model="form.tasks"
    placeholder="例: Webサイトのデザインとコーディングを担当。クライアントとの打ち合わせから納品まで、一貫して対応。"
  />
  <div class="button-group">
    <button @click="handlePrevStep" class="base-btn base-btn__white">
      戻る
    </button>
    <button @click="handleNextStep" class="base-btn base-btn__form">
      次へ
    </button>
  </div>
</template>
