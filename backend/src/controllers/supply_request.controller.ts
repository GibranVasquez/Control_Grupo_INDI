import type { Request, Response, NextFunction } from 'express'

import * as supplyRequestService from '../services/supply_request.service'
import { sendSuccess, sendError } from '../utils/apiResponse'

type AuthRequest = Request & { userId: string }

export async function getAll(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const status = typeof req.query['status'] === 'string' ? req.query['status'] : undefined
    const requests = await supplyRequestService.getAllSupplyRequests(status)
    sendSuccess(res, requests)
  } catch (err) {
    next(err)
  }
}

export async function create(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const { type, project_id, needed_by, comments, items } = req.body
    const requested_by = (req as AuthRequest).userId

    if (!type || !project_id || !needed_by) {
      sendError(res, 'Missing required fields: type, project_id, needed_by', 400)
      return
    }

    if (type !== 'fuel' && type !== 'material') {
      sendError(res, 'type must be "fuel" or "material"', 400)
      return
    }

    if (!Array.isArray(items) || items.length === 0) {
      sendError(res, 'items must be a non-empty array', 400)
      return
    }

    for (const [i, item] of (items as Record<string, unknown>[]).entries()) {
      if (!item['item_name'] || item['quantity'] == null || !item['unit']) {
        sendError(res, `Item ${i}: missing required fields (item_name, quantity, unit)`, 400)
        return
      }
    }

    const request = await supplyRequestService.createSupplyRequest({
      type,
      project_id,
      requested_by,
      needed_by,
      comments: comments ?? null,
      items: (items as Record<string, unknown>[]).map((item) => ({
        vehicle_id: item['vehicle_id'] != null ? String(item['vehicle_id']) : null,
        item_name: String(item['item_name']),
        quantity: Number(item['quantity']),
        unit: String(item['unit']),
      })),
    })

    sendSuccess(res, request, 'Supply request created', 201)
  } catch (err) {
    next(err)
  }
}

export async function approve(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const id = req.params['id']
    if (!id || Array.isArray(id)) {
      sendError(res, 'Invalid supply request id', 400)
      return
    }

    const approvedBy = (req as AuthRequest).userId
    const request = await supplyRequestService.approveSupplyRequest(id, approvedBy)

    if (!request) {
      sendError(res, 'Supply request not found', 404)
      return
    }

    sendSuccess(res, request, 'Supply request approved')
  } catch (err) {
    if (err instanceof Error && (err as Error & { code: string }).code === 'WRONG_STATUS') {
      sendError(res, err.message, 409)
      return
    }
    next(err)
  }
}

export async function reject(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const id = req.params['id']
    if (!id || Array.isArray(id)) {
      sendError(res, 'Invalid supply request id', 400)
      return
    }

    const approvedBy = (req as AuthRequest).userId
    const request = await supplyRequestService.rejectSupplyRequest(id, approvedBy)

    if (!request) {
      sendError(res, 'Supply request not found', 404)
      return
    }

    sendSuccess(res, request, 'Supply request rejected')
  } catch (err) {
    if (err instanceof Error && (err as Error & { code: string }).code === 'WRONG_STATUS') {
      sendError(res, err.message, 409)
      return
    }
    next(err)
  }
}
