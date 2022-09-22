<script>
  function login() {
    let url = "/session/new?provider=twitter"
    let height = 700
    let width = 500
    var left = ( screen.width - width ) / 2
    var top = ( screen.height - height ) / 2
    var newWindow = window.open( url, "Log in to Open DJ Booth", 'resizable = yes, width=' + width + ', height=' + height + ', top='+ top + ', left=' + left)
  }
</script>

<header>
  Open DJ Booth

  
  <button on:click={login}>Log in</button>

</header>

<slot />