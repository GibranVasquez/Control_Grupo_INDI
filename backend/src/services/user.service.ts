import { supabaseAdmin } from '../lib/supabase'
import * as userRepository from '../repositories/user.repository'

import type { User } from '../types/index'

export async function getAllUsers(): Promise<User[]> {
  return userRepository.findAllUsers()
}

export async function getUserById(id: string): Promise<User | null> {
  return userRepository.findUserById(id)
}

export async function updateUser(
  id: string,
  input: Pick<Partial<User>, 'name' | 'email' | 'role'>,
): Promise<User | null> {
  return userRepository.updateUser(id, input)
}

export async function createUser(input: {
  email: string
  password: string
  name?: string
  role?: 'admin' | 'operator'
}): Promise<User> {
  const { data, error } = await supabaseAdmin.auth.admin.createUser({
    email: input.email,
    password: input.password,
    email_confirm: true,
    user_metadata: { name: input.name },
  })

  if (error) throw error

  const userId = data.user.id

  if (input.name !== undefined || input.role !== undefined) {
    const updated = await userRepository.updateUser(userId, {
      name: input.name,
      role: input.role,
    })
    if (updated) return updated
  }

  const user = await userRepository.findUserById(userId)
  if (!user) throw new Error('User profile not found after creation')

  return user
}

export async function deleteUser(id: string): Promise<boolean> {
  return userRepository.deleteUser(id)
}
