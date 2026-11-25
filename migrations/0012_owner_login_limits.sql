CREATE TABLE IF NOT EXISTS owner_login_attempts (
  id TEXT PRIMARY KEY,
  attempt_key TEXT NOT NULL UNIQUE,
  attempts INTEGER NOT NULL DEFAULT 0 CHECK (attempts BETWEEN 0 AND 20),
  window_started_at TEXT NOT NULL,
  locked_until TEXT,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_owner_login_attempts_lock ON owner_login_attempts(locked_until);
