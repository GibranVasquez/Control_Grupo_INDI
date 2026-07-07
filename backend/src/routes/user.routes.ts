import { Router } from 'express'

import * as userController from '../controllers/user.controller'
import { authenticate } from '../middlewares/auth'

const router = Router()

router.post('/', authenticate, userController.create)
router.get('/', authenticate, userController.getAll)
router.get('/:id', authenticate, userController.getById)
router.put('/:id', authenticate, userController.update)
router.delete('/:id', authenticate, userController.remove)

export default router
