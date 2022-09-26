<script>
  import { onDestroy, onMount } from 'svelte';
  import consumer from '~/lib/actioncable';
  
  export let booth

  let elapsedSeconds = 0
  let remaining = 0

  function update() {
    if (!booth.track) return
    elapsedSeconds = Math.floor((Date.now() - Date.parse(booth.start_time)) / 1000)
    remaining = booth.track.duration - elapsedSeconds
  }
  update()
  setInterval(update, 1000)

  function secondsToHuman(seconds) {
    let minutes = Math.floor(seconds / 60)
    seconds = seconds % 60
    return `${minutes}:${seconds.toString().padStart(2, '0')}`
  }

  let embedStartTime = elapsedSeconds

  let subscription
  onMount(async () => {
    subscription = consumer.subscriptions.create({ channel: 'BoothChannel', id: booth.id }, {
      connected() {
        console.log('connected')
      },
      disconnected() {
        console.log('disconnected')
      },
      received(data) {
        console.log(data)
        // booth = Object.assign(booth,data)
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

{booth.name}

<div class="div">
{#if booth.track}
  Current Track: {booth.track.title}<br>
  Remaining: {secondsToHuman(remaining)} / {secondsToHuman(booth.track.duration)}
{/if}

</div>

{#if booth.track}
  {#if booth.track.service == 'youtube'}
    <iframe width="560" height="315" src="https://www.youtube.com/embed/{booth.track.service_id}?autoplay=1&mute=1&start={embedStartTime}" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
  {/if}
{/if}
