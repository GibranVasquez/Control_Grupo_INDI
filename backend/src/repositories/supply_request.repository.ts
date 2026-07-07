import { supabaseAdmin } from '../lib/supabase'

import type { SupplyRequest, SupplyRequestItem, SupplyRequestWithItems } from '../types/index'

export type CreateSupplyRequestItemInput = {
  vehicle_id?: string | null
  item_name: string
  quantity: number
  unit: string
}

export type CreateSupplyRequestInput = {
  type: 'fuel' | 'material'
  project_id: string
  requested_by: string
  needed_by: string
  comments?: string | null
  items: CreateSupplyRequestItemInput[]
}

const VALID_STATUSES = ['pending', 'approved', 'rejected', 'fulfilled'] as const

export async function findAllSupplyRequests(status?: string): Promise<SupplyRequest[]> {
  let query = supabaseAdmin
    .from('supply_requests')
    .select('*')
    .order('created_at', { ascending: false })

  if (status && (VALID_STATUSES as readonly string[]).includes(status)) {
    query = query.eq('status', status)
  }

  const { data, error } = await query
  if (error) throw error
  return data ?? []
}

export async function findSupplyRequestById(id: string): Promise<SupplyRequestWithItems | null> {
  const { data: request, error: requestError } = await supabaseAdmin
    .from('supply_requests')
    .select('*')
    .eq('id', id)
    .single()

  if (requestError) {
    if (requestError.code === 'PGRST116') return null
    throw requestError
  }

  const { data: items, error: itemsError } = await supabaseAdmin
    .from('supply_request_items')
    .select('*')
    .eq('request_id', id)
    .order('created_at', { ascending: true })

  if (itemsError) throw itemsError

  return { ...request, items: (items ?? []) as SupplyRequestItem[] }
}

export async function createSupplyRequest(
  input: CreateSupplyRequestInput,
): Promise<SupplyRequestWithItems> {
  const { items, ...requestData } = input

  const { data: request, error: requestError } = await supabaseAdmin
    .from('supply_requests')
    .insert([{ ...requestData, status: 'pending' }])
    .select()
    .single()

  if (requestError) throw requestError

  const itemRows = items.map((item) => ({ ...item, request_id: request.id }))

  const { data: insertedItems, error: itemsError } = await supabaseAdmin
    .from('supply_request_items')
    .insert(itemRows)
    .select()

  if (itemsError) throw itemsError

  return { ...request, items: (insertedItems ?? []) as SupplyRequestItem[] }
}

export async function approveSupplyRequest(
  id: string,
  approved_by: string,
): Promise<SupplyRequest | null> {
  const { data, error } = await supabaseAdmin
    .from('supply_requests')
    .update({ status: 'approved', approved_by, approved_at: new Date().toISOString() })
    .eq('id', id)
    .select()
    .single()

  if (error) {
    if (error.code === 'PGRST116') return null
    throw error
  }

  return data
}

export async function rejectSupplyRequest(
  id: string,
  approved_by: string,
): Promise<SupplyRequest | null> {
  const { data, error } = await supabaseAdmin
    .from('supply_requests')
    .update({ status: 'rejected', approved_by, approved_at: new Date().toISOString() })
    .eq('id', id)
    .select()
    .single()

  if (error) {
    if (error.code === 'PGRST116') return null
    throw error
  }

  return data
}
