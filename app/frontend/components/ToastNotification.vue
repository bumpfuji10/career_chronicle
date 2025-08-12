<template>
  <transition-group name="toast" tag="div" class="toast-container">
    <div
      v-for="toast in toasts"
      :key="toast.id"
      :class="['toast', `toast--${toast.type}`]"
    >
      <div class="toast__content">
        <span class="toast__icon">
          <template v-if="toast.type === 'success'">✓</template>
          <template v-else-if="toast.type === 'error'">✕</template>
          <template v-else-if="toast.type === 'warning'">⚠</template>
          <template v-else>ℹ</template>
        </span>
        <span class="toast__message">{{ toast.message }}</span>
      </div>
      <button @click="removeToast(toast.id)" class="toast__close">×</button>
    </div>
  </transition-group>
</template>

<script setup>
import { computed } from 'vue'
import { useToastStore } from '../stores/toast'

const toastStore = useToastStore()
const toasts = computed(() => toastStore.toasts)

const removeToast = (id) => {
  toastStore.removeToast(id)
}
</script>

<style scoped lang="scss">
.toast-container {
  position: fixed;
  top: 20px;
  right: 20px;
  z-index: 9999;
  pointer-events: none;
}

.toast {
  background: white;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  margin-bottom: 12px;
  padding: 16px;
  min-width: 300px;
  max-width: 400px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  pointer-events: auto;
  
  &--success {
    border-left: 4px solid #10b981;
    
    .toast__icon {
      color: #10b981;
    }
  }
  
  &--error {
    border-left: 4px solid #ef4444;
    
    .toast__icon {
      color: #ef4444;
    }
  }
  
  &--warning {
    border-left: 4px solid #f59e0b;
    
    .toast__icon {
      color: #f59e0b;
    }
  }
  
  &--info {
    border-left: 4px solid #3b82f6;
    
    .toast__icon {
      color: #3b82f6;
    }
  }
  
  &__content {
    display: flex;
    align-items: center;
    gap: 12px;
    flex: 1;
  }
  
  &__icon {
    font-size: 20px;
    font-weight: bold;
    display: flex;
    align-items: center;
    justify-content: center;
    width: 24px;
    height: 24px;
  }
  
  &__message {
    color: #374151;
    font-size: 14px;
    line-height: 1.5;
  }
  
  &__close {
    background: none;
    border: none;
    color: #9ca3af;
    font-size: 24px;
    cursor: pointer;
    padding: 0;
    margin-left: 12px;
    line-height: 1;
    transition: color 0.2s;
    
    &:hover {
      color: #374151;
    }
  }
}

.toast-enter-active,
.toast-leave-active {
  transition: all 0.3s ease;
}

.toast-enter-from {
  transform: translateX(100%);
  opacity: 0;
}

.toast-leave-to {
  transform: translateX(100%);
  opacity: 0;
}

.toast-move {
  transition: transform 0.3s ease;
}
</style>