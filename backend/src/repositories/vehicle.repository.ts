import { supabaseAdmin } from '../lib/supabase'

import type { Vehicle } from '../types/index'

export async function findAllVehicles(): Promise<Vehicle[]> {
  const { data, error } = await supabaseAdmin
    .from('vehicles')
    .select('*')
    .order('name', { ascending: true })

  if (error) throw error
  return data ?? []
}

export async function findVehicleById(id: string): Promise<Vehicle | null> {
  const { data, error } = await supabaseAdmin
    .from('vehicles')
    .select('*')
    .eq('id', id)
    .single()

  if (error) {
    if (error.code === 'PGRST116') return null
    throw error
  }

  return data
}

export async function createVehicle(input: Omit<Vehicle, 'id' | 'created_at'>): Promise<Vehicle> {
  const { data, error } = await supabaseAdmin
    .from('vehicles')
    .insert([{ ...input, active: input.active ?? true }])
    .select()
    .single()

  if (error) throw error
  return data
}

export async function updateVehicle(
  id: string,
  input: Partial<Omit<Vehicle, 'id' | 'created_at'>>,
): Promise<Vehicle | null> {
  const { data, error } = await supabaseAdmin
    .from('vehicles')
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

export async function deleteVehicle(id: string): Promise<boolean> {
  const { data, error } = await supabaseAdmin
    .from('vehicles')
    .delete()
    .eq('id', id)
    .select()

  if (error) throw error
  return (data?.length ?? 0) > 0
}
