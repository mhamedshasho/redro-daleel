CREATE TABLE IF NOT EXISTS admin_activity_events (
 id TEXT PRIMARY KEY,
 admin_session_id TEXT,
 event_type TEXT NOT NULL,
 entity_type TEXT,
 entity_id TEXT,
 details TEXT NOT NULL DEFAULT '{}',
 created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_admin_activity_created ON admin_activity_events(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_admin_activity_entity ON admin_activity_events(entity_type,entity_id,created_at DESC);
