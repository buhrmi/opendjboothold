<script>
  import { inertia } from '@inertiajs/inertia-svelte'
    import { onMount } from 'svelte';
  export let booths

  onMount(() => {
    // append script tag
    const script = document.createElement('script');
    script.src = 'https://platform.twitter.com/widgets.js';
    script.async = true;
    document.body.appendChild(script);
  })
</script>

<header>
  <a href="/" use:inertia>
    <h1 class="brand">
      Open DJ Booth
    </h1>
  </a>
</header>

<div class="container text-center">
  <div class="inline-block">
    <blockquote class="twitter-tweet"><p lang="en" dir="ltr">Open DJ Booth is an open-source project in the spirit of <a href="https://twitter.com/plugdj?ref_src=twsrc%5Etfw">@plugdj</a>. It is currently in development. Nothing works. Please check back later.<br>If you&#39;re interested in development progress, please check out our GitHub repo: <a href="https://t.co/mhwWogGh1E">https://t.co/mhwWogGh1E</a></p>&mdash; Open DJ Booth (@opendjbooth) <a href="https://twitter.com/opendjbooth/status/1573287421600464897?ref_src=twsrc%5Etfw">September 23, 2022</a></blockquote> 
  </div>
</div>

<div class="container mt-12">
  <h2 class="mb-4">Booths</h2>

  <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
    {#each booths as booth}
      <div class="booth">
        <a href="/booths/{booth.id}" use:inertia>
          <div class="booth__image">
            {#if booth.image}
              <img src={booth.image} />
            {:else}
              <img src="https://via.placeholder.com/300x150" />
            {/if}
            <!-- <img src="/blobs/{booth.image}?h=200" alt="Booth image" /> -->
          </div>
          <div class="booth__name">
            {booth.name}
          </div>
        </a>
      </div>
    {/each}
  </div>

</div>

<style>
  .booth {
    background-color: #1a1a1a;
    border-radius: 0.5rem;
    box-shadow: 0 0 0.5rem rgba(0, 0, 0, 0.1);
    overflow: hidden;
  }

  .booth__image {
    height: 200px;
    overflow: hidden;
    background-color: #333;
  }

  .booth__image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }

  .booth__name {
    padding: 1rem;
  }

</style>