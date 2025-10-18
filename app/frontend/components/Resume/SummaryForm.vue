<script>
import axios from 'axios';

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
      resumeId: null,
      isLoading: false,
    };
  },
  async mounted() {
    // ResumeFormコンポーネントからresumeIdを取得
    const resumeFormElement = document.getElementById('ResumeForm');
    if (resumeFormElement) {
      this.resumeId = parseInt(resumeFormElement.dataset.resumeId);
      await this.fetchAndGenerateSummary();
    }
  },
  methods: {
    async fetchAndGenerateSummary() {
      try {
        this.isLoading = true;
        const response = await axios.get(`/api/v1/resumes/${this.resumeId}`);

        // データからサマリーテキストを生成
        this.summary = this.generateSummaryText(response.data.resume);
      } catch (error) {
        console.error('Error fetching resume:', error.response?.data || error);
        alert('サマリーの取得に失敗しました');
      } finally {
        this.isLoading = false;
      }
    },
    generateSummaryText(resume) {
      if (!resume.companies || resume.companies.length === 0) {
        return "";
      }

      // 会社ごとにセクションを生成
      const sections = resume.companies
        .sort((a, b) => new Date(b.started_at) - new Date(a.started_at))
        .map(company => this.generateCompanySection(company))
        .filter(section => section.length > 0);

      return sections.join("\n\n");
    },
    generateCompanySection(company) {
      if (!company.positions || company.positions.length === 0) {
        return "";
      }

      const positionSections = company.positions
        .sort((a, b) => new Date(b.started_at) - new Date(a.started_at))
        .map(position => this.generatePositionSection(company, position))
        .filter(section => section.length > 0);

      return positionSections.join("\n\n");
    },
    generatePositionSection(company, position) {
      const period = this.formatPeriod(position.started_at, position.ended_at);
      let section = `■ ${company.name} / ${position.department} ${position.title} (${period})\n\n`;

      if (position.tasks && position.tasks.length > 0) {
        const taskTexts = position.tasks.map(task => this.generateTaskBullet(task));
        section += taskTexts.join("\n");
      }

      return section;
    },
    generateTaskBullet(task) {
      const parts = [task.task_description];

      if (task.improvement) {
        parts.push(task.improvement);
      }

      if (task.achievements && task.achievements.length > 0) {
        const achievementsText = task.achievements.map(a => a.content).join('。');
        parts.push(achievementsText);
      }

      return `・${parts.join('。')}`;
    },
    formatPeriod(startedAt, endedAt) {
      const start = new Date(startedAt);
      const startStr = `${start.getFullYear()}年${String(start.getMonth() + 1).padStart(2, '0')}月`;

      if (endedAt) {
        const end = new Date(endedAt);
        const endStr = `${end.getFullYear()}年${String(end.getMonth() + 1).padStart(2, '0')}月`;
        return `${startStr} 〜 ${endStr}`;
      } else {
        return `${startStr} 〜 現在`;
      }
    },
    handlePrevStep() {
      this.$emit("prevStep");
    },
    async submitForm() {
      try {
        this.isLoading = true;
        const params = {
          resume: {
            summary: this.summary
          }
        };

        const response = await axios.put(`/api/v1/resumes/${this.resumeId}`, params);

        this.$emit("savedResumeId", response.data.id);
        this.$emit("celebration");
      } catch (error) {
        console.error('Error saving summary:', error.response?.data || error);
        if (error.response?.data?.errors) {
          alert(`保存に失敗しました: ${error.response.data.errors.join(', ')}`);
        } else {
          alert('保存に失敗しました');
        }
      } finally {
        this.isLoading = false;
      }
    },
  },
};
</script>

<template>
  <div v-if="isLoading" style="text-align: center; padding: 2rem;">
    <p>読み込み中...</p>
  </div>
  <div v-else>
    <h2>文章を確認・編集してください</h2>
    <p>
      これまで入力いただいた内容をもとに生成した文章を、必要に応じて編集することができます。
    </p>
    <label for="summary"
      >職務経歴書用テキスト<span class="required">*</span></label
    >
    <textarea v-model="summary" rows="20" />
    <div class="button-group">
      <button @click="handlePrevStep" class="base-btn base-btn__white" :disabled="isLoading">
        戻る
      </button>
      <button @click="submitForm" class="base-btn base-btn__form" :disabled="isLoading">
        {{ isLoading ? '保存中...' : '保存' }}
      </button>
    </div>
  </div>
</template>
