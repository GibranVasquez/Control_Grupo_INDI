import * as vehicleRepository from '../repositories/vehicle.repository'

import type { Vehicle } from '../types/index'

export async function getAllVehicles(): Promise<Vehicle[]> {
  return vehicleRepository.findAllVehicles()
}

export async function getVehicleById(id: string): Promise<Vehicle | null> {
  return vehicleRepository.findVehicleById(id)
}

export async function createVehicle(input: Omit<Vehicle, 'id' | 'created_at'>): Promise<Vehicle> {
  return vehicleRepository.createVehicle(input)
}

export async function updateVehicle(
  id: string,
  input: Partial<Omit<Vehicle, 'id' | 'created_at'>>,
): Promise<Vehicle | null> {
  return vehicleRepository.updateVehicle(id, input)
}

export async function deleteVehicle(id: string): Promise<boolean> {
  return vehicleRepository.deleteVehicle(id)
}
