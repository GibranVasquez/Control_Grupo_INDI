import type { Request, Response, NextFunction } from 'express'

import * as authService from '../services/auth.service.js'
import { sendSuccess, sendError } from '../utils/apiResponse.js'

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
    next(err)
  }
}
