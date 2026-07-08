-- Migration 001: Create fuel_providers table
-- Run in Supabase SQL Editor

CREATE TABLE IF NOT EXISTS fuel_providers (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  name        TEXT        NOT NULL,
  bank        TEXT,
  account     TEXT,
  clabe       TEXT,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);
