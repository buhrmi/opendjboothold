<script>
  import { inertia, page } from '@inertiajs/inertia-svelte'
  
  import { slide } from 'svelte/transition'
  import { debounce,secondsToHuman } from '~/lib/utils'
  import Window from '~/components/Window.svelte'
  import {subscribe,store} from '~/lib/actionstore'

  $: user = subscribe($page.props.user_sgid, null, 'user')

  let selectedPlaylist
  let showLoginWindow
  let showPlaylists = true
  let query = ''
  let searchResults = []
  function autofocus(node) {
    node.focus()
  }
  

  async function search() {
    if (query.length < 3) {
      searchResults = []
      return
    }
    searchResults = await fetch('/api/tracks?service=youtube&q=' + query).then(res => res.json())
    selectedPlaylist = null
  }
  search = debounce(search, 750)

  function createPlaylist() {
    const name = window.prompt('Playlist name')
    user.perform('create_playlist', name)
  }

  function login(provider) {
    let url = `/session/new?provider=${provider}`
    let height = 820
    let width = 520
    var left = ( screen.width - width ) / 2
    var top = ( screen.height - height ) / 2
    window.open( url, "Log in to Open DJ Booth", 'resizable=1,scrollbars=no,width=' + width + ', height=' + height + ', top='+ top + ', left=' + left)
  }

  function setActivePlaylist(playlist) {
    user.perform('set_active_playlist', playlist.id)
  }

  function addToActivePlaylist(track) {
    user.perform('add_to_active_playlist', track.id)
  }

  function addToPlaylist(playlist, track) {
    user.perform('add_to_playlist', playlist.id, track.id)
  }

  function removeFromPlaylist(playlist, track) {
    user.perform('remove_from_playlist', playlist.id, track.id)
  }

  function moveToTop(playlist, track) {
    user.perform('move_track_to_top', playlist.id, track.id)
  }

</script>


<div class="fixed bottom-0 w-full bg-black/20 flex justify-between">
  <button on:click={() => showPlaylists = true} class="bg-purple color-white flex items-center">
    <span class="i-fe:list-bullet text-xl"></span>
  </button>
  <div class="flex">
    {#if $user}
      {#if $user.avatar}
        <img alt="Avatar" src="/blobs/{$user.avatar}?h=52" />
      {/if}
      <a href="/session" class="bg-red text-white btn" use:inertia={{method: 'delete'}}>Log out</a>
    {:else}
    <button class="primary" on:click={() => showLoginWindow = true}>Log in</button>
    {/if}
  </div>
</div>


{#if showPlaylists && $user}
  <div class="fixed bottom-0 bg-dark" transition:slide>
    <div class="flex w-full">
      <button on:click={() => showPlaylists = false} class="bg-purple color-white flex items-center">
        <span class="i-fe:arrow-down text-xl"></span>
      </button>
      <div class="search bg-black grow">
        <input use:autofocus on:focus={() => selectedPlaylist = null} bind:value={query} on:keyup={search} on:change={search} class="w-full h-full px-2" placeholder="Search for songs on YouTube" />
      </div>
    </div>
    <div class="flex h-500px">
      <div class="flex flex-col w-42">
        <div class="grow overflow-y-auto">
          {#each $user.playlists as playlist (playlist.id)}
          <div class="px-4 py-2" on:click={() => selectedPlaylist = store(`playlist_${playlist.id}`)}>
            
            {playlist.name}
            {#if playlist.id == $user.active_playlist_id}
              <span class="i-fe:check"></span>
            {/if}
          </div>
          {/each}
        </div>
        <div class="actions">
          <button on:click={createPlaylist} class="bg-purple color-white flex items-center">
            <span class="i-fe:plus text-xl"></span>
            Create&nbsp;Playlist
          </button>
        </div>
      </div>
      <div class="overflow-y-auto grow">
        {#if selectedPlaylist}
          <div class="p-2">
            {$selectedPlaylist.name}
            <button on:click={() => setActivePlaylist($selectedPlaylist)}>SET ACTIVE</button>
          </div>
          <div class="grid grid-cols-[auto_200px_1fr_auto] items-stretch gap-2 pr-4">
            {#each $selectedPlaylist.tracks as track (track.id)}
              <div class="contents group">
                <img class="w-24" src={track.thumbnail} />
              
                <div class="channel flex items-center">{track.uploader}</div>
                <div class="title  flex items-center">{track.title}</div>
                <div class="justify-end flex items-center relative">
                  {secondsToHuman(track.duration)}
                  <div class="actions group-hover:absolute right-0 top-0 h-full hidden group-hover:flex items-center bg-dark">
                    <button on:click={() => removeFromPlaylist($selectedPlaylist, track)}>REMOVE</button>
                    <button on:click={() => moveToTop($selectedPlaylist, track)}>TO TOP</button>
                  </div>
                </div>
              </div>
            {/each}
          </div>
        {:else}
          <div class="grid grid-cols-[auto_200px_1fr_auto] items-stretch gap-2 pr-4">
            {#each searchResults as result}
              <div class="contents group">
                <img class="w-24" src={result.thumbnail} />
              
                <div class="channel flex items-center">{result.uploader}</div>
                <div class="title  flex items-center">{result.title}</div>
                <div class="justify-end flex items-center relative">
                  {secondsToHuman(result.duration)}
                  <div class="actions group-hover:absolute right-0 top-0 h-full hidden group-hover:flex items-center bg-dark">
                    <button on:click={() => addToActivePlaylist(result)}>ADD</button>
                  </div>
                </div>
              </div>
            {/each}
          </div>
        {/if}
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