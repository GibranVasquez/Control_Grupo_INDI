import { supabaseAdmin } from '../lib/supabase'

import type { Ticket, TicketLine, TicketStatus, TicketWithLines } from '../types/index'

export type CreateTicketLineInput = {
  vehicle_id: string
  liters: number
  cost_per_liter: number
  total: number
  odometer?: number | null
  activity?: string | null
}

export type CreateTicketInput = Omit<Ticket, 'id' | 'created_at' | 'status'> & {
  lines: CreateTicketLineInput[]
}

export type UpdateTicketInput = Partial<
  Pick<Ticket, 'project_id' | 'user_id' | 'date' | 'provider_id' | 'folio' | 'receipt_image_url' | 'notes' | 'status'>
>

export async function findAllTickets(): Promise<Ticket[]> {
  const { data, error } = await supabaseAdmin
    .from('tickets')
    .select('*')
    .order('created_at', { ascending: false })

  if (error) throw error
  return data ?? []
}

export async function findTicketById(id: string): Promise<TicketWithLines | null> {
  const { data: ticket, error: ticketError } = await supabaseAdmin
    .from('tickets')
    .select('*')
    .eq('id', id)
    .single()

  if (ticketError) {
    if (ticketError.code === 'PGRST116') return null
    throw ticketError
  }

  const { data: lines, error: linesError } = await supabaseAdmin
    .from('ticket_lines')
    .select('*')
    .eq('ticket_id', id)
    .order('created_at', { ascending: true })

  if (linesError) throw linesError

  return { ...ticket, lines: (lines ?? []) as TicketLine[] }
}

export async function createTicket(input: CreateTicketInput): Promise<TicketWithLines> {
  const { lines, ...ticketData } = input

  const { data: ticket, error: ticketError } = await supabaseAdmin
    .from('tickets')
    .insert([{ ...ticketData, status: 'pending' }])
    .select()
    .single()

  if (ticketError) throw ticketError

  const lineRows = lines.map((l) => ({ ...l, ticket_id: ticket.id }))

  const { data: insertedLines, error: linesError } = await supabaseAdmin
    .from('ticket_lines')
    .insert(lineRows)
    .select()

  if (linesError) throw linesError

  return { ...ticket, lines: (insertedLines ?? []) as TicketLine[] }
}

export async function updateTicketStatus(
  id: string,
  status: TicketStatus,
): Promise<Ticket | null> {
  const { data, error } = await supabaseAdmin
    .from('tickets')
    .update({ status })
    .eq('id', id)
    .select()
    .single()

  if (error) {
    if (error.code === 'PGRST116') return null
    throw error
  }

  return data
}

export async function updateTicket(
  id: string,
  input: UpdateTicketInput,
): Promise<Ticket | null> {
  const { data, error } = await supabaseAdmin
    .from('tickets')
    .update(input)
    .eq('id', id)
    .select()
    .single()

  if (error) {
    if (error.code === 'PGRST116') return null
    throw error
  }

  return data
}

export async function deleteTicket(id: string): Promise<boolean> {
  const { data, error } = await supabaseAdmin
    .from('tickets')
    .delete()
    .eq('id', id)
    .select()

  if (error) throw error
  return (data?.length ?? 0) > 0
}
