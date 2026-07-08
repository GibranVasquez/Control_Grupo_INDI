import type { Request, Response, NextFunction } from 'express'

import * as userService from '../services/user.service'
import { sendSuccess, sendError } from '../utils/apiResponse'

export async function create(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const { email, password, name, role } = req.body

    if (!email || !password) {
      sendError(res, 'Missing required fields: email, password', 400)
      return
    }

    if (role !== undefined && role !== 'admin' && role !== 'operator') {
      sendError(res, 'Role must be admin or operator', 400)
      return
    }

    const user = await userService.createUser({ email, password, name, role })
    sendSuccess(res, user, 'User created', 201)
  } catch (err) {
    const message = err instanceof Error ? err.message : String(err)
    if (message.includes('already registered') || message.includes('User already registered')) {
      sendError(res, 'Email already registered', 409, message)
      return
    }
    next(err)
  }
}

export async function getAll(
  _req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const users = await userService.getAllUsers()
    sendSuccess(res, users)
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
      sendError(res, 'Invalid user id', 400)
      return
    }

    const user = await userService.getUserById(id)
    if (!user) {
      sendError(res, 'User not found', 404)
      return
    }

    sendSuccess(res, user)
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
      sendError(res, 'Invalid user id', 400)
      return
    }

    const { name, email, role } = req.body

    if (name === undefined && email === undefined && role === undefined) {
      sendError(res, 'At least one field required to update', 400)
      return
    }

    if (role !== undefined && role !== 'admin' && role !== 'operator') {
      sendError(res, 'Role must be admin or operator', 400)
      return
    }

    const user = await userService.updateUser(id, { name, email, role })
    if (!user) {
      sendError(res, 'User not found', 404)
      return
    }

    sendSuccess(res, user, 'User updated')
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
      sendError(res, 'Invalid user id', 400)
      return
    }

    const deleted = await userService.deleteUser(id)
    if (!deleted) {
      sendError(res, 'User not found', 404)
      return
    }

    sendSuccess(res, null, 'User deleted')
  } catch (err) {
    next(err)
  }
}
