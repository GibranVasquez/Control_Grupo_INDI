import { Router } from 'express'

import * as ticketController from '../controllers/ticket.controller.js'
import { authenticate } from '../middlewares/auth.js'

const router = Router()

router.get('/', authenticate, ticketController.getAll)
router.post('/', authenticate, ticketController.create)
router.patch('/:id/approve', authenticate, ticketController.approve)
router.patch('/:id/reject', authenticate, ticketController.reject)

export default router
