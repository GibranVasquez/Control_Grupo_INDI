import * as ticketRepository from '../repositories/ticket.repository'

import type { Ticket, TicketWithLines } from '../types/index'
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

export async function approveTicket(id: string): Promise<Ticket | null> {
  return ticketRepository.updateTicketStatus(id, 'approved')
}

export async function rejectTicket(id: string): Promise<Ticket | null> {
  return ticketRepository.updateTicketStatus(id, 'rejected')
}

export async function deleteTicket(id: string): Promise<boolean> {
  return ticketRepository.deleteTicket(id)
}
