import * as weeklyBalanceRepository from '../repositories/weekly_balance.repository'

import type { WeeklyBalance } from '../types/index'

export async function getAllWeeklyBalances(): Promise<WeeklyBalance[]> {
  return weeklyBalanceRepository.findAllWeeklyBalances()
}

export async function getWeeklyBalanceById(id: string): Promise<WeeklyBalance | null> {
  return weeklyBalanceRepository.findWeeklyBalanceById(id)
}

export async function createWeeklyBalance(
  input: Omit<WeeklyBalance, 'id' | 'created_at'>,
): Promise<WeeklyBalance> {
  return weeklyBalanceRepository.createWeeklyBalance(input)
}

export async function updateWeeklyBalance(
  id: string,
  input: Partial<Omit<WeeklyBalance, 'id' | 'created_at'>>,
): Promise<WeeklyBalance | null> {
  return weeklyBalanceRepository.updateWeeklyBalance(id, input)
}

export async function deleteWeeklyBalance(id: string): Promise<boolean> {
  return weeklyBalanceRepository.deleteWeeklyBalance(id)
}
