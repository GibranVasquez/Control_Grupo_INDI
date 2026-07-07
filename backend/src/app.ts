import express from 'express'
import cors from 'cors'

import { supabase } from './lib/supabase'
import routes from './routes/index'
import { logger } from './middlewares/logger'
import { errorHandler } from './middlewares/errorHandler'
import { notFound } from './middlewares/notFound'

const app = express()

app.use(cors())
app.use(express.json())
app.use(logger)

app.get('/health', async (_req, res) => {
  let database = 'unhealthy'
  try {
    const { error } = await supabase.from('vehicles').select('id').limit(1)
    if (!error) database = 'healthy'
  } catch {
    database = 'unhealthy'
  }

  res.json({
    success: true,
    status: database === 'healthy' ? 'ok' : 'error',
    database,
    timestamp: new Date().toISOString(),
    version: '1.0.0',
  })
})

app.use('/api', routes)

app.use(notFound)
app.use(errorHandler)

export default app
