import { createApp } from 'vue'
import Hello from '../components/Hello.vue'

document.addEventListener('DOMContentLoaded', () => {
  const el = document.getElementById('hello')
  if (el) {
    createApp(Hello).mount(el)
  }

  console.log('Hello from application.js!')
})
