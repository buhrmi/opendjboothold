<script>
  import { inertia, page } from '@inertiajs/inertia-svelte'
  
  import { slide } from 'svelte/transition'
  import Window from '~/components/Window.svelte'
  import user from '~/stores/user'
  
  let showLoginWindow = true
  let showPlaylists = true
  let query = ''
  let searchResults = []
  function autofocus(node) {
    node.focus()
  }

  async function search() {
    const url = `https://www.googleapis.com/youtube/v3/search?q=${query}&part=snippet&type=video&videoEmbeddable=true&maxResults=50&key=${$page.props.youtube_api_key}`
    const res = await fetch(url).then(res => res.json())
    const videoIds = res.items.map(item => item.id.videoId).join(',')
    const videoUrl = `https://www.googleapis.com/youtube/v3/videos?id=${videoIds}&part=snippet,contentDetails&key=${$page.props.youtube_api_key}`
    const videoRes = await fetch(videoUrl).then(res => res.json())
    searchResults = videoRes.items
    console.log(searchResults)
  }

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
        <input use:autofocus bind:value={query} on:change={search} class="w-full h-full px-2" placeholder="Search for songs on YouTube" />
      </div>
    </div>
    <div class="flex h-500px">
      <div class="p-4 ">
        Here will be the playlists... Check back later.
      </div>
      <div class="entries overflow-y-scroll">
        {#each searchResults as result}
          <div class="flex">
            <div class="thumbnail">
              <img class="w-24" src={result.snippet.thumbnails.medium.url} />
            </div>
            <div class="info">
              <div class="title">{result.snippet.title}</div>
              <div class="channel">{result.snippet.channelTitle}</div>
            </div>
          </div>
        {/each}
      </div>
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