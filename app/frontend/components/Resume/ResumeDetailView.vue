<template>
  <div class="dfd-view">
    <div v-if="companies.length > 0" class="dfd-container">
      <CompanyEntity
        v-for="company in sortedCompanies"
        :key="company.id"
        :company="company"
      />
    </div>
    <div v-else class="empty-state">
      <p>まだ職務経歴が登録されていません</p>
    </div>
  </div>
</template>

<script>
import CompanyEntity from './CompanyEntity.vue'
import axios from 'axios'

export default {
  name: 'ResumeDetailView',
  components: {
    CompanyEntity
  },
  inject: {
    injectedResumeId: {
      from: 'resumeId',
      default: null
    }
  },
  data() {
    return {
      companies: [],
      resumeId: null
    }
  },
  computed: {
    sortedCompanies() {
      return [...this.companies].sort((a, b) => {
        return new Date(b.started_at) - new Date(a.started_at)
      })
    }
  },
  async mounted() {
    // まずinjectされた値を試す
    if (this.injectedResumeId) {
      this.resumeId = this.injectedResumeId
      console.log('Resume ID from inject:', this.resumeId)
    } else {
      // フォールバック: data-resume-id属性から取得
      const resumeIdAttr = this.$el.getAttribute('data-resume-id')
      console.log('data-resume-id attribute:', resumeIdAttr)
      this.resumeId = parseInt(resumeIdAttr, 10)
      console.log('Parsed Resume ID:', this.resumeId)
    }

    if (this.resumeId && !isNaN(this.resumeId)) {
      await this.fetchResumeData()
    } else {
      console.error('Invalid resume ID. Injected:', this.injectedResumeId, 'Attribute:', this.$el.getAttribute('data-resume-id'))
    }
  },
  methods: {
    async fetchResumeData() {
      try {
        const response = await axios.get(`/api/v1/resumes/${this.resumeId}`)
        console.log('API Response:', response.data)
        this.companies = response.data.resume.companies || []
      } catch (error) {
        console.error('Error fetching resume data:', error)
      }
    }
  }
}
</script>
