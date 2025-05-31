import { createApp } from 'vue'
import '../stylesheets/application.scss'
import components from './components'

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

document.addEventListener('DOMContentLoaded', () => {
  // Headerコンポーネントのマウント
  const headerEl = document.getElementById('header')
  if (headerEl) {
    createApp(Header)
      .component('FontAwesomeIcon', FontAwesomeIcon)
      .mount(headerEl)
  }

  // components/index.js に登録されたコンポーネント群を一括で処理
  Object.entries(components).forEach(([name, Component]) => {
    const el = document.getElementById(name)
    if (el) {
      createApp(Component)
        .component('FontAwesomeIcon', FontAwesomeIcon)
        .mount(el)
    }
  })
})
