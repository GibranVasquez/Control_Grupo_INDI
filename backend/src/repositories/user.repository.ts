import { supabaseAdmin } from '../lib/supabase'

import type { User } from '../types/index'

const SAFE_COLUMNS = 'id, name, email, role, created_at'

export async function findAllUsers(): Promise<User[]> {
  const { data, error } = await supabaseAdmin
    .from('users')
    .select(SAFE_COLUMNS)
    .order('name', { ascending: true })

  if (error) throw error
  return data ?? []
}

export async function findUserByEmail(email: string): Promise<User | null> {
  const { data, error } = await supabaseAdmin
    .from('users')
    .select(SAFE_COLUMNS)
    .eq('email', email)
    .single()

  if (error) {
    if (error.code === 'PGRST116') return null
    throw error
  }

  return data
}

export async function findUserById(id: string): Promise<User | null> {
  const { data, error } = await supabaseAdmin
    .from('users')
    .select(SAFE_COLUMNS)
    .eq('id', id)
    .single()

  if (error) {
    if (error.code === 'PGRST116') return null
    throw error
  }

  return data
}

export async function updateUser(
  id: string,
  input: Pick<Partial<User>, 'name' | 'email' | 'role'>,
): Promise<User | null> {
  const { data, error } = await supabaseAdmin
    .from('users')
    .update(input)
    .eq('id', id)
    .select(SAFE_COLUMNS)
    .single()

  if (error) {
    if (error.code === 'PGRST116') return null
    throw error
  }

  return data
}

export async function deleteUser(id: string): Promise<boolean> {
  const { data, error } = await supabaseAdmin
    .from('users')
    .delete()
    .eq('id', id)
    .select()

  if (error) throw error
  return (data?.length ?? 0) > 0
}
