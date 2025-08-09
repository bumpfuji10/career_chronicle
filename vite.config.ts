import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [
    RubyPlugin(),
    vue({
      template: {
        transformAssetUrls: {
          includeAbsolute: false
        }
      }
    })
  ],
  server: {
    host: '0.0.0.0',
    port: 3036,
    strictPort: true,
    hmr: {
      host: 'localhost',
      port: 3036
    }
  }
})
