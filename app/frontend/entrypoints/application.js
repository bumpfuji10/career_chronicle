import { createApp } from 'vue'
import Header from '../components/Header.vue'
import { library } from "@fortawesome/fontawesome-svg-core"
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import { faUser, faSignInAlt, faPlusCircle } from '@fortawesome/free-solid-svg-icons'; // 使いたいアイコンをインポートだもの
library.add(faUser, faSignInAlt, faPlusCircle);

document.addEventListener('DOMContentLoaded', () => {
  const headerEl = document.getElementById('header')
  if (headerEl) {
    const app = createApp(Header)
    app.component('font-awesome-icon', FontAwesomeIcon);
    app.mount(headerEl);
  }
})
