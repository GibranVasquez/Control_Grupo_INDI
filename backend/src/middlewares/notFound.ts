import type { Request, Response, NextFunction } from 'express'

import { sendError } from '../utils/apiResponse'

export function notFound(_req: Request, res: Response, _next: NextFunction): void {
  sendError(res, 'Route not found', 404)
}
