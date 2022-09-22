import { page } from '@inertiajs/inertia-svelte'
import { writable } from 'svelte/store'

import consumer from './consumer'

let subscription
const store = writable(null)

page.subscribe(function($page) {
  if ($page.props?.logged_in && !subscription) {  
    subscription = consumer.subscriptions.create({ channel: "UserChannel" }, {
      received: function(newValues) {
        store.update(function(oldValues) {
          return Object.assign(oldValues || {}, newValues)
        })
      }
    })
  }
  if (!$page.props?.logged_in && subscription) {
    consumer.subscriptions.remove(subscription)
    store.set(null)
    subscription = null
  }
})

export default store