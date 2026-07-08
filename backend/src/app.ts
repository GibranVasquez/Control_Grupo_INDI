import express from 'express'
import cors from 'cors'

import routes from './routes'
import { logger } from './middlewares/logger'
import { errorHandler } from './middlewares/errorHandler'
import { notFound } from './middlewares/notFound'

const app = express()

app.use(cors())
app.use(express.json())
app.use(logger)

app.get('/api/health', (_req, res) => {
  res.json({
    success: true,
    status: 'ok',
    database: 'healthy',
    timestamp: new Date().toISOString(),
    version: '1.0.0',
  })
})

app.use('/api', routes)

app.use(notFound)
app.use(errorHandler)

export default app
