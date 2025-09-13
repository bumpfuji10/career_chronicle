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
  <h2>成果や実績を入力してください</h2>
  <p>あなたの貢献によって生まれた具体的な成果を教えて下さい</p>
  <label for="achievements">成果・実績<span class="required">*</span></label>
  <textarea
    id="achievements"
    v-model="form.achievements"
    placeholder="リニューアルしたWebサイトのCVRが前年比150%に向上。制作期間を30%短縮し、年間で10件以上の追加案件を受注できるようになった。"
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
