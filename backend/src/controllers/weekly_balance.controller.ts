import type { Request, Response, NextFunction } from 'express'

import * as weeklyBalanceService from '../services/weekly_balance.service'
import { sendSuccess, sendError } from '../utils/apiResponse'

export async function getAll(
  _req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const balances = await weeklyBalanceService.getAllWeeklyBalances()
    sendSuccess(res, balances)
  } catch (err) {
    next(err)
  }
}

export async function getById(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const id = req.params['id']
    if (!id || Array.isArray(id)) {
      sendError(res, 'Invalid weekly balance id', 400)
      return
    }

    const balance = await weeklyBalanceService.getWeeklyBalanceById(id)
    if (!balance) {
      sendError(res, 'Weekly balance not found', 404)
      return
    }

    sendSuccess(res, balance)
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
    const {
      provider_id, project_id, week_number, period_start, period_end,
      requested, deposited, consumed, balance_favor,
      invoice_folio, status, comments,
    } = req.body

    if (
      !provider_id || !project_id || week_number == null ||
      !period_start || !period_end ||
      requested == null || deposited == null || consumed == null || balance_favor == null
    ) {
      sendError(
        res,
        'Missing required fields: provider_id, project_id, week_number, period_start, period_end, requested, deposited, consumed, balance_favor',
        400,
      )
      return
    }

    const balance = await weeklyBalanceService.createWeeklyBalance({
      provider_id,
      project_id,
      week_number: Number(week_number),
      period_start,
      period_end,
      requested: Number(requested),
      deposited: Number(deposited),
      consumed: Number(consumed),
      balance_favor: Number(balance_favor),
      invoice_folio: invoice_folio ?? null,
      status: status ?? 'requested',
      comments: comments ?? null,
    })

    sendSuccess(res, balance, 'Weekly balance created', 201)
  } catch (err) {
    next(err)
  }
}

export async function update(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const id = req.params['id']
    if (!id || Array.isArray(id)) {
      sendError(res, 'Invalid weekly balance id', 400)
      return
    }

    const {
      provider_id, project_id, week_number, period_start, period_end,
      requested, deposited, consumed, balance_favor,
      invoice_folio, status, comments,
    } = req.body

    if (
      provider_id === undefined && project_id === undefined && week_number === undefined &&
      period_start === undefined && period_end === undefined && requested === undefined &&
      deposited === undefined && consumed === undefined && balance_favor === undefined &&
      invoice_folio === undefined && status === undefined && comments === undefined
    ) {
      sendError(res, 'At least one field required to update', 400)
      return
    }

    const balance = await weeklyBalanceService.updateWeeklyBalance(id, {
      ...(provider_id !== undefined && { provider_id }),
      ...(project_id !== undefined && { project_id }),
      ...(week_number !== undefined && { week_number: Number(week_number) }),
      ...(period_start !== undefined && { period_start }),
      ...(period_end !== undefined && { period_end }),
      ...(requested !== undefined && { requested: Number(requested) }),
      ...(deposited !== undefined && { deposited: Number(deposited) }),
      ...(consumed !== undefined && { consumed: Number(consumed) }),
      ...(balance_favor !== undefined && { balance_favor: Number(balance_favor) }),
      ...(invoice_folio !== undefined && { invoice_folio }),
      ...(status !== undefined && { status }),
      ...(comments !== undefined && { comments }),
    })

    if (!balance) {
      sendError(res, 'Weekly balance not found', 404)
      return
    }

    sendSuccess(res, balance, 'Weekly balance updated')
  } catch (err) {
    next(err)
  }
}

export async function remove(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const id = req.params['id']
    if (!id || Array.isArray(id)) {
      sendError(res, 'Invalid weekly balance id', 400)
      return
    }

    const deleted = await weeklyBalanceService.deleteWeeklyBalance(id)
    if (!deleted) {
      sendError(res, 'Weekly balance not found', 404)
      return
    }

    sendSuccess(res, null, 'Weekly balance deleted')
  } catch (err) {
    next(err)
  }
}
