<script>
  import { inertia } from '@inertiajs/inertia-svelte'
    import { onMount } from 'svelte';

  onMount(() => {
    // append script tag
    const script = document.createElement('script');
    script.src = 'https://platform.twitter.com/widgets.js';
    script.async = true;
    document.body.appendChild(script);
  })
</script>


<div class="container text-center">
  <div class="inline-block">
  <blockquote class="twitter-tweet"><p lang="en" dir="ltr">Open DJ Booth is an open-source project in the spirit of <a href="https://twitter.com/plugdj?ref_src=twsrc%5Etfw">@plugdj</a>. It is currently in development. Nothing works. Please check back later.<br>If you&#39;re interested in development progress, please check out our GitHub repo: <a href="https://t.co/mhwWogGh1E">https://t.co/mhwWogGh1E</a></p>&mdash; Open DJ Booth (@opendjbooth) <a href="https://twitter.com/opendjbooth/status/1573287421600464897?ref_src=twsrc%5Etfw">September 23, 2022</a></blockquote> 
</div>
</div>