import { createConsumer } from "@rails/actioncable"
import { writable } from 'svelte/store'

const consumer = createConsumer()

const stores = {}
const subscriptions = {}

export function getStore(storeId, initialData) {
  if (typeof storeId == 'object') {
    initialData = storeId
    storeId = initialData.gid
  }
  if (!stores[storeId]) {
    stores[storeId] = writable(initialData)
  }
  return stores[storeId]
}

export function subscribe(sgid, subscriptionId = sgid) {
  if (subscriptions[subscriptionId]) {
    if (sgid == subscriptionId) return subscriptions[subscriptionId]
    consumer.subscriptions.remove(subscriptions[subscriptionId])
  }
  const subscription = subscriptions[subscriptionId] = consumer.subscriptions.create({ channel: "StoresChannel", sgid }, {
    received: function(data) {
      const store = getStore(data.store)
      if (data.action == 'update') {
        store.update(function($data) {
          return Object.assign($data || {}, data.changes)
        })
      }
    }
  })
  subscription.oldPerform = subscription.perform
  subscription.perform = function(action, ...args) {
    return subscription.oldPerform(action, {args})
  }
  return subscription
}