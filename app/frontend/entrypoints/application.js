import './application.css'

import axios from 'axios'

import Layout from '../pages/_layout.svelte'

import { Inertia } from '@inertiajs/inertia'
import { createInertiaApp } from '@inertiajs/inertia-svelte'
import { InertiaProgress } from '@inertiajs/progress'

const pages = import.meta.glob('../pages/**/*.svelte')

const csrfToken = document.querySelector('meta[name=csrf-token]').content
axios.defaults.headers.common['X-CSRF-Token'] = csrfToken

InertiaProgress.init()

createInertiaApp({ 
  resolve: async name => {
    const page = await pages[`../pages/${name}.svelte`]()
    return Object.assign({layout: Layout}, page)
  },
  setup({ el, App, props }) {
    new App({ target: el, props })
  }
})

window.addEventListener('message', function(event) {
  if (event.data == 'logged_in') Inertia.reload()
})