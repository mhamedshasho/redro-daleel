ALTER TABLE submissions ADD COLUMN business_id TEXT REFERENCES businesses(id) ON DELETE SET NULL;
CREATE INDEX IF NOT EXISTS idx_submissions_business_id ON submissions(business_id);
