<script>
import axios from 'axios';

export default {
  data() {
    return {
      task_description: "",
      improvement: ""
    }
  },
  props: {
    positionId: {
      type: Number,
      required: true
    }
  },
  methods: {
    async handleNextStep() {
      // バリデーション: task_descriptionは必須
      if (!this.task_description.trim()) {
        alert('やったことを入力してください');
        return;
      }
      await this.saveTask();
    },
    async saveTask() {
      try {
        const params = {
          task: {
            position_id: this.positionId,
            task_description: this.task_description,
            improvement: this.improvement || null
          }
        }

        const response = await axios.post("/api/v1/tasks", params)

        // 成功したら次のステップ
        this.$emit("nextStep", response.data);
      } catch (error) {
        console.error('Error saving task:', error.response?.data || error);
        if (error.response?.data?.errors) {
          console.error(error.response.data.errors)
        }
      }
    },
    handlePrevStep() {
      this.$emit("prevStep");
    },
  },
};
</script>

<template>
  <h2>やったことや、工夫したことを入力してください</h2>
  <p>業務にあたったうえでの創意工夫や独自のアプローチなどを教えて下さい</p>

  <label for="task_description">
    やったこと<span class="required">*</span>
  </label>
  <textarea
    id="task_description"
    v-model="task_description"
    placeholder="例: エンタープライズ顧客向けの新規開拓営業。大手製造業・金融機関の経営層に対し、自社SaaSプロダクトの導入提案を実施"
    required
  />

  <label for="improvement">
    工夫したこと
    <span class="optional-badge">任意・あとで追記OK</span>
  </label>
  <textarea
    id="improvement"
    v-model="improvement"
    placeholder="例: 商談前に顧客の決算資料と業界動向を分析し、経営課題に直結する提案資料を作成。ROIシミュレーションを必ず数値化して提示"
  />
  <p class="hint">💡 数字や具体的な手法を書くと、あなたの価値が伝わりやすくなります</p>

  <div class="button-group">
    <button @click="handlePrevStep" class="base-btn base-btn__white">
      戻る
    </button>
    <button @click="handleNextStep" class="base-btn base-btn__form">
      次へ
    </button>
  </div>
</template>
