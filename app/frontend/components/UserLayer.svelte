<script>
  import { inertia } from '@inertiajs/inertia-svelte'
  import { slide } from 'svelte/transition'
  import user from '~/stores/user'
  
  let showPlaylists = false
  
  function login() {
    let url = "/session/new?provider=twitter"
    let height = 700
    let width = 500
    var left = ( screen.width - width ) / 2
    var top = ( screen.height - height ) / 2
    window.open( url, "Log in to Open DJ Booth", 'resizable = yes, width=' + width + ', height=' + height + ', top='+ top + ', left=' + left)
  }

</script>


<div class="fixed bottom-0 w-full bg-black/20 flex justify-between">
  <!-- {#if !showPlaylists} -->
    
  <button on:click={() => showPlaylists = true} class="bg-yellow flex items-center">
    <span class="i-fe:list-bullet text-xl"></span>
  </button>

  <!-- {/if} -->
  
  <div class="flex">
    {#if $user}
      {#if $user.avatar}
        <img alt="Avatar" src="/blobs/{$user.avatar}" />
      {/if}
      <a href="/session" class="logout btn" use:inertia={{method: 'delete'}}>Log out</a>
    {:else}
      <button class="primary" on:click={login}>Log in</button>
    {/if}
  </div>
</div>


{#if showPlaylists}
  <div class="fixed bottom-0 bg-black" transition:slide>
    <button on:click={() => showPlaylists = false} class="bg-purple flex items-center">
      <span class="i-fe:arrow-down text-xl"></span>
    </button>
    <div class="p-4">
      Here will be the playlists... Check back later.
    </div>
  </div>
{/if}


<style>
  .logout {
    color: white;
    background-color: #6e2e29;
  }
</style>