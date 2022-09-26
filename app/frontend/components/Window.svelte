<script>
  import { createEventDispatcher } from 'svelte'
  const dispatch = createEventDispatcher()
  import { scale, fade } from 'svelte/transition'
</script>

<div transition:fade class="fixed w-full h-full bg-black/50"></div>

<div transition:scale={{start: 0.8}} on:click|self={() => dispatch('close')} class="fixed w-full h-full flex items-center justify-center">
  <div class="bg-dark p-8 rounded-2 max-w-full md:max-w-700px">
    <slot />
  </div>
</div>