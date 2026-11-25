PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS ownership_transfer_events (
  id TEXT PRIMARY KEY,
  transfer_id TEXT NOT NULL REFERENCES ownership_transfers(id) ON DELETE CASCADE,
  business_id TEXT NOT NULL REFERENCES businesses(id) ON DELETE CASCADE,
  actor_account_id TEXT REFERENCES owner_accounts(id) ON DELETE SET NULL,
  event_type TEXT NOT NULL CHECK (event_type IN ('requested','accepted','rejected','cancelled','expired','ownership_changed')),
  details TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_transfer_events_transfer_created
ON ownership_transfer_events(transfer_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_transfer_events_business_created
ON ownership_transfer_events(business_id, created_at DESC);
