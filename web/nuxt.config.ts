// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  devtools: { enabled: true },
  modules: [
    '@nuxtjs/tailwindcss', 
    '@hebilicious/vue-query-nuxt'
  ],
  tailwindcss: {
    exposeConfig: true,
  }
})
