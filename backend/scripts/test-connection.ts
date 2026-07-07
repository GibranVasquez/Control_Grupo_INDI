import { supabase } from './src/lib/supabase'

async function testConnection() {
  console.log('Testing Supabase connection...\n')

  try {
    const { data, error } = await supabase
      .from('vehicles')
      .select('*')
      .limit(1)

    if (error) {
      console.error('Connection failed:', error.message)
      console.error('Details:', error.details ?? 'N/A')
      process.exit(1)
    }

    console.log('Connection successful!\n')
    console.log('Sample data:', data && data.length > 0 ? JSON.stringify(data[0], null, 2) : '(empty table)')
    console.log()
    process.exit(0)
  } catch (err) {
    const message = err instanceof Error ? err.message : String(err)
    console.error('Connection failed:', message)
    process.exit(1)
  }
}

testConnection()
