import { Router } from 'express'

import * as fuelProviderController from '../controllers/fuel_provider.controller'
import { authenticate } from '../middlewares/auth'

const router = Router()

router.get('/', authenticate, fuelProviderController.getAll)
router.get('/:id', authenticate, fuelProviderController.getById)
router.post('/', authenticate, fuelProviderController.create)
router.put('/:id', authenticate, fuelProviderController.update)
router.delete('/:id', authenticate, fuelProviderController.remove)

export default router
