import { Router } from 'express'

import * as vehicleController from '../controllers/vehicle.controller.js'
import { authenticate } from '../middlewares/auth.js'

const router = Router()

router.get('/', authenticate, vehicleController.getAll)

export default router
