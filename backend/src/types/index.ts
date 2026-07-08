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
  status: 'pending' | 'approved' | 'rejected'
  approved_by: string | null
  approved_at: string | null
  created_at: string
}

export type TicketLineStatus = TicketLine['status']

export interface Ticket {
  id: string
  project_id: string
  user_id: string
  date: string
  provider_id: string | null
  folio: string | null
  receipt_image_url: string | null
  notes: string | null
  /** Derivado del estado de sus ticket_lines — nunca se actualiza directamente. */
  status: 'pending' | 'approved' | 'rejected'
  created_at: string
}

export interface TicketWithLines extends Ticket {
  lines: TicketLine[]
}

export interface SupplyRequest {
  id: string
  type: 'fuel' | 'material'
  project_id: string
  requested_by: string
  needed_by: string
  status: 'pending' | 'approved' | 'rejected' | 'fulfilled'
  approved_by: string | null
  approved_at: string | null
  comments: string | null
  created_at: string
}

export interface SupplyRequestItem {
  id: string
  request_id: string
  vehicle_id: string | null
  item_name: string
  quantity: number
  unit: string
  created_at: string
}

export interface SupplyRequestWithItems extends SupplyRequest {
  items: SupplyRequestItem[]
}

export interface ApiResponse<T = unknown> {
  success: boolean
  data: T
  message: string
  error?: unknown
  warning?: string
}

export type TicketStatus = 'pending' | 'approved' | 'rejected'
