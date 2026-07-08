-- Migration 006: Line-level approval for ticket_lines
-- Depends on: ticket_lines (003), users (pre-existing), weekly_balances (002)

ALTER TABLE ticket_lines
  ADD COLUMN status TEXT NOT NULL DEFAULT 'pending'
    CHECK (status IN ('pending','approved','rejected')),
  ADD COLUMN approved_by UUID REFERENCES users(id) ON DELETE RESTRICT,
  ADD COLUMN approved_at TIMESTAMPTZ;

-- Backfill: las líneas de tickets que ya estaban approved/rejected bajo el
-- flujo viejo heredan ese estado (si no, el ADD COLUMN las deja en 'pending'
-- y la regla derivada regresaría esos tickets a 'pending').
UPDATE ticket_lines tl
SET status = t.status,
    approved_at = now()
FROM tickets t
WHERE tl.ticket_id = t.id
  AND t.status IN ('approved', 'rejected');

-- Suma atómica a consumed + recálculo de balance_favor en una sola sentencia,
-- para que dos aprobaciones concurrentes sobre el mismo weekly_balance no se pisen.
CREATE OR REPLACE FUNCTION increment_weekly_balance_consumed(
  p_id UUID,
  p_amount NUMERIC
) RETURNS weekly_balances
LANGUAGE sql
AS $$
  UPDATE weekly_balances
  SET consumed = consumed + p_amount,
      balance_favor = deposited - (consumed + p_amount)
  WHERE id = p_id
  RETURNING *;
$$;
