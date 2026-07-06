import { supabase } from '../lib/supabase.js'

import type { Ticket } from '../types/index.js'

export async function findAllTickets(): Promise<Ticket[]> {
  const { data, error } = await supabase
    .from('tickets')
    .select('*')
    .order('created_at', { ascending: false })

  if (error) throw error
  return data ?? []
}

export async function findTicketById(id: string): Promise<Ticket | null> {
  const { data, error } = await supabase
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

export async function createTicket(input: Omit<Ticket, 'id' | 'created_at' | 'status'>): Promise<Ticket> {
  const { data, error } = await supabase
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
): Promise<Ticket> {
  const { data, error } = await supabase
    .from('tickets')
    .update({ status })
    .eq('id', id)
    .select()
    .single()

  if (error) throw error
  return data
}
