import type { Request, Response, NextFunction } from 'express'

import * as ticketService from '../services/ticket.service'
import { sendSuccess, sendError } from '../utils/apiResponse'

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

export async function getById(
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

    const ticket = await ticketService.getTicketById(id)
    if (!ticket) {
      sendError(res, 'Ticket not found', 404)
      return
    }

    sendSuccess(res, ticket)
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
    const { project_id, user_id, date, provider_id, folio, receipt_image_url, notes, lines } = req.body

    if (!project_id || !user_id || !date) {
      sendError(res, 'Missing required fields: project_id, user_id, date', 400)
      return
    }

    if (!Array.isArray(lines) || lines.length === 0) {
      sendError(res, 'lines must be a non-empty array', 400)
      return
    }

    for (const [i, line] of lines.entries()) {
      if (!line.vehicle_id || line.liters == null || line.cost_per_liter == null || line.total == null) {
        sendError(res, `Line ${i}: missing required fields (vehicle_id, liters, cost_per_liter, total)`, 400)
        return
      }
    }

    const ticket = await ticketService.createTicket({
      project_id,
      user_id,
      date,
      provider_id: provider_id ?? null,
      folio: folio ?? null,
      receipt_image_url: receipt_image_url ?? null,
      notes: notes ?? null,
      lines: lines.map((l: Record<string, unknown>) => ({
        vehicle_id: l['vehicle_id'] as string,
        liters: Number(l['liters']),
        cost_per_liter: Number(l['cost_per_liter']),
        total: Number(l['total']),
        odometer: l['odometer'] != null ? Number(l['odometer']) : null,
        activity: (l['activity'] as string | undefined) ?? null,
      })),
    })

    sendSuccess(res, ticket, 'Ticket created', 201)
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
      sendError(res, 'Invalid ticket id', 400)
      return
    }

    const { project_id, user_id, date, provider_id, folio, receipt_image_url, notes, status } = req.body

    if (
      project_id === undefined && user_id === undefined && date === undefined &&
      provider_id === undefined && folio === undefined && receipt_image_url === undefined &&
      notes === undefined && status === undefined
    ) {
      sendError(res, 'At least one field required to update', 400)
      return
    }

    const ticket = await ticketService.updateTicket(id, {
      ...(project_id !== undefined && { project_id }),
      ...(user_id !== undefined && { user_id }),
      ...(date !== undefined && { date }),
      ...(provider_id !== undefined && { provider_id }),
      ...(folio !== undefined && { folio }),
      ...(receipt_image_url !== undefined && { receipt_image_url }),
      ...(notes !== undefined && { notes }),
      ...(status !== undefined && { status }),
    })

    if (!ticket) {
      sendError(res, 'Ticket not found', 404)
      return
    }

    sendSuccess(res, ticket, 'Ticket updated')
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
      sendError(res, 'Invalid ticket id', 400)
      return
    }

    const deleted = await ticketService.deleteTicket(id)
    if (!deleted) {
      sendError(res, 'Ticket not found', 404)
      return
    }

    sendSuccess(res, null, 'Ticket deleted')
  } catch (err) {
    next(err)
  }
}
