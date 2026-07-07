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
    const { project_id, vehicle_id, user_id, date, liters, cost_per_liter, total, receipt_image_url, notes } = req.body

    if (!project_id || !vehicle_id || !user_id || !date || liters == null || cost_per_liter == null || total == null) {
      sendError(res, 'Missing required fields: project_id, vehicle_id, user_id, date, liters, cost_per_liter, total', 400)
      return
    }

    const ticket = await ticketService.createTicket({
      project_id,
      vehicle_id,
      user_id,
      date,
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

    const { project_id, vehicle_id, user_id, date, liters, cost_per_liter, total, receipt_image_url, notes, status } = req.body

    if (project_id === undefined && vehicle_id === undefined && user_id === undefined && date === undefined && liters === undefined && cost_per_liter === undefined && total === undefined && receipt_image_url === undefined && notes === undefined && status === undefined) {
      sendError(res, 'At least one field required to update', 400)
      return
    }

    const ticket = await ticketService.updateTicket(id, {
      ...(project_id !== undefined && { project_id }),
      ...(vehicle_id !== undefined && { vehicle_id }),
      ...(user_id !== undefined && { user_id }),
      ...(date !== undefined && { date }),
      ...(liters !== undefined && { liters: Number(liters) }),
      ...(cost_per_liter !== undefined && { cost_per_liter: Number(cost_per_liter) }),
      ...(total !== undefined && { total: Number(total) }),
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
    if (!ticket) {
      sendError(res, 'Ticket not found', 404)
      return
    }
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
    if (!ticket) {
      sendError(res, 'Ticket not found', 404)
      return
    }
    sendSuccess(res, ticket, 'Ticket rejected')
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
