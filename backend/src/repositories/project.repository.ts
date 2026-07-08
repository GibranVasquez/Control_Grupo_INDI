import { supabaseAdmin } from '../lib/supabase'

import type { Project } from '../types/index'

export async function findAllProjects(): Promise<Project[]> {
  const { data, error } = await supabaseAdmin
    .from('projects')
    .select('*')
    .order('name', { ascending: true })

  if (error) throw error
  return data ?? []
}

export async function findProjectById(id: string): Promise<Project | null> {
  const { data, error } = await supabaseAdmin
    .from('projects')
    .select('*')
    .eq('id', id)
    .single()

  if (error) {
    if (error.code === 'PGRST116') return null
    throw error
  }

  return data
}

export async function createProject(input: Omit<Project, 'id' | 'created_at'>): Promise<Project> {
  const { data, error } = await supabaseAdmin
    .from('projects')
    .insert([input])
    .select()
    .single()

  if (error) throw error
  return data
}

export async function updateProject(
  id: string,
  input: Partial<Omit<Project, 'id' | 'created_at'>>,
): Promise<Project | null> {
  const { data, error } = await supabaseAdmin
    .from('projects')
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

export async function deleteProject(id: string): Promise<boolean> {
  const { data, error } = await supabaseAdmin
    .from('projects')
    .delete()
    .eq('id', id)
    .select()

  if (error) throw error
  return (data?.length ?? 0) > 0
}
