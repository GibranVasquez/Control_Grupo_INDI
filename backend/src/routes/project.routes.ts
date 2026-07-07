import { Router } from 'express'

import * as projectController from '../controllers/project.controller'
import { authenticate } from '../middlewares/auth'

const router = Router()

router.get('/', authenticate, projectController.getAll)
router.get('/:id', authenticate, projectController.getById)
router.post('/', authenticate, projectController.create)
router.put('/:id', authenticate, projectController.update)
router.delete('/:id', authenticate, projectController.remove)

export default router
