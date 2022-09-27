<script>
  import { onDestroy, onMount } from 'svelte';
  import consumer from '~/lib/actioncable';
  import user from '~/stores/user';
  import YTLoader from 'youtube-iframe'
  export let booth
  
  let elapsed = booth.elapsed
  let startedAt = new Date().getTime() 

  function update() {
    elapsed = booth.elapsed + Math.round((new Date().getTime() - startedAt) / 1000)
  }
  
  setInterval(update, 1000)

  function secondsToHuman(seconds) {
    let minutes = Math.floor(seconds / 60)
    seconds = seconds % 60
    return `${minutes}:${seconds.toString().padStart(2, '0')}`
  }

  function joinWaitlist() {
    subscription.perform('join_waitlist')
  }
  function leaveWaitlist() {
    subscription.perform('leave_waitlist')
  }
  function skipTrack() {
    subscription.perform('skip_track')
  }


  let subscription
  let ytPlayer
  onMount(async () => {
    YTLoader.load(function(YT) {
      ytPlayer = new YT.Player('ytplayer', {
        height: '390',
        width: '640',
        videoId: booth.track?.service_id,
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
          // 'onReady': onPlayerReady,
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
    subscription = consumer.subscriptions.create({ channel: 'BoothChannel', id: booth.id }, {
      received(data) {
        if (data.action == 'update') booth = Object.assign(booth, data.changes)
        if (data.action == 'new_track') {
          booth.track = data.track
          booth.elapsed = elapsed = 0
          startedAt = new Date().getTime()
          ytPlayer.loadVideoById(data.track.service_id)
          ytPlayer.seekTo(0)
        }
      }
    })
  })

  onDestroy(() => {
    consumer.subscriptions.remove(subscription)
    subscription = null
  })
</script>

<svelte:head>
  <title>{booth.name} - Open DJ Booth</title>
</svelte:head>

<header class="bg-dark flex gap-4">
  <div class="p-2">
    {booth.name}
  </div>

  {#if booth.track}
    <div class="p-2">
      {booth.track.title}
    </div>
    <div class="p-2">
      {secondsToHuman(booth.track.duration - elapsed)}
    </div>
  {/if}
</header>

<div class="flex flex-col items-center justify-center">
  <div id="ytplayer"></div>
  
  
<h3>Waitlist</h3>
{#each booth.waitlists as waitlist}
{waitlist.user.display_name}<br>
{/each}

{#if $user}
{#if booth.waitlists.find(w => w.user.id == $user.id)}
<button on:click={leaveWaitlist}>Leave Waitlist</button>
{:else}
<button on:click={joinWaitlist}>Join Waitlist</button>
{/if}
{/if}

<h3>Moderator Stuff</h3>
<button on:click={skipTrack}>Skip Track</button>

</div>
