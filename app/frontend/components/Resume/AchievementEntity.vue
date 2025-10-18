<template>
  <div class="dfd-entity dfd-entity--achievement dfd-entity--leaf">
    <div class="dfd-box">
      <div class="dfd-box__header">
        <div class="dfd-box__icon">
          <ChartLineIcon />
        </div>
        <div class="dfd-box__title">成果</div>
      </div>
      <div class="dfd-box__body">
        <div class="dfd-box__description">{{ achievement.content }}</div>
      </div>
    </div>
  </div>
</template>

<script>
import ChartLineIcon from '../ChartLineIcon.vue'

export default {
  name: 'AchievementEntity',
  components: {
    ChartLineIcon
  },
  props: {
    achievement: {
      type: Object,
      required: true
    }
  }
}
</script>
