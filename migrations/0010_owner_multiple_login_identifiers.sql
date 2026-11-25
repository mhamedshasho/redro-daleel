PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS owner_account_identifiers (
  id TEXT PRIMARY KEY,
  owner_account_id TEXT NOT NULL REFERENCES owner_accounts(id) ON DELETE CASCADE,
  channel TEXT NOT NULL CHECK (channel IN ('email','phone')),
  identifier TEXT NOT NULL COLLATE NOCASE,
  is_primary INTEGER NOT NULL DEFAULT 0 CHECK (is_primary IN (0,1)),
  verified_at TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(channel, identifier)
);

CREATE INDEX IF NOT EXISTS idx_owner_identifiers_account
ON owner_account_identifiers(owner_account_id, channel);

CREATE UNIQUE INDEX IF NOT EXISTS idx_owner_identifiers_one_primary
ON owner_account_identifiers(owner_account_id) WHERE is_primary = 1;

INSERT INTO owner_account_identifiers
  (id, owner_account_id, channel, identifier, is_primary, verified_at)
SELECT lower(hex(randomblob(16))), id, login_method, login_identifier, 1, verified_at
FROM owner_accounts
WHERE NOT EXISTS (
  SELECT 1 FROM owner_account_identifiers i
  WHERE i.owner_account_id = owner_accounts.id
);
