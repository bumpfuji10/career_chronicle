<script>
import axios from 'axios';

export default {
  props: {
    taskId: {
      type: Number,
      required: true,
    },
  },
  methods: {
    async handleNextStep() {
      this.saveAchievement()
    },
    async saveAchievement() {
      try {
        const params = {
          achievement: {
            task_id: this.taskId,
            content: this.content
          }
        }
        const response = await axios.post("/api/v1/achievements", params)

        // 成功したら次のステップ
        this.$emit("nextStep", response.data)
      } catch(error) {
        console.error(error)
        if (error.response?.data?.errors) {
          console.log(error.response.data.errors)
        }
      }
      this.$emit("nextStep", response.data);
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
  <label for="content">成果・実績<span class="required">*</span></label>
  <textarea
    id="content"
    v-model="content"
    placeholder="課全体の成約率を25%から40%に改善。メンバー5名中3名が社内MVPを受賞"
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
