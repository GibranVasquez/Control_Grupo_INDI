import type { Request, Response, NextFunction } from 'express'

import * as ticketLineService from '../services/ticket_line.service'
import { sendSuccess, sendError } from '../utils/apiResponse'

type AuthRequest = Request & { userId: string }

export async function listUnsettled(
  _req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const results = await ticketLineService.getUnsettledTicketLines()
    sendSuccess(res, results)
  } catch (err) {
    next(err)
  }
}

export async function approve(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const id = req.params['id']
    if (!id || Array.isArray(id)) {
      sendError(res, 'Invalid ticket line id', 400)
      return
    }

    const approvedBy = (req as AuthRequest).userId
    const result = await ticketLineService.approveTicketLine(id, approvedBy)

    if (!result) {
      sendError(res, 'Ticket line not found', 404)
      return
    }

    sendSuccess(res, result.line, 'Ticket line approved', 200, result.warning)
  } catch (err) {
    if (err instanceof Error && (err as Error & { code: string }).code === 'WRONG_STATUS') {
      sendError(res, err.message, 409)
      return
    }
    next(err)
  }
}

export async function reject(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const id = req.params['id']
    if (!id || Array.isArray(id)) {
      sendError(res, 'Invalid ticket line id', 400)
      return
    }

    const approvedBy = (req as AuthRequest).userId
    const line = await ticketLineService.rejectTicketLine(id, approvedBy)

    if (!line) {
      sendError(res, 'Ticket line not found', 404)
      return
    }

    sendSuccess(res, line, 'Ticket line rejected')
  } catch (err) {
    if (err instanceof Error && (err as Error & { code: string }).code === 'WRONG_STATUS') {
      sendError(res, err.message, 409)
      return
    }
    next(err)
  }
}
