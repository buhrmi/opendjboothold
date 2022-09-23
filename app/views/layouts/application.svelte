<script>
  import { inertia } from '@inertiajs/inertia-svelte'

  import user from '~/stores/user'

  function login() {
    let url = "/session/new?provider=twitter"
    let height = 700
    let width = 500
    var left = ( screen.width - width ) / 2
    var top = ( screen.height - height ) / 2
    var newWindow = window.open( url, "Log in to Open DJ Booth", 'resizable = yes, width=' + width + ', height=' + height + ', top='+ top + ', left=' + left)
  }
</script>

<header>
  <div class="brand">
    Open DJ Booth
  </div>

  {#if $user}
    <div class="user">
      <img alt="Avatar" src="/blobs/{$user.avatar}" />
      <a href="/session" class="btn logout" use:inertia={{method: 'delete'}}>Log out</a>
    </div>
  {:else}
    <button class="primary btn" on:click={login}>Log in</button>
  {/if}
</header>

<slot />

<style>
  header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    height: 60px;
  }
  .brand {
    padding: 1rem;
  }
  .logout {
    background-color: #6e2e29;
  }
  .btn {
    display: flex;
    align-items: center;
    height: 100%;
    padding: 0 1.5rem;
  }
  
</style>