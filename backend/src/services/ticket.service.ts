import * as ticketRepository from '../repositories/ticket.repository'

import type { Ticket } from '../types/index'

export async function getAllTickets(): Promise<Ticket[]> {
  return ticketRepository.findAllTickets()
}

export async function getTicketById(id: string): Promise<Ticket | null> {
  return ticketRepository.findTicketById(id)
}

export async function createTicket(
  input: Omit<Ticket, 'id' | 'created_at' | 'status'>,
): Promise<Ticket> {
  return ticketRepository.createTicket(input)
}

export async function updateTicket(
  id: string,
  input: Partial<Omit<Ticket, 'id' | 'created_at'>> & { status?: Ticket['status'] },
): Promise<Ticket | null> {
  return ticketRepository.updateTicket(id, input)
}

export async function approveTicket(id: string): Promise<Ticket | null> {
  return ticketRepository.updateTicketStatus(id, 'approved')
}

export async function rejectTicket(id: string): Promise<Ticket | null> {
  return ticketRepository.updateTicketStatus(id, 'rejected')
}

export async function deleteTicket(id: string): Promise<boolean> {
  return ticketRepository.deleteTicket(id)
}
