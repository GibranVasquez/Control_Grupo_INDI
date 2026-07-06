import type { Response } from 'express'

import type { ApiResponse } from '../types/index.js'

export function sendSuccess<T>(res: Response, data: T, message = 'OK', statusCode = 200): void {
  const body: ApiResponse<T> = { success: true, data, message }
  res.status(statusCode).json(body)
}

export function sendError(res: Response, message: string, statusCode = 400): void {
  const body: ApiResponse<null> = { success: false, data: null, message }
  res.status(statusCode).json(body)
}
