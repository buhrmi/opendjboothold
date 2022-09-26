import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import { svelte } from '@sveltejs/vite-plugin-svelte';
import Unocss from 'unocss/vite'
import { presetUno } from 'unocss'
import presetIcons from '@unocss/preset-icons'

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
        presetIcons({
          extraProperties: {
            'display': 'inline-block',
            'vertical-align': 'middle'
          }
        }),
        presetUno(),
        // ...custom presets
      ],
    })
  
  ]
})
