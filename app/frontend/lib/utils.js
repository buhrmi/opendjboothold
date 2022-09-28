export function debounce(func, timeout = 300){
  let timer
  return (...args) => {
    clearTimeout(timer)
    timer = setTimeout(() => { func.apply(this, args) }, timeout)
  }
}

export function secondsToHuman(seconds) {
  let minutes = Math.floor(seconds / 60)
  seconds = seconds % 60
  return `${minutes}:${seconds.toString().padStart(2, '0')}`
}
