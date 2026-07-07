import type { Response } from 'express'

import type { ApiResponse } from '../types/index'

export function sendSuccess<T>(res: Response, data: T, message = 'OK', statusCode = 200): void {
  const body: ApiResponse<T> = { success: true, data, message }
  res.status(statusCode).json(body)
}

export function sendError(res: Response, message: string, statusCode = 400, error?: unknown): void {
  const body: ApiResponse<null> = { success: false, data: null, message, error: error ?? null }
  res.status(statusCode).json(body)
}
