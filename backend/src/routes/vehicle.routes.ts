import { Router } from 'express'

import * as vehicleController from '../controllers/vehicle.controller'
import { authenticate } from '../middlewares/auth'

const router = Router()

router.get('/', authenticate, vehicleController.getAll)
router.get('/:id', authenticate, vehicleController.getById)
router.post('/', authenticate, vehicleController.create)
router.put('/:id', authenticate, vehicleController.update)
router.delete('/:id', authenticate, vehicleController.remove)

export default router
