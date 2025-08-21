<template>
  <div class="auth-tab">
    <div class="auth-tab__login">
      <a href="/login" :class='{ active: isLogin }'>
        ログイン
      </a>
    </div>
    <div class="auth-tab__signup">
      <a href="/signup" :class='{ active: isSignUp }'>
        新規登録
      </a>
    </div>
  </div>
</template>

<script>
export default {
  name: 'AuthTab',
  mounted() {
    // data属性から初期タブを取得
    const element = document.getElementById('AuthTab');
    if (element && element.dataset.activeTab) {
      this.activeTab = element.dataset.activeTab;
    }
  },
  data() {
    return {
      activeTab: null
    };
  },
  computed: {
    isLogin() {
      // data属性が設定されていればそれを優先
      if (this.activeTab) {
        return this.activeTab === 'login';
      }
      return window.location.pathname === '/login';
    },
    isSignUp() {
      // data属性が設定されていればそれを優先
      if (this.activeTab) {
        return this.activeTab === 'signup';
      }
      return window.location.pathname === '/signup';
    }
  }
};
</script>
