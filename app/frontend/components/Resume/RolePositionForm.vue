<script>
import axios from 'axios';

export default {
  data() {
    return {
      department: "",
      title: "",
      started_at: "",
      ended_at: "",
      is_current: false,
    }
  },
  props: {
    companyId: {
      type: Number,
      required: true,
    },
  },
  methods: {
    async handleNextStep() {
      await this.saveRolePosision();
    },
    handlePrevStep() {
      this.$emit("prevStep")
    },
    async saveRolePosision() {
      console.log(this.companyId)
      try {
        const params = {
          position: {
            company_id: this.companyId,
            department: this.department,
            title: this.title,
            started_at: this.started_at,
            ended_at: this.is_current ? null : this.ended_at
          }
        };

        const response = await axios.post("/api/v1/positions", params);

        // 成功したら次のステップへ
        this.$emit("nextStep", response.data);
      } catch (error) {
        console.error('Error saving company:', error.response?.data || error);
        if (error.response?.data?.errors) {
          console.error(error.response.data.errors)
        }
      }
    },
    handleCurrentJobChange() {
      if (this.is_current) {
        this.ended_at = null;
      }
    }
  },
};
</script>

<template>
  <h2>所属部署・役職を入力してください</h2>
  
  <label for="department">部署<span class="required">*</span></label>
  <input
    id="department"
    v-model="department"
    placeholder="例: 本社法人営業部エンタープライズ営業課"
  />

  <label for="title">役職<span class="required">*</span></label>
  <input id="title" v-model="title" placeholder="例: 課長">

  <div class="date-fields-container">
    <div class="date-field">
      <label for="start_at">開始日<span class="required">*</span></label>
      <input
        id="start_at"
        type="date"
        v-model="started_at"
        placeholder="開始日を選択"
      />
    </div>

    <div class="date-field">
      <label for="end_at"
        >終了日<span v-if="!is_current" class="required">*</span></label
      >
      <input
        id="end_at"
        type="date"
        v-model="ended_at"
        :disabled="is_current"
        :required="!is_current"
        placeholder="終了日を選択"
      />
    </div>
  </div>

  <div class="checkbox-wrapper">
    <input
      id="is_current"
      type="checkbox"
      v-model="is_current"
      @change="handleCurrentJobChange"
    />
    <label for="is_current" class="checkbox-label">現在この役職に従事中</label>
  </div>

  <div class="button-group">
    <button @click="handlePrevStep" class="base-btn base-btn__white">
      戻る
    </button>
    <button @click="handleNextStep" class="base-btn base-btn__form">次へ</button>
  </div>
</template>
