CREATE TABLE IF NOT EXISTS business_owners (
 business_id TEXT PRIMARY KEY REFERENCES businesses(id) ON DELETE CASCADE,
 token_hash TEXT NOT NULL UNIQUE,
 created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE submissions ADD COLUMN owner_token_hash TEXT;
CREATE INDEX IF NOT EXISTS idx_business_owners_token_hash ON business_owners(token_hash);
