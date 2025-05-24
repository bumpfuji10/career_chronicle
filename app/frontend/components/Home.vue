<template>
  <div class="home">
    {{ message }}
  </div>
</template>

<script>
export default {
  name: 'Home',
  data() {
    return {
      message: 'Welcome to the Home component!'
    };
  },
  mounted() {
    console.log(this.message);
  }
};
</script>
