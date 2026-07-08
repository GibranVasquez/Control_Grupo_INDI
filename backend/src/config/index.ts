import 'dotenv/config'

export const config = {
  port: Number(process.env['PORT']) || 3000,
  supabase: {
    url: process.env['SUPABASE_URL'] ?? '',
    anonKey: process.env['SUPABASE_ANON_KEY'] ?? '',
    serviceKey: process.env['SUPABASE_SERVICE_KEY'] ?? '',
  },
  nodeEnv: process.env['NODE_ENV'] ?? 'development',
} as const
