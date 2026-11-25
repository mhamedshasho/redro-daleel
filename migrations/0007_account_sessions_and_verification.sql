PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS owner_sessions (
  id TEXT PRIMARY KEY,
  owner_account_id TEXT NOT NULL REFERENCES owner_accounts(id) ON DELETE CASCADE,
  token_hash TEXT NOT NULL UNIQUE,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  expires_at TEXT NOT NULL,
  last_used_at TEXT,
  revoked_at TEXT
);

CREATE INDEX IF NOT EXISTS idx_owner_sessions_account
ON owner_sessions(owner_account_id, expires_at);

CREATE INDEX IF NOT EXISTS idx_owner_sessions_expiry
ON owner_sessions(expires_at);

CREATE TABLE IF NOT EXISTS owner_verification_challenges (
  id TEXT PRIMARY KEY,
  owner_account_id TEXT NOT NULL REFERENCES owner_accounts(id) ON DELETE CASCADE,
  channel TEXT NOT NULL CHECK (channel IN ('email','phone')),
  purpose TEXT NOT NULL CHECK (purpose IN ('verify_identifier','password_reset','transfer_acceptance')),
  destination_hash TEXT NOT NULL,
  code_hash TEXT NOT NULL,
  attempts INTEGER NOT NULL DEFAULT 0 CHECK (attempts BETWEEN 0 AND 10),
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  expires_at TEXT NOT NULL,
  consumed_at TEXT
);

CREATE INDEX IF NOT EXISTS idx_owner_challenges_account
ON owner_verification_challenges(owner_account_id, purpose, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_owner_challenges_expiry
ON owner_verification_challenges(expires_at);
