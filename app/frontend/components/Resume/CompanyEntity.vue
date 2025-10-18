<template>
  <div
    class="dfd-entity dfd-entity--company"
    :class="{ 'is-expanded': isExpanded }"
    :data-entity-id="`company-${company.id}`"
  >
    <div class="dfd-box" @click="toggleExpand">
      <div class="dfd-box__header">
        <div class="dfd-box__icon">
          <CompanyIcon />
        </div>
        <div class="dfd-box__title">{{ company.name }}</div>
      </div>
      <div class="dfd-box__body">
        <div class="dfd-box__meta">
          <span class="dfd-badge">{{ company.industry }}</span>
          <span class="dfd-period">{{ formatPeriod(company.started_at, company.ended_at) }}</span>
        </div>
      </div>
    </div>

    <div class="dfd-children">
      <div class="dfd-arrow-down">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor">
          <line x1="12" y1="0" x2="12" y2="20"></line>
          <polyline points="7 15 12 20 17 15"></polyline>
        </svg>
      </div>

      <div class="dfd-children-grid">
        <PositionEntity
          v-for="position in sortedPositions"
          :key="position.id"
          :position="position"
        />
      </div>
    </div>
  </div>
</template>

<script>
import CompanyIcon from '../CompanyIcon.vue'
import PositionEntity from './PositionEntity.vue'

export default {
  name: 'CompanyEntity',
  components: {
    CompanyIcon,
    PositionEntity
  },
  props: {
    company: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      isExpanded: false
    }
  },
  computed: {
    sortedPositions() {
      if (!this.company.positions) return []
      return [...this.company.positions].sort((a, b) => {
        return new Date(b.started_at) - new Date(a.started_at)
      })
    }
  },
  methods: {
    toggleExpand() {
      this.isExpanded = !this.isExpanded
    },
    formatPeriod(startedAt, endedAt) {
      const start = new Date(startedAt)
      const startStr = `${start.getFullYear()}年${String(start.getMonth() + 1).padStart(2, '0')}月`

      if (endedAt) {
        const end = new Date(endedAt)
        const endStr = `${end.getFullYear()}年${String(end.getMonth() + 1).padStart(2, '0')}月`
        return `${startStr} 〜 ${endStr}`
      }

      return `${startStr} 〜 現在`
    }
  }
}
</script>
