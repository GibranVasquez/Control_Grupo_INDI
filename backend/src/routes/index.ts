import { Router } from 'express'

import authRoutes from './auth.routes.js'
import vehicleRoutes from './vehicle.routes.js'
import projectRoutes from './project.routes.js'
import ticketRoutes from './ticket.routes.js'

const router = Router()

router.use('/auth', authRoutes)
router.use('/vehicles', vehicleRoutes)
router.use('/projects', projectRoutes)
router.use('/tickets', ticketRoutes)

export default router
