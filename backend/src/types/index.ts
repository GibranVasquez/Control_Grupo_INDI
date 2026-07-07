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

export interface Ticket {
  id: string
  project_id: string
  vehicle_id: string
  user_id: string
  date: string
  liters: number
  cost_per_liter: number
  total: number
  receipt_image_url: string | null
  notes: string | null
  status: 'pending' | 'approved' | 'rejected'
  created_at: string
}

export interface ApiResponse<T = unknown> {
  success: boolean
  data: T
  message: string
  error?: unknown
}

export interface LoginRequest {
  email: string
  password: string
}

export type TicketStatus = 'pending' | 'approved' | 'rejected'
