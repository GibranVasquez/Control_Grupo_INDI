import app from './app.js'
import { config } from './config/index.js'

const { port } = config

app.listen(port, () => {
  console.log(`[Server] Running on http://localhost:${port}`)
})
