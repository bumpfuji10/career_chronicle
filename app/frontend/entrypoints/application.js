import { createApp } from 'vue'
import Header from '../components/Header.vue'

document.addEventListener('DOMContentLoaded', () => {
  const headerEl = document.getElementById('header')
  if (headerEl) createApp(Header).mount(headerEl)
})
