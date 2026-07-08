import 'dotenv/config'

export function validateEnv(): void {
  const required = ['PORT', 'SUPABASE_URL', 'SUPABASE_ANON_KEY'] as const
  const missing = required.filter(key => !process.env[key])

  if (missing.length > 0) {
    console.error(`[Config] Missing required environment variables: ${missing.join(', ')}`)
    process.exit(1)
  }
}
