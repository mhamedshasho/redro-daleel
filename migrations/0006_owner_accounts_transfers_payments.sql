PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS owner_accounts (
  id TEXT PRIMARY KEY,
  login_method TEXT NOT NULL CHECK (login_method IN ('email','phone')),
  login_identifier TEXT NOT NULL COLLATE NOCASE UNIQUE,
  password_hash TEXT NOT NULL,
  verified_at TEXT,
  status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active','locked','disabled')),
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS business_account_ownership (
  business_id TEXT PRIMARY KEY REFERENCES businesses(id) ON DELETE CASCADE,
  owner_account_id TEXT NOT NULL UNIQUE REFERENCES owner_accounts(id) ON DELETE RESTRICT,
  linked_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS ownership_transfers (
  id TEXT PRIMARY KEY,
  business_id TEXT NOT NULL REFERENCES businesses(id) ON DELETE CASCADE,
  from_account_id TEXT NOT NULL REFERENCES owner_accounts(id) ON DELETE RESTRICT,
  to_account_id TEXT NOT NULL REFERENCES owner_accounts(id) ON DELETE RESTRICT,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','accepted','rejected','cancelled','expired')),
  requested_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  responded_at TEXT,
  CHECK (from_account_id <> to_account_id)
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_one_pending_transfer_per_business
ON ownership_transfers(business_id) WHERE status = 'pending';

CREATE INDEX IF NOT EXISTS idx_transfers_target_status
ON ownership_transfers(to_account_id, status, requested_at DESC);

CREATE TABLE IF NOT EXISTS business_payments (
  id TEXT PRIMARY KEY,
  business_id TEXT NOT NULL UNIQUE REFERENCES businesses(id) ON DELETE CASCADE,
  amount_minor INTEGER CHECK (amount_minor IS NULL OR amount_minor >= 0),
  currency TEXT,
  status TEXT NOT NULL DEFAULT 'unpaid' CHECK (status IN ('unpaid','awaiting_confirmation','paid','refunded')),
  payment_method TEXT,
  provider_reference TEXT,
  paid_at TEXT,
  refunded_at TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_business_payments_status
ON business_payments(status, updated_at DESC);
