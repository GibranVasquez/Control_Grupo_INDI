import type { Request, Response, NextFunction } from 'express'

import { supabaseAdmin } from '../lib/supabase'
import { sendError } from '../utils/apiResponse'

export interface AuthenticatedRequest extends Request {
  userId?: string
  userRole?: string
}

export async function authenticate(
  req: AuthenticatedRequest,
  res: Response,
  next: NextFunction,
): Promise<void> {
  const token = req.headers.authorization?.replace('Bearer ', '')

  if (!token) {
    sendError(res, 'Missing authorization token', 401)
    return
  }

  const { data, error } = await supabaseAdmin.auth.getUser(token)

  if (error || !data.user) {
    sendError(res, 'Invalid or expired token', 401)
    return
  }

  req.userId = data.user.id
  next()
}

export async function requireAdmin(
  req: AuthenticatedRequest,
  res: Response,
  next: NextFunction,
): Promise<void> {
  const token = req.headers.authorization?.replace('Bearer ', '')

  if (!token) {
    sendError(res, 'Missing authorization token', 401)
    return
  }

  const { data: { user }, error } = await supabaseAdmin.auth.getUser(token)

  if (error || !user) {
    sendError(res, 'Invalid or expired token', 401)
    return
  }

  const { data: profile } = await supabaseAdmin
    .from('users')
    .select('role')
    .eq('id', user.id)
    .single()

  if (profile?.role !== 'admin') {
    sendError(res, 'Admin access required', 403)
    return
  }

  req.userId = user.id
  req.userRole = profile.role
  next()
}
