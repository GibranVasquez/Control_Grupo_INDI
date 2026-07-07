export interface User {
  id: string
  name: string
  email: string
  role: 'admin' | 'operator'
  created_at: string
}

export interface Vehicle {
  id: string
  name: string
  plate: string
  fuel_type: string
  active: boolean
  created_at: string
}

export interface Project {
  id: string
  name: string
  client: string
  budget: number
  active: boolean
  created_at: string
}

export interface FuelProvider {
  id: string
  name: string
  bank: string | null
  account: string | null
  clabe: string | null
  created_at: string
}

export interface WeeklyBalance {
  id: string
  provider_id: string
  project_id: string
  week_number: number
  period_start: string
  period_end: string
  requested: number
  deposited: number
  consumed: number
  balance_favor: number
  invoice_folio: string | null
  status: 'requested' | 'paid'
  comments: string | null
  created_at: string
}

export interface TicketLine {
  id: string
  ticket_id: string
  vehicle_id: string
  liters: number
  cost_per_liter: number
  total: number
  odometer: number | null
  activity: string | null
  created_at: string
}

export interface Ticket {
  id: string
  project_id: string
  user_id: string
  date: string
  provider_id: string | null
  folio: string | null
  receipt_image_url: string | null
  notes: string | null
  status: 'pending' | 'approved' | 'rejected'
  created_at: string
}

export interface TicketWithLines extends Ticket {
  lines: TicketLine[]
}

export interface ApiResponse<T = unknown> {
  success: boolean
  data: T
  message: string
  error?: unknown
}

export type TicketStatus = 'pending' | 'approved' | 'rejected'
