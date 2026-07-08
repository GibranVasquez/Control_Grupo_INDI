import type { Request, Response, NextFunction } from 'express'

import * as authService from '../services/auth.service'
import { sendSuccess, sendError } from '../utils/apiResponse'

export async function login(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const { email, password } = req.body

    if (!email || !password) {
      sendError(res, 'Email and password are required', 400)
      return
    }

    const result = await authService.login(email, password)
    sendSuccess(res, result, 'Login successful')
  } catch (err) {
    const message = err instanceof Error ? err.message : String(err)

    if (message === 'User profile not found') {
      sendError(res, 'User profile not found', 401, message)
      return
    }

    if (
      message.includes('Invalid login credentials') ||
      message.includes('Email not confirmed') ||
      message.includes('User not found')
    ) {
      sendError(res, 'Invalid credentials', 401, message)
      return
    }

    next(err)
  }
}

export async function logout(
  _req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    sendSuccess(res, null, 'Logout successful')
  } catch (err) {
    next(err)
  }
}
