import * as fuelProviderRepository from '../repositories/fuel_provider.repository'

import type { FuelProvider } from '../types/index'

export async function getAllFuelProviders(): Promise<FuelProvider[]> {
  return fuelProviderRepository.findAllFuelProviders()
}

export async function getFuelProviderById(id: string): Promise<FuelProvider | null> {
  return fuelProviderRepository.findFuelProviderById(id)
}

export async function createFuelProvider(
  input: Omit<FuelProvider, 'id' | 'created_at'>,
): Promise<FuelProvider> {
  return fuelProviderRepository.createFuelProvider(input)
}

export async function updateFuelProvider(
  id: string,
  input: Partial<Omit<FuelProvider, 'id' | 'created_at'>>,
): Promise<FuelProvider | null> {
  return fuelProviderRepository.updateFuelProvider(id, input)
}

export async function deleteFuelProvider(id: string): Promise<boolean> {
  return fuelProviderRepository.deleteFuelProvider(id)
}
