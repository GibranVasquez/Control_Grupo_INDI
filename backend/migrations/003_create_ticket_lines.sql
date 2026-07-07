-- Migration 003: Create ticket_lines table
-- Depends on: tickets (pre-existing), vehicles (pre-existing)

CREATE TABLE IF NOT EXISTS ticket_lines (
  id             UUID           PRIMARY KEY DEFAULT gen_random_uuid(),
  ticket_id      UUID           NOT NULL REFERENCES tickets(id) ON DELETE CASCADE,
  vehicle_id     UUID           NOT NULL REFERENCES vehicles(id) ON DELETE RESTRICT,
  liters         NUMERIC(10,3)  NOT NULL,
  cost_per_liter NUMERIC(10,4)  NOT NULL,
  total          NUMERIC(12,2)  NOT NULL,
  odometer       NUMERIC(10,1),
  activity       TEXT,
  created_at     TIMESTAMPTZ    NOT NULL DEFAULT now()
);
