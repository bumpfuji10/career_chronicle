<template>
  <div
    class="dfd-entity dfd-entity--task"
    :class="{ 'is-expanded': isExpanded }"
    :data-entity-id="`task-${task.id}`"
  >
    <div class="dfd-box" @click.stop="toggleExpand">
      <div class="dfd-box__header">
        <div class="dfd-box__icon">
          <LightbulbIcon />
        </div>
        <div class="dfd-box__title">やったこと</div>
      </div>
      <div class="dfd-box__body">
        <div class="dfd-box__description">{{ task.task_description }}</div>
        <div v-if="task.improvement" class="dfd-box__improvement">
          <strong>工夫:</strong> {{ task.improvement }}
        </div>
      </div>
    </div>

    <div v-if="task.achievements && task.achievements.length > 0" class="dfd-children">
      <div class="dfd-arrow-down">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor">
          <line x1="12" y1="0" x2="12" y2="20"></line>
          <polyline points="7 15 12 20 17 15"></polyline>
        </svg>
      </div>

      <div class="dfd-children-grid">
        <AchievementEntity
          v-for="achievement in task.achievements"
          :key="achievement.id"
          :achievement="achievement"
        />
      </div>
    </div>
  </div>
</template>

<script>
import LightbulbIcon from '../LightbulbIcon.vue'
import AchievementEntity from './AchievementEntity.vue'

export default {
  name: 'TaskEntity',
  components: {
    LightbulbIcon,
    AchievementEntity
  },
  props: {
    task: {
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
      if (this.task.achievements && this.task.achievements.length > 0) {
        this.isExpanded = !this.isExpanded
      }
    }
  }
}
</script>
