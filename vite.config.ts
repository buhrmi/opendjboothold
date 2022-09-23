import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import { svelte } from '@sveltejs/vite-plugin-svelte';
import Unocss from 'unocss/vite'
import { presetUno } from 'unocss'
export default defineConfig({
  resolve: {
    dedupe: ['axios']
  },
  plugins: [
    RubyPlugin(),
    svelte({
      experimental: {
        prebundleSvelteLibraries: true
      }
    }),
    Unocss({
      presets: [
        presetUno(),
        // ...custom presets
      ],
    })
  
  ]
})
