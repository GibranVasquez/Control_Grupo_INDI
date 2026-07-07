-- Migration 004: Alter tickets — add columns, migrate data, drop old columns
-- Depends on: fuel_providers (001), ticket_lines (003)
-- Run AFTER migrations 001, 002, 003 are applied.

-- Step 1: Add new columns
ALTER TABLE tickets
  ADD COLUMN IF NOT EXISTS provider_id UUID REFERENCES fuel_providers(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS folio       TEXT;

-- Step 2: Unique index on folio — only enforces uniqueness when folio IS NOT NULL
CREATE UNIQUE INDEX IF NOT EXISTS tickets_folio_unique
  ON tickets(folio)
  WHERE folio IS NOT NULL;

-- Step 3: Migrate existing rows to ticket_lines
-- Each existing ticket becomes one ticket_line preserving vehicle_id, liters,
-- cost_per_liter and total. Rows that have NULL in any of those fields are skipped.
INSERT INTO ticket_lines (ticket_id, vehicle_id, liters, cost_per_liter, total)
SELECT id, vehicle_id, liters, cost_per_liter, total
FROM   tickets
WHERE  vehicle_id     IS NOT NULL
  AND  liters         IS NOT NULL
  AND  cost_per_liter IS NOT NULL
  AND  total          IS NOT NULL;

-- Step 4: Drop old columns (now redundant — data lives in ticket_lines)
ALTER TABLE tickets
  DROP COLUMN IF EXISTS vehicle_id,
  DROP COLUMN IF EXISTS liters,
  DROP COLUMN IF EXISTS cost_per_liter,
  DROP COLUMN IF EXISTS total;
