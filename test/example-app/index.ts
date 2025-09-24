Bun.serve({
  port: Bun.env.PORT,
  reusePort: true,
  async fetch(req) {
    const url = new URL(req.url)
    if (url.pathname === '/') {
      console.log(`Bar! from ${Bun.env.PORT} ${Bun.env.INSTANCE_ID}`)
      return new Response(`Bar! from ${Bun.env.PORT} ${Bun.env.INSTANCE_ID}`)
    }
    if (url.pathname === '/test') {
      return new Response(
        `Bar Test! from ${Bun.env.PORT} ${url.searchParams.get('name')}`,
      )
    }
    return new Response(`404! bar ${url.pathname}`)
  },
})
