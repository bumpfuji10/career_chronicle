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
  computed: {
    isLogin() {
      return window.location.pathname === '/login';
    },
    isSignUp() {
      return window.location.pathname === '/signup';
    }
  }
};
</script>
