import type { Request, Response, NextFunction } from 'express'

import * as vehicleService from '../services/vehicle.service.js'
import { sendSuccess } from '../utils/apiResponse.js'

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
