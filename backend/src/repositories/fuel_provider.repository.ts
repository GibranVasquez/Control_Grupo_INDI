import { supabaseAdmin } from '../lib/supabase'

import type { FuelProvider } from '../types/index'

export async function findAllFuelProviders(): Promise<FuelProvider[]> {
  const { data, error } = await supabaseAdmin
    .from('fuel_providers')
    .select('*')
    .order('name', { ascending: true })

  if (error) throw error
  return data ?? []
}

export async function findFuelProviderById(id: string): Promise<FuelProvider | null> {
  const { data, error } = await supabaseAdmin
    .from('fuel_providers')
    .select('*')
    .eq('id', id)
    .single()

  if (error) {
    if (error.code === 'PGRST116') return null
    throw error
  }

  return data
}

export async function createFuelProvider(
  input: Omit<FuelProvider, 'id' | 'created_at'>,
): Promise<FuelProvider> {
  const { data, error } = await supabaseAdmin
    .from('fuel_providers')
    .insert([input])
    .select()
    .single()

  if (error) throw error
  return data
}

export async function updateFuelProvider(
  id: string,
  input: Partial<Omit<FuelProvider, 'id' | 'created_at'>>,
): Promise<FuelProvider | null> {
  const { data, error } = await supabaseAdmin
    .from('fuel_providers')
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

export async function deleteFuelProvider(id: string): Promise<boolean> {
  const { data, error } = await supabaseAdmin
    .from('fuel_providers')
    .delete()
    .eq('id', id)
    .select()

  if (error) throw error
  return (data?.length ?? 0) > 0
}
