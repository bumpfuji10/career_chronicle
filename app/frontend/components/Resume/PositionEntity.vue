<template>
  <div
    class="dfd-entity dfd-entity--position"
    :class="{ 'is-expanded': isExpanded }"
    :data-entity-id="`position-${position.id}`"
  >
    <div class="dfd-box" @click.stop="toggleExpand">
      <div class="dfd-box__header">
        <div class="dfd-box__icon">
          <BriefcaseIcon />
        </div>
        <div class="dfd-box__title">{{ position.department }} / {{ position.title }}</div>
      </div>
      <div class="dfd-box__body">
        <div class="dfd-box__meta">
          <span class="dfd-period">{{ formatPeriod(position.started_at, position.ended_at) }}</span>
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
        <TaskEntity
          v-for="task in position.tasks"
          :key="task.id"
          :task="task"
        />
      </div>
    </div>
  </div>
</template>

<script>
import BriefcaseIcon from '../BriefcaseIcon.vue'
import TaskEntity from './TaskEntity.vue'

export default {
  name: 'PositionEntity',
  components: {
    BriefcaseIcon,
    TaskEntity
  },
  props: {
    position: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      isExpanded: false
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
