-- Migration 005: Create supply_requests and supply_request_items tables
-- Independent of tickets/ticket_lines — does not modify existing tables.

CREATE TABLE supply_requests (
  id           UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  type         TEXT        NOT NULL CHECK (type IN ('fuel', 'material')),
  project_id   UUID        NOT NULL REFERENCES projects(id)  ON DELETE RESTRICT,
  requested_by UUID        NOT NULL REFERENCES users(id)     ON DELETE RESTRICT,
  needed_by    DATE        NOT NULL,
  status       TEXT        NOT NULL DEFAULT 'pending'
                 CHECK (status IN ('pending','approved','rejected','fulfilled')),
  approved_by  UUID        REFERENCES users(id)              ON DELETE RESTRICT,
  approved_at  TIMESTAMPTZ,
  comments     TEXT,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE supply_request_items (
  id          UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  request_id  UUID          NOT NULL REFERENCES supply_requests(id) ON DELETE CASCADE,
  vehicle_id  UUID          REFERENCES vehicles(id)                 ON DELETE RESTRICT,
  item_name   TEXT          NOT NULL,
  quantity    NUMERIC(10,2) NOT NULL,
  unit        TEXT          NOT NULL,
  created_at  TIMESTAMPTZ   NOT NULL DEFAULT now()
);
