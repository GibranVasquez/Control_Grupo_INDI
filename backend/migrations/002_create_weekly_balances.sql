-- Migration 002: Create weekly_balances table
-- Depends on: fuel_providers (001), projects (pre-existing)

CREATE TABLE IF NOT EXISTS weekly_balances (
  id             UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  provider_id    UUID        NOT NULL REFERENCES fuel_providers(id) ON DELETE RESTRICT,
  project_id     UUID        NOT NULL REFERENCES projects(id)       ON DELETE RESTRICT,
  week_number    INTEGER     NOT NULL,
  period_start   DATE        NOT NULL,
  period_end     DATE        NOT NULL,
  requested      NUMERIC(12,2) NOT NULL DEFAULT 0,
  deposited      NUMERIC(12,2) NOT NULL DEFAULT 0,
  consumed       NUMERIC(12,2) NOT NULL DEFAULT 0,
  balance_favor  NUMERIC(12,2) NOT NULL DEFAULT 0,
  invoice_folio  TEXT,
  status         TEXT        NOT NULL DEFAULT 'requested'
                   CHECK (status IN ('requested', 'paid')),
  comments       TEXT,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);
