import { Router } from 'express'

import * as projectController from '../controllers/project.controller.js'
import { authenticate } from '../middlewares/auth.js'

const router = Router()

router.get('/', authenticate, projectController.getAll)

export default router
