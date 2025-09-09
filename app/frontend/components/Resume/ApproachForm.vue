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
  <h2>工夫したことを入力してください</h2>
  <p>業務における創意工夫や独自のアプローチなどを教えて下さい</p>
  <label for="improvements"
    >工夫・プロジェクトアプローチ<span class="required">*</span></label
  >
  <textarea
    id="improvements"
    v-model="form.improvements"
    placeholder="例: デザイン効率化のため独自のコンポーネントライブラリを構築。チーム内での共有を促進するためのするためドキュメント整備にも注力。"
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
