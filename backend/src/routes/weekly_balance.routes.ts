import { Router } from 'express'

import * as weeklyBalanceController from '../controllers/weekly_balance.controller'
import { authenticate } from '../middlewares/auth'

const router = Router()

router.get('/', authenticate, weeklyBalanceController.getAll)
router.get('/:id', authenticate, weeklyBalanceController.getById)
router.post('/', authenticate, weeklyBalanceController.create)
router.put('/:id', authenticate, weeklyBalanceController.update)
router.delete('/:id', authenticate, weeklyBalanceController.remove)

export default router
