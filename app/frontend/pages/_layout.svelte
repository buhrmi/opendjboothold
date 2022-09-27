<script>
  import { inertia } from '@inertiajs/inertia-svelte'
  import UserLayer from '~/components/UserLayer.svelte'
</script>


<UserLayer />

<slot />

<style>
  header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    height: 48px;
  }
  .brand {
    padding: 1rem;
  }

</style>