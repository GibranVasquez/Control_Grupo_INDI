import { Router } from 'express'

import * as ticketController from '../controllers/ticket.controller'
import { authenticate } from '../middlewares/auth'

const router = Router()

router.get('/', authenticate, ticketController.getAll)
router.get('/:id', authenticate, ticketController.getById)
router.post('/', authenticate, ticketController.create)
router.put('/:id', authenticate, ticketController.update)
router.delete('/:id', authenticate, ticketController.remove)

export default router
