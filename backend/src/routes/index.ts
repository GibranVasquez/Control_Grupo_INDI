import { Router } from 'express'

import authRoutes from './auth.routes'
import userRoutes from './user.routes'
import vehicleRoutes from './vehicle.routes'
import projectRoutes from './project.routes'
import ticketRoutes from './ticket.routes'

const router = Router()

router.use('/auth', authRoutes)
router.use('/users', userRoutes)
router.use('/vehicles', vehicleRoutes)
router.use('/projects', projectRoutes)
router.use('/tickets', ticketRoutes)

export default router
