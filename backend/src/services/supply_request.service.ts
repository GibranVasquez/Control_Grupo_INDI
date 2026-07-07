import * as supplyRequestRepository from '../repositories/supply_request.repository'

import type { SupplyRequest, SupplyRequestWithItems } from '../types/index'
import type { CreateSupplyRequestInput } from '../repositories/supply_request.repository'

export async function getAllSupplyRequests(status?: string): Promise<SupplyRequest[]> {
  return supplyRequestRepository.findAllSupplyRequests(status)
}

export async function getSupplyRequestById(id: string): Promise<SupplyRequestWithItems | null> {
  return supplyRequestRepository.findSupplyRequestById(id)
}

export async function createSupplyRequest(
  input: CreateSupplyRequestInput,
): Promise<SupplyRequestWithItems> {
  return supplyRequestRepository.createSupplyRequest(input)
}

function notPendingError(currentStatus: string): Error & { code: string } {
  return Object.assign(
    new Error(`Supply request is already '${currentStatus}' and cannot be transitioned`),
    { code: 'WRONG_STATUS' },
  )
}

export async function approveSupplyRequest(
  id: string,
  approvedBy: string,
): Promise<SupplyRequest | null> {
  const existing = await supplyRequestRepository.findSupplyRequestById(id)
  if (!existing) return null
  if (existing.status !== 'pending') throw notPendingError(existing.status)
  return supplyRequestRepository.approveSupplyRequest(id, approvedBy)
}

export async function rejectSupplyRequest(
  id: string,
  approvedBy: string,
): Promise<SupplyRequest | null> {
  const existing = await supplyRequestRepository.findSupplyRequestById(id)
  if (!existing) return null
  if (existing.status !== 'pending') throw notPendingError(existing.status)
  return supplyRequestRepository.rejectSupplyRequest(id, approvedBy)
}
