ALTER TABLE admin_sessions ADD COLUMN last_used_at TEXT;
CREATE TABLE IF NOT EXISTS admin_security_events (
 id TEXT PRIMARY KEY,
 event_type TEXT NOT NULL,
 attempt_key TEXT,
 details TEXT NOT NULL DEFAULT '{}',
 created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_admin_security_created ON admin_security_events(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_admin_security_attempt ON admin_security_events(attempt_key,created_at DESC);
