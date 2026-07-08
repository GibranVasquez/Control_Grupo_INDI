import { supabase, supabaseAdmin } from '../lib/supabase'
import * as userRepository from '../repositories/user.repository'

import type { User } from '../types/index'

export async function login(
  email: string,
  password: string,
): Promise<{ user: User; token: string }> {
  const { data, error } = await supabase.auth.signInWithPassword({
    email,
    password,
  })

  if (error) throw error

  const user = await userRepository.findUserById(data.user.id)

  if (!user) throw new Error('User profile not found')

  return { user, token: data.session.access_token }
}
