import * as vehicleRepository from '../repositories/vehicle.repository.js'

import type { Vehicle } from '../types/index.js'

export async function getAllVehicles(): Promise<Vehicle[]> {
  return vehicleRepository.findAllVehicles()
}
