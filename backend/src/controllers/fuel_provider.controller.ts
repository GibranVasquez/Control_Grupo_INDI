import type { Request, Response, NextFunction } from 'express'

import * as fuelProviderService from '../services/fuel_provider.service'
import { sendSuccess, sendError } from '../utils/apiResponse'

export async function getAll(
  _req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const providers = await fuelProviderService.getAllFuelProviders()
    sendSuccess(res, providers)
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
      sendError(res, 'Invalid fuel provider id', 400)
      return
    }

    const provider = await fuelProviderService.getFuelProviderById(id)
    if (!provider) {
      sendError(res, 'Fuel provider not found', 404)
      return
    }

    sendSuccess(res, provider)
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
    const { name, bank, account, clabe } = req.body

    if (!name) {
      sendError(res, 'Missing required field: name', 400)
      return
    }

    const provider = await fuelProviderService.createFuelProvider({
      name,
      bank: bank ?? null,
      account: account ?? null,
      clabe: clabe ?? null,
    })

    sendSuccess(res, provider, 'Fuel provider created', 201)
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
      sendError(res, 'Invalid fuel provider id', 400)
      return
    }

    const { name, bank, account, clabe } = req.body

    if (name === undefined && bank === undefined && account === undefined && clabe === undefined) {
      sendError(res, 'At least one field required to update', 400)
      return
    }

    const provider = await fuelProviderService.updateFuelProvider(id, {
      ...(name !== undefined && { name }),
      ...(bank !== undefined && { bank }),
      ...(account !== undefined && { account }),
      ...(clabe !== undefined && { clabe }),
    })

    if (!provider) {
      sendError(res, 'Fuel provider not found', 404)
      return
    }

    sendSuccess(res, provider, 'Fuel provider updated')
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
      sendError(res, 'Invalid fuel provider id', 400)
      return
    }

    const deleted = await fuelProviderService.deleteFuelProvider(id)
    if (!deleted) {
      sendError(res, 'Fuel provider not found', 404)
      return
    }

    sendSuccess(res, null, 'Fuel provider deleted')
  } catch (err) {
    next(err)
  }
}
