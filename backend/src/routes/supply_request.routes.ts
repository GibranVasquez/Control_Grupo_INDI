import { Router } from 'express'

import * as supplyRequestController from '../controllers/supply_request.controller'
import { authenticate, requireAdmin } from '../middlewares/auth'

const router = Router()

router.get('/', authenticate, supplyRequestController.getAll)
router.post('/', authenticate, supplyRequestController.create)
router.patch('/:id/approve', requireAdmin, supplyRequestController.approve)
router.patch('/:id/reject', requireAdmin, supplyRequestController.reject)

export default router
