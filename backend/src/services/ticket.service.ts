import * as ticketRepository from '../repositories/ticket.repository'
import * as ticketLineRepository from '../repositories/ticket_line.repository'

import type { Ticket, TicketStatus, TicketWithLines } from '../types/index'
import type { CreateTicketInput, UpdateTicketInput } from '../repositories/ticket.repository'

export async function getAllTickets(): Promise<Ticket[]> {
  return ticketRepository.findAllTickets()
}

export async function getTicketById(id: string): Promise<TicketWithLines | null> {
  return ticketRepository.findTicketById(id)
}

export async function createTicket(input: CreateTicketInput): Promise<TicketWithLines> {
  return ticketRepository.createTicket(input)
}

export async function updateTicket(
  id: string,
  input: UpdateTicketInput,
): Promise<Ticket | null> {
  return ticketRepository.updateTicket(id, input)
}

export async function recalculateTicketStatus(ticket_id: string): Promise<Ticket | null> {
  const lines = await ticketLineRepository.findLineStatusesByTicketId(ticket_id)

  let status: TicketStatus
  if (lines.some((l) => l.status === 'pending')) {
    status = 'pending'
  } else if (lines.every((l) => l.status === 'rejected')) {
    status = 'rejected'
  } else {
    status = 'approved'
  }

  return ticketRepository.updateTicketStatus(ticket_id, status)
}

export async function deleteTicket(id: string): Promise<boolean> {
  return ticketRepository.deleteTicket(id)
}
