import { createApp } from 'vue'
import components from '../components';
import '../styles/application.scss';
import { library } from "@fortawesome/fontawesome-svg-core"
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import { faUser, faSignInAlt, faPlusCircle } from '@fortawesome/free-solid-svg-icons';
library.add(faUser, faSignInAlt, faPlusCircle);

document.addEventListener('DOMContentLoaded', () => {
  const vueElements = document.querySelectorAll('[data-vue-component]');

  vueElements.forEach(el => {
    const componentName = el.dataset.vueComponent;
    const component = components[componentName];

    if (component) {
      const app = createApp(component);
      app.component('font-awesome-icon', FontAwesomeIcon);
      app.mount(el);
    } else {
      console.error(`${componentName}というVueコンポーネントが見つかりません。実装状況を確認してください。`);
    }
  })
})
