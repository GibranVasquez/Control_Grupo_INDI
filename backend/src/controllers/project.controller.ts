import type { Request, Response, NextFunction } from 'express'

import * as projectService from '../services/project.service.js'
import { sendSuccess } from '../utils/apiResponse.js'

export async function getAll(
  _req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const projects = await projectService.getAllProjects()
    sendSuccess(res, projects)
  } catch (err) {
    next(err)
  }
}
