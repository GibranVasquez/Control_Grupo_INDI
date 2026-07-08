import { Router } from 'express'

import * as ticketLineController from '../controllers/ticket_line.controller'
import { requireAdmin } from '../middlewares/auth'

const router = Router()

router.get('/unsettled', requireAdmin, ticketLineController.listUnsettled)
router.patch('/:id/approve', requireAdmin, ticketLineController.approve)
router.patch('/:id/reject', requireAdmin, ticketLineController.reject)

export default router
