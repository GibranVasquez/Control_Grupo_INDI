import { createClient } from '@supabase/supabase-js'
import { config } from '../config/index'

import type { SupabaseClient } from '@supabase/supabase-js'

function createSupabaseClient(): SupabaseClient {
  if (!config.supabase.url || !config.supabase.anonKey) {
    throw new Error('Supabase is not configured. Set SUPABASE_URL and SUPABASE_ANON_KEY in .env')
  }
  return createClient(config.supabase.url, config.supabase.anonKey)
}

function createSupabaseAdminClient(): SupabaseClient {
  if (!config.supabase.url || !config.supabase.serviceKey) {
    throw new Error('Supabase is not configured. Set SUPABASE_URL and SUPABASE_SERVICE_KEY in .env')
  }
  return createClient(config.supabase.url, config.supabase.serviceKey, {
    auth: {
      persistSession: false,
      autoRefreshToken: false,
      detectSessionInUrl: false,
    },
  })
}

let _client: SupabaseClient | null = null
let _adminClient: SupabaseClient | null = null

export const supabase = new Proxy({} as SupabaseClient, {
  get(_, prop) {
    if (!_client) _client = createSupabaseClient()
    return _client[prop as keyof SupabaseClient]
  },
})

export const supabaseAdmin = new Proxy({} as SupabaseClient, {
  get(_, prop) {
    if (!_adminClient) _adminClient = createSupabaseAdminClient()
    return _adminClient[prop as keyof SupabaseClient]
  },
})
