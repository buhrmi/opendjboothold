import axios from 'axios'

import Layout from '../../views/layouts/application.svelte'

import { createInertiaApp } from '@inertiajs/inertia-svelte'
import { InertiaProgress } from '@inertiajs/progress'

const pages = import.meta.glob('../../views//**/*.svelte')

const csrfToken = document.querySelector('meta[name=csrf-token]').content
axios.defaults.headers.common['X-CSRF-Token'] = csrfToken

InertiaProgress.init()

createInertiaApp({ 
  resolve: async name => {
    const page = await pages[`../../views/${name}.svelte`]()
    return Object.assign({layout: Layout}, page)
  },
  setup({ el, App, props }) {
    new App({ target: el, props })
  },
})
