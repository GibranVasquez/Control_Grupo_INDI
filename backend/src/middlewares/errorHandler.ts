import type { Request, Response, NextFunction } from 'express'

import { sendError } from '../utils/apiResponse.js'

export function errorHandler(
  err: Error,
  _req: Request,
  res: Response,
  _next: NextFunction,
): void {
  console.error('[ErrorHandler]', err.message, err.stack)
  sendError(res, 'Internal server error', 500)
}
