import { createApp } from 'vue'
import { createPinia } from 'pinia'
import '../stylesheets/application.scss'
import components from './components'
import ToastNotification from '../components/ToastNotification.vue'

// FontAwesome の設定
import { library } from '@fortawesome/fontawesome-svg-core'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'

// 塗りつぶし（solid）アイコン
import {
  faUser,
  faSignInAlt,
  faArrowRight,
  faBuilding,
  faBriefcase,
  faLightbulb,
  faChartLine,
  faFileLines
} from '@fortawesome/free-solid-svg-icons'

// 線（regular）アイコン
import {
  faClock as faClockRegular,
  faFile as faFileRegular,
  faUser as faUserRegular
} from '@fortawesome/free-regular-svg-icons'

// 必要なアイコンを登録
library.add(
  // solid
  faUser,
  faSignInAlt,
  faArrowRight,
  faBuilding,
  faBriefcase,
  faLightbulb,
  faChartLine,
  faFileLines,

  // regular
  faClockRegular,
  faFileRegular,
  faUserRegular
)

import Header from '../components/Header.vue'

const pinia = createPinia()

document.addEventListener('DOMContentLoaded', () => {
  // トーストコンポーネントのマウント
  const toastEl = document.createElement('div')
  toastEl.id = 'toast-container'
  document.body.appendChild(toastEl)
  createApp(ToastNotification)
    .use(pinia)
    .mount(toastEl)
  
  // Railsのflashメッセージをトーストで表示
  if (window.railsFlashMessages) {
    import('../stores/toast').then(({ useToastStore }) => {
      const toastStore = useToastStore(pinia)
      
      Object.entries(window.railsFlashMessages).forEach(([type, message]) => {
        if (message) {
          // Rails flashのタイプをトーストのタイプにマッピング
          const toastType = type === 'notice' ? 'success' : type === 'alert' ? 'error' : 'info'
          
          // messageが配列の場合は各メッセージを個別に表示
          if (Array.isArray(message)) {
            message.forEach(msg => {
              if (msg) {
                toastStore.addToast(msg, toastType)
              }
            })
          } else {
            toastStore.addToast(message, toastType)
          }
        }
      })
    })
  }

  // Headerコンポーネントのマウント
  const headerEl = document.getElementById('header')
  if (headerEl) {
    createApp(Header)
      .use(pinia)
      .component('FontAwesomeIcon', FontAwesomeIcon)
      .mount(headerEl)
  }

  // components/index.js に登録されたコンポーネント群を一括で処理
  Object.entries(components).forEach(([name, Component]) => {
    const el = document.getElementById(name)
    if (el) {
      createApp(Component)
        .use(pinia)
        .component('FontAwesomeIcon', FontAwesomeIcon)
        .mount(el)
    }
  })

  // Resume view toggle functionality
  const toggleOptions = document.querySelectorAll('.toggle-switch__option')

  toggleOptions.forEach(option => {
    option.addEventListener('click', function() {
      const targetView = this.getAttribute('data-view')

      // トグル状態を更新
      toggleOptions.forEach(opt => opt.classList.remove('toggle-switch__option--active'))
      this.classList.add('toggle-switch__option--active')

      // すべてのビューを非表示
      document.querySelectorAll('.resume-view').forEach(view => {
        view.classList.add('resume-view--hidden')
      })

      // 対象のビューだけ表示
      const targetElement = document.querySelector(`[data-view-target="${targetView}"]`)
      if (targetElement) {
        targetElement.classList.remove('resume-view--hidden')
      }
    })
  })
})
