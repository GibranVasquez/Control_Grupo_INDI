import { Router } from 'express'

import authRoutes from './auth.routes'
import userRoutes from './user.routes'
import vehicleRoutes from './vehicle.routes'
import projectRoutes from './project.routes'
import ticketRoutes from './ticket.routes'
import ticketLineRoutes from './ticket_line.routes'
import fuelProviderRoutes from './fuel_provider.routes'
import weeklyBalanceRoutes from './weekly_balance.routes'
import supplyRequestRoutes from './supply_request.routes'

const router = Router()

router.use('/auth', authRoutes)
router.use('/users', userRoutes)
router.use('/vehicles', vehicleRoutes)
router.use('/projects', projectRoutes)
router.use('/tickets', ticketRoutes)
router.use('/ticket-lines', ticketLineRoutes)
router.use('/fuel-providers', fuelProviderRoutes)
router.use('/weekly-balances', weeklyBalanceRoutes)
router.use('/supply-requests', supplyRequestRoutes)

export default router
