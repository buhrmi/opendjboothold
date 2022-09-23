<script>
  import { inertia } from '@inertiajs/inertia-svelte'

  import UserLayer from '~/components/UserLayer.svelte'
</script>

<header>
  <a href="/" use:inertia>
    <h1 class="brand">
      Open DJ Booth
    </h1>
  </a>

  
</header>

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