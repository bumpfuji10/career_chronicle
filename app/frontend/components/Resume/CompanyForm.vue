<script>
import axios from 'axios';

export default {
  props: {
    form: {
      type: Object,
      required: true,
    },
    resumeId: {
      type: Number,
      required: true,
    },
  },
  methods: {
    async handleNextStep() {
      await this.saveCompany();
    },
    async saveCompany() {
      try {
        const params = {
          company: {
            resume_id: this.resumeId,
            name: this.form.company,
            industry: this.form.industry,
            started_at: this.form.start_at,
            ended_at: this.form.is_current ? null : this.form.end_at
          }
        };

        const response = await axios.post("/api/v1/companies", params);
        console.log('Company created:', response.data);

        // 成功したら次のステップへ
        this.$emit("nextStep", response.data);
      } catch (error) {
        console.error('Error saving company:', error.response?.data || error);
        // エラーハンドリング（必要に応じてユーザーに通知）
        if (error.response?.data?.errors) {
          console.error(error.response.data.errors)
          alert(`エラー: ${error.response.data.errors.join(', ')}`);
        }
      }
    },
    handleCurrentJobChange() {
      if (this.form.is_current) {
        this.form.end_at = null;
      }
    }
  },
};
</script>

<template>
  <h2>在籍していた会社の情報を入力してください</h2>

  <label for="company">会社名<span class="required">*</span></label>
  <input
    id="company"
    v-model="form.company"
    placeholder="例: 株式会社キャリクロ"
  />

  <label for="industry">業種<span class="required">*</span></label>
  <input id="industry" v-model="form.industry" placeholder="例: IT・ソフトウェア／SaaS">

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
    <label for="is_current" class="checkbox-label">現在この職場に在籍中</label>
  </div>

  <button @click="handleNextStep" class="base-btn base-btn__form">次へ</button>
</template>
