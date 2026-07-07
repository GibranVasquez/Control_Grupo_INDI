import app from './app'
import { config } from './config'
import { validateEnv } from './config/env'

validateEnv()

const { port } = config

app.listen(port, () => {
  console.log(`[Server] Running on http://localhost:${port}`)
})
