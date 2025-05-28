<template>
  <FontAwesomeIcon :icon="['far', 'user']" />
</template>

<script>
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'

export default {
  name: 'UserIcon',
  components: {
    FontAwesomeIcon,
  }
}
</script>
