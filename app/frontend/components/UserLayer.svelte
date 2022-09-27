<script>
  import { inertia } from '@inertiajs/inertia-svelte'
  
  import { slide } from 'svelte/transition'
  import { debounce } from '~/lib/utils'
  import Window from '~/components/Window.svelte'
  import user from '~/stores/user'
  
  let showLoginWindow
  let showPlaylists
  let query = ''
  let searchResults = []
  function autofocus(node) {
    node.focus()
  }

  async function search() {
    searchResults = await fetch('/api/tracks?service=youtube&q=' + query).then(res => res.json())
  }
  search = debounce(search, 750)


  function login(provider) {
    let url = `/session/new?provider=${provider}`
    let height = 820
    let width = 520
    var left = ( screen.width - width ) / 2
    var top = ( screen.height - height ) / 2
    window.open( url, "Log in to Open DJ Booth", 'resizable=1,scrollbars=no,width=' + width + ', height=' + height + ', top='+ top + ', left=' + left)
  }

</script>


<div class="fixed bottom-0 w-full bg-black/20 flex justify-between">
  <!-- {#if !showPlaylists} -->
    
  <button on:click={() => showPlaylists = true} class="bg-purple color-white flex items-center">
    <span class="i-fe:list-bullet text-xl"></span>
  </button>

  <!-- {/if} -->
  
  <div class="flex">
    {#if $user}
      {#if $user.avatar}
        <img alt="Avatar" src="/blobs/{$user.avatar}?h=52" />
      {/if}
      <a href="/session" class="logout btn" use:inertia={{method: 'delete'}}>Log out</a>
    {:else}
    <button class="primary" on:click={() => showLoginWindow = true}>Log in</button>
    {/if}
  </div>
</div>



{#if showPlaylists}
  <div class="fixed bottom-0 bg-dark" transition:slide>
    <div class="flex w-full">
      <button on:click={() => showPlaylists = false} class="bg-purple color-white flex items-center">
        <span class="i-fe:arrow-down text-xl"></span>
      </button>
      <div class="search bg-black grow">
        <input use:autofocus bind:value={query} on:keyup={search} on:change={search} class="w-full h-full px-2" placeholder="Search for songs on YouTube" />
      </div>
    </div>
    <div class="flex h-500px">
      <div class="p-4 ">
        Here will be the playlists... Check back later.
      </div>
      <table class="overflow-y-scroll text-sm">
        {#each searchResults as result}
          <tr>
            <td>
              <img class="w-24" src={result.thumbnail} />
            </td>
            <td class="channel">{result.uploader}</td>
            <td class="title">{result.title}</td>
            <td class="duration">{result.duration}</td>
          </tr>
        {/each}
      </table>
    </div>
  </div>
{/if}

{#if showLoginWindow && !$user}
  <Window on:close={() => showLoginWindow = false}>
    <h2 class="mb-4">Log in with...</h2>
    <button class="bg-#1db954 color-white w-full mb-2" on:click={() => login('spotify')}>
      <span class="i-bi:spotify"></span>
      Spotify
    </button>
    <button class="bg-#7289da color-white w-full mb-2" on:click={() => login('discord')}>
      <span class="i-bi:discord"></span>
      Discord
    </button>
    <button class="bg-#1da1f2 color-white w-full mb-2" on:click={() => login('twitter')}>
      <span class="i-bi:twitter"></span>
      Twitter
    </button>
    <p class="mt-4">Log in with email is still being worked on... If you don't want to connect with another service, please check back later.</p>
  </Window>
{/if}



<style>
  .logout {
    color: white;
    background-color: #6e2e29;
  }
</style>