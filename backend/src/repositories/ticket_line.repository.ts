import { supabaseAdmin } from '../lib/supabase'

import type { TicketLine, TicketLineStatus } from '../types/index'

export type TicketLineWithTicket = TicketLine & {
  ticket: { folio: string | null; project_id: string; provider_id: string | null; date: string }
}

export async function findTicketLineWithTicket(id: string): Promise<TicketLineWithTicket | null> {
  const { data, error } = await supabaseAdmin
    .from('ticket_lines')
    .select('*, ticket:tickets(folio, project_id, provider_id, date)')
    .eq('id', id)
    .single()

  if (error) {
    if (error.code === 'PGRST116') return null
    throw error
  }

  return data as unknown as TicketLineWithTicket
}

export async function findApprovedLines(): Promise<TicketLineWithTicket[]> {
  const { data, error } = await supabaseAdmin
    .from('ticket_lines')
    .select('*, ticket:tickets(folio, project_id, provider_id, date)')
    .eq('status', 'approved')

  if (error) throw error
  return (data ?? []) as unknown as TicketLineWithTicket[]
}

export async function findLineStatusesByTicketId(
  ticket_id: string,
): Promise<Pick<TicketLine, 'status'>[]> {
  const { data, error } = await supabaseAdmin
    .from('ticket_lines')
    .select('status')
    .eq('ticket_id', ticket_id)

  if (error) throw error
  return data ?? []
}

export async function updateTicketLineStatus(
  id: string,
  status: Extract<TicketLineStatus, 'approved' | 'rejected'>,
  approved_by: string,
): Promise<TicketLine | null> {
  const { data, error } = await supabaseAdmin
    .from('ticket_lines')
    .update({ status, approved_by, approved_at: new Date().toISOString() })
    .eq('id', id)
    .select()
    .single()

  if (error) {
    if (error.code === 'PGRST116') return null
    throw error
  }

  return data
}
