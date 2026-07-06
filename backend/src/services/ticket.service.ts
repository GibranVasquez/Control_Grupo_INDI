import * as ticketRepository from '../repositories/ticket.repository.js'

import type { Ticket } from '../types/index.js'

export async function getAllTickets(): Promise<Ticket[]> {
  return ticketRepository.findAllTickets()
}

export async function createTicket(
  input: Omit<Ticket, 'id' | 'created_at' | 'status'>,
): Promise<Ticket> {
  return ticketRepository.createTicket(input)
}

export async function approveTicket(id: string): Promise<Ticket> {
  return ticketRepository.updateTicketStatus(id, 'approved')
}

export async function rejectTicket(id: string): Promise<Ticket> {
  return ticketRepository.updateTicketStatus(id, 'rejected')
}
