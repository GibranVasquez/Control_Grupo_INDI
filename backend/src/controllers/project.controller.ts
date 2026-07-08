import type { Request, Response, NextFunction } from 'express'

import * as projectService from '../services/project.service'
import { sendSuccess, sendError } from '../utils/apiResponse'

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

export async function getById(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const id = req.params['id']
    if (!id || Array.isArray(id)) {
      sendError(res, 'Invalid project id', 400)
      return
    }

    const project = await projectService.getProjectById(id)
    if (!project) {
      sendError(res, 'Project not found', 404)
      return
    }

    sendSuccess(res, project)
  } catch (err) {
    next(err)
  }
}

export async function create(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const { name, client, budget } = req.body

    if (!name || !client || budget == null) {
      sendError(res, 'Missing required fields: name, client, budget', 400)
      return
    }

    const project = await projectService.createProject({
      name,
      client,
      budget: Number(budget),
      active: req.body.active ?? true,
    })

    sendSuccess(res, project, 'Project created', 201)
  } catch (err) {
    next(err)
  }
}

export async function update(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const id = req.params['id']
    if (!id || Array.isArray(id)) {
      sendError(res, 'Invalid project id', 400)
      return
    }

    const { name, client, budget } = req.body

    if (name === undefined && client === undefined && budget === undefined) {
      sendError(res, 'At least one field required to update', 400)
      return
    }

    const project = await projectService.updateProject(id, {
      name,
      client,
      budget: budget != null ? Number(budget) : undefined,
    })

    if (!project) {
      sendError(res, 'Project not found', 404)
      return
    }

    sendSuccess(res, project, 'Project updated')
  } catch (err) {
    next(err)
  }
}

export async function remove(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const id = req.params['id']
    if (!id || Array.isArray(id)) {
      sendError(res, 'Invalid project id', 400)
      return
    }

    const deleted = await projectService.deleteProject(id)
    if (!deleted) {
      sendError(res, 'Project not found', 404)
      return
    }

    sendSuccess(res, null, 'Project deleted')
  } catch (err) {
    next(err)
  }
}
