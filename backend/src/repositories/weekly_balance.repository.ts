import { supabaseAdmin } from '../lib/supabase'

import type { WeeklyBalance } from '../types/index'

export async function findAllWeeklyBalances(): Promise<WeeklyBalance[]> {
  const { data, error } = await supabaseAdmin
    .from('weekly_balances')
    .select('*')
    .order('period_start', { ascending: false })

  if (error) throw error
  return data ?? []
}

export async function findWeeklyBalanceById(id: string): Promise<WeeklyBalance | null> {
  const { data, error } = await supabaseAdmin
    .from('weekly_balances')
    .select('*')
    .eq('id', id)
    .single()

  if (error) {
    if (error.code === 'PGRST116') return null
    throw error
  }

  return data
}

export async function createWeeklyBalance(
  input: Omit<WeeklyBalance, 'id' | 'created_at'>,
): Promise<WeeklyBalance> {
  const { data, error } = await supabaseAdmin
    .from('weekly_balances')
    .insert([input])
    .select()
    .single()

  if (error) throw error
  return data
}

export async function updateWeeklyBalance(
  id: string,
  input: Partial<Omit<WeeklyBalance, 'id' | 'created_at'>>,
): Promise<WeeklyBalance | null> {
  const { data, error } = await supabaseAdmin
    .from('weekly_balances')
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

export async function deleteWeeklyBalance(id: string): Promise<boolean> {
  const { data, error } = await supabaseAdmin
    .from('weekly_balances')
    .delete()
    .eq('id', id)
    .select()

  if (error) throw error
  return (data?.length ?? 0) > 0
}

export async function findMatchingWeeklyBalance(
  project_id: string,
  provider_id: string,
  date: string,
): Promise<WeeklyBalance | null> {
  const { data, error } = await supabaseAdmin
    .from('weekly_balances')
    .select('*')
    .eq('project_id', project_id)
    .eq('provider_id', provider_id)
    .lte('period_start', date)
    .gte('period_end', date)
    .single()

  if (error) {
    if (error.code === 'PGRST116') return null
    throw error
  }

  return data
}

export async function incrementConsumed(id: string, amount: number): Promise<WeeklyBalance | null> {
  const { data, error } = await supabaseAdmin.rpc('increment_weekly_balance_consumed', {
    p_id: id,
    p_amount: amount,
  })

  if (error) throw error
  return data
}
