import * as ticketLineRepository from '../repositories/ticket_line.repository'
import * as weeklyBalanceRepository from '../repositories/weekly_balance.repository'
import * as ticketService from './ticket.service'

import type { TicketLine } from '../types/index'
import type { TicketLineWithTicket } from '../repositories/ticket_line.repository'

function notPendingError(currentStatus: string): Error & { code: string } {
  return Object.assign(
    new Error(`Ticket line is already '${currentStatus}' and cannot be transitioned`),
    { code: 'WRONG_STATUS' },
  )
}

function unsettledWarning(line: TicketLine, ticket: { project_id: string; provider_id: string | null; date: string }): string {
  return (
    `No se encontró un weekly_balance para provider_id=${ticket.provider_id ?? 'null'}, ` +
    `project_id=${ticket.project_id}, fecha=${ticket.date}. El consumo de esta línea ` +
    `(total=${line.total}) no fue registrado en ningún saldo semanal.`
  )
}

async function settleWeeklyBalance(
  line: TicketLine,
  ticket: { project_id: string; provider_id: string | null; date: string },
): Promise<string | undefined> {
  if (!ticket.provider_id) {
    const warning = unsettledWarning(line, ticket)
    console.warn(`[ticket_line.service] ticket_line_id=${line.id} ${warning}`)
    return warning
  }

  const balance = await weeklyBalanceRepository.findMatchingWeeklyBalance(
    ticket.project_id,
    ticket.provider_id,
    ticket.date,
  )

  if (!balance) {
    const warning = unsettledWarning(line, ticket)
    console.warn(`[ticket_line.service] ticket_line_id=${line.id} ${warning}`)
    return warning
  }

  await weeklyBalanceRepository.incrementConsumed(balance.id, line.total)
  return undefined
}

export type ApproveTicketLineResult = {
  line: TicketLine
  warning?: string
}

export async function approveTicketLine(
  id: string,
  approvedBy: string,
): Promise<ApproveTicketLineResult | null> {
  const existing = await ticketLineRepository.findTicketLineWithTicket(id)
  if (!existing) return null
  if (existing.status !== 'pending') throw notPendingError(existing.status)

  const updated = await ticketLineRepository.updateTicketLineStatus(id, 'approved', approvedBy)
  if (!updated) return null

  await ticketService.recalculateTicketStatus(existing.ticket_id)
  const warning = await settleWeeklyBalance(updated, existing.ticket)

  return { line: updated, warning }
}

export type UnsettledTicketLine = {
  ticket_line: TicketLine
  ticket: { folio: string | null; date: string; provider_id: string | null; project_id: string }
  unconsolidated_total: number
}

export async function getUnsettledTicketLines(): Promise<UnsettledTicketLine[]> {
  const lines = await ticketLineRepository.findApprovedLines()

  const checked = await Promise.all(
    lines.map(async (l: TicketLineWithTicket) => {
      const balance = l.ticket.provider_id
        ? await weeklyBalanceRepository.findMatchingWeeklyBalance(
            l.ticket.project_id,
            l.ticket.provider_id,
            l.ticket.date,
          )
        : null
      return { line: l, settled: balance !== null }
    }),
  )

  return checked
    .filter((c) => !c.settled)
    .map((c) => ({
      ticket_line: c.line,
      ticket: {
        folio: c.line.ticket.folio,
        date: c.line.ticket.date,
        provider_id: c.line.ticket.provider_id,
        project_id: c.line.ticket.project_id,
      },
      unconsolidated_total: c.line.total,
    }))
}

export async function rejectTicketLine(id: string, approvedBy: string): Promise<TicketLine | null> {
  const existing = await ticketLineRepository.findTicketLineWithTicket(id)
  if (!existing) return null
  if (existing.status !== 'pending') throw notPendingError(existing.status)

  const updated = await ticketLineRepository.updateTicketLineStatus(id, 'rejected', approvedBy)
  if (!updated) return null

  await ticketService.recalculateTicketStatus(existing.ticket_id)

  return updated
}
