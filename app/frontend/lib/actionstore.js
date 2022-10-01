import { createConsumer } from "@rails/actioncable"
import { writable } from 'svelte/store'

const consumer = createConsumer()

const stores = {}
const subscriptions = {}

function getStore(storeId, initialData) {
  if (!stores[storeId]) {
    stores[storeId] = writable(initialData)
  }
  return stores[storeId]
}

export function subscribe(sgid, initial, store_id = sgid) {
  if (sgid !== store_id && subscriptions[store_id]) {
    consumer.subscriptions.remove(subscriptions[store_id])
  }
  if (!sgid) return writable(null)
  const defaultStore = getStore(store_id, initial)
  const subscription = subscriptions[store_id] ||= consumer.subscriptions.create({ channel: "StoresChannel", sgid }, {
    received: function(data) {
      const store = getStore(data.store_id || store_id)
      if (data.action == 'update') {
        store.update(function($data) {
          return Object.assign($data || {}, data.changes)
        })
      }
    }
  })
  defaultStore.perform = function(action, ...args) {
    return subscription.perform(action, {args})
  }
  defaultStore.unsubscribe = function() {
    subscriptions[sgid] = null
    consumer.subscriptions.remove(subscription)
  }
  return defaultStore
}

export {getStore as store}