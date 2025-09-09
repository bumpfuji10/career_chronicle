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
  },
};
</script>

<template>
  <h2>会社名と役職を入力してください</h2>
  <p>どこで、どんな役割で働いていたかを教えてください</p>

  <label for="company">会社名<span class="required">*</span></label>
  <input
    id="company"
    v-model="form.company"
    placeholder="例: 株式会社キャリクロ"
  />

  <label for="position">職種・役職<span class="required">*</span></label>
  <input
    id="position"
    v-model="form.position"
    placeholder="例: Webデザイナー/プロジェクトマネージャー"
  />

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
      <label for="end_at"
        >終了日<span v-if="!form.is_current" class="required">*</span></label
      >
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

  <button @click="handleNextStep" class="base-btn base-btn__form">次へ</button>
</template>
