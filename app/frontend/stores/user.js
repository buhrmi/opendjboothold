import { page } from '@inertiajs/inertia-svelte'
import { writable } from 'svelte/store'

import consumer from '~/lib/actioncable'

const stores = {}

let subscription

function getStore(store) {
  if (!stores[store]) {
    stores[store] = writable(null)
  }

  return stores[store]
}

page.subscribe(function($page) {
  if ($page.props?.logged_in && !subscription) {  
    subscription = consumer.subscriptions.create({ channel: "UserChannel" }, {
      received: function(data) {
        const store = getStore(data.store)
        store.update(function(record) {
          return Object.assign(record || {}, data.changes)
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

export {subscription}
export default getStore