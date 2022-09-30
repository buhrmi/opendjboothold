<script>
  import { page } from '@inertiajs/inertia-svelte'
  import { onDestroy, onMount } from 'svelte';
  
  import { secondsToHuman } from '~/lib/utils';
  import {subscribe, getStore} from '~/lib/actionstore';
  import YTLoader from 'youtube-iframe'
  
  
  const user = getStore('user')
  const booth = getStore($page.props.booth)
  const subscription = subscribe($page.props.booth.sgid)

  let currentTrackId = $page.props.booth.track_id

  let elapsed = $booth.elapsed
  $: if ($booth.track_id != currentTrackId) {
    currentTrackId = $booth.track_id
    $booth.elapsed = elapsed = 0
    startedAt = new Date().getTime()
    ytPlayer.loadVideoById($booth.track?.service_id)
    ytPlayer.seekTo(0)
  }
  
  let startedAt = new Date().getTime() 

  function elapse() {
    elapsed = $booth.elapsed + Math.round((new Date().getTime() - startedAt) / 1000)
  }
  setInterval(elapse, 1000)
 
  let ytPlayer
  onMount(async () => {
    YTLoader.load(function(YT) {
      ytPlayer = new YT.Player('ytplayer', {
        height: '390',
        width: '640',
        videoId: $booth.track?.service_id,
        playerVars: {
          autoplay: 1,
          controls: 0,
          disablekb: 1,
          enablejsapi: 1,
          fs: 0,
          iv_load_policy: 3,
          modestbranding: 1,
          playsinline: 1,
          rel: 0,
          showinfo: 0,
          start: elapsed
        },
        events: {

          onStateChange: function(event) {
            // set player to elapsed time
            if (event.data == YT.PlayerState.PLAYING) {
              if (ytPlayer.getCurrentTime() < elapsed) {
                ytPlayer.seekTo(elapsed)
              }
            }
          }
        }
      });
    })
  })

  function joinWaitlist() {
    subscription.perform('join_waitlist')
  }
  function leaveWaitlist() {
    subscription.perform('leave_waitlist')
  }
  function skipTrack() {
    subscription.perform('skip_track')
  }




</script>

<svelte:head>
  <title>{$booth.name} - Open DJ Booth</title>
</svelte:head>

<header class="bg-dark flex gap-4">
  <div class="p-2">
    {$booth.name}
  </div>

  {#if $booth.track}
    <div class="p-2">
      {$booth.track.title}
    </div>
    <div class="p-2">
      <span class="i-bi:clock relative -top-2px"></span> {secondsToHuman($booth.track.duration - elapsed)}
    </div>
  {/if}
</header>

<div class="flex flex-col items-center justify-center">
  <div id="ytplayer"></div>
  
  Current DJ: {$booth.dj?.display_name}
  {#if $user && $booth.dj?.id == $user.id}
    <button on:click={skipTrack}>Leave the booth</button>
  {/if}
  
<h3>Waitlist</h3>
{#each $booth.waitlists as waitlist}
{waitlist.user.display_name}<br>
{/each}

{#if $user}
  {#if $booth.waitlists.find(w => w.user.id == $user.id)}
   <button on:click={leaveWaitlist}>Leave Waitlist</button>
  {:else}
   <button on:click={joinWaitlist}>Join Waitlist</button>
  {/if}
{/if}

<h3>Moderator Stuff</h3>
<button on:click={skipTrack}>Skip Track</button>

</div>
