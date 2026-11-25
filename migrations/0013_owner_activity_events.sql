CREATE TABLE IF NOT EXISTS owner_activity_events (
  id TEXT PRIMARY KEY,
  owner_account_id TEXT NOT NULL,
  business_id TEXT,
  event_type TEXT NOT NULL,
  details TEXT NOT NULL DEFAULT '{}',
  created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_owner_activity_owner_created ON owner_activity_events(owner_account_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_owner_activity_business_created ON owner_activity_events(business_id, created_at DESC);
