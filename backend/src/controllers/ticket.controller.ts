import type { Request, Response, NextFunction } from 'express'

import * as ticketService from '../services/ticket.service.js'
import { sendSuccess, sendError } from '../utils/apiResponse.js'

export async function getAll(
  _req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const tickets = await ticketService.getAllTickets()
    sendSuccess(res, tickets)
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
    const { project_id, vehicle_id, operator, liters, cost_per_liter, total, receipt_image_url, notes } = req.body

    if (!project_id || !vehicle_id || !operator || liters == null || cost_per_liter == null || total == null) {
      sendError(res, 'Missing required fields', 400)
      return
    }

    const ticket = await ticketService.createTicket({
      project_id,
      vehicle_id,
      operator,
      liters: Number(liters),
      cost_per_liter: Number(cost_per_liter),
      total: Number(total),
      receipt_image_url: receipt_image_url ?? null,
      notes: notes ?? null,
    })

    sendSuccess(res, ticket, 'Ticket created', 201)
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
      sendError(res, 'Invalid ticket id', 400)
      return
    }
    const ticket = await ticketService.approveTicket(id)
    sendSuccess(res, ticket, 'Ticket approved')
  } catch (err) {
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
      sendError(res, 'Invalid ticket id', 400)
      return
    }
    const ticket = await ticketService.rejectTicket(id)
    sendSuccess(res, ticket, 'Ticket rejected')
  } catch (err) {
    next(err)
  }
}
