import { supabaseAdmin } from '../lib/supabase'

import type { Ticket } from '../types/index'

type CreateTicketInput = Omit<Ticket, 'id' | 'created_at' | 'status'>
type UpdateTicketInput = Partial<CreateTicketInput> & { status?: Ticket['status'] }

export async function findAllTickets(): Promise<Ticket[]> {
  const { data, error } = await supabaseAdmin
    .from('tickets')
    .select('*')
    .order('created_at', { ascending: false })

  if (error) throw error
  return data ?? []
}

export async function findTicketById(id: string): Promise<Ticket | null> {
  const { data, error } = await supabaseAdmin
    .from('tickets')
    .select('*')
    .eq('id', id)
    .single()

  if (error) {
    if (error.code === 'PGRST116') return null
    throw error
  }

  return data
}

export async function createTicket(input: CreateTicketInput): Promise<Ticket> {
  const { data, error } = await supabaseAdmin
    .from('tickets')
    .insert([{ ...input, status: 'pending' }])
    .select()
    .single()

  if (error) throw error
  return data
}

export async function updateTicketStatus(
  id: string,
  status: 'approved' | 'rejected',
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
