import type { Request, Response, NextFunction } from 'express'

import * as vehicleService from '../services/vehicle.service'
import { sendSuccess, sendError } from '../utils/apiResponse'

export async function getAll(
  _req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  try {
    const vehicles = await vehicleService.getAllVehicles()
    sendSuccess(res, vehicles)
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
      sendError(res, 'Invalid vehicle id', 400)
      return
    }

    const vehicle = await vehicleService.getVehicleById(id)
    if (!vehicle) {
      sendError(res, 'Vehicle not found', 404)
      return
    }

    sendSuccess(res, vehicle)
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
    const { name, plate, fuel_type } = req.body

    if (!name || !plate || !fuel_type) {
      sendError(res, 'Missing required fields: name, plate, fuel_type', 400)
      return
    }

    const vehicle = await vehicleService.createVehicle({
      name,
      plate,
      fuel_type,
      active: req.body.active ?? true,
    })

    sendSuccess(res, vehicle, 'Vehicle created', 201)
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
      sendError(res, 'Invalid vehicle id', 400)
      return
    }

    const { name, plate, fuel_type, active } = req.body

    if (name === undefined && plate === undefined && fuel_type === undefined && active === undefined) {
      sendError(res, 'At least one field required to update', 400)
      return
    }

    const vehicle = await vehicleService.updateVehicle(id, { name, plate, fuel_type, active })
    if (!vehicle) {
      sendError(res, 'Vehicle not found', 404)
      return
    }

    sendSuccess(res, vehicle, 'Vehicle updated')
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
      sendError(res, 'Invalid vehicle id', 400)
      return
    }

    const deleted = await vehicleService.deleteVehicle(id)
    if (!deleted) {
      sendError(res, 'Vehicle not found', 404)
      return
    }

    sendSuccess(res, null, 'Vehicle deleted')
  } catch (err) {
    next(err)
  }
}
