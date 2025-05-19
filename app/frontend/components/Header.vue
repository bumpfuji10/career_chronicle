<template>
  <div class="header">
    <img src="/images/career_chronicle.png" class="header__logo"/>
    <div class="header__navigation">
      <div class="header__navigation__button__login">ログイン</div>
      <div class="header__navigation__button__signup">新規登録</div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
  }
}
</script>

<style scoped lang="scss">
.header {
  display: flex;
  justify-content: space-between;

  &__logo {
    width: 75px;
  }

  &__navigation {
    display: flex;
    gap: 10px;
    align-items: center;

    &__button__login {
      background-color: white;
      color: #3a547a;
      border: 1px solid #3a547a;
      padding: 10px 20px;
      border-radius: 5px;
      cursor: pointer;
    }

    &__button__signup {
      background-color: #486896;
      color: white;
      padding: 10px 20px;
      border-radius: 5px;
      cursor: pointer;
    }
  }
}

.header__navigation__button__login:hover {
  background-color: #f0f4f9;
}

.header__navigation__button__signup:hover {
  background-color: #3a547a;
}
</style>
