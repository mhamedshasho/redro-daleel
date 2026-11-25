PRAGMA foreign_keys = ON;

INSERT INTO business_payments (id,business_id,status,created_at,updated_at)
SELECT lower(hex(randomblob(16))),b.id,'unpaid',COALESCE(b.created_at,CURRENT_TIMESTAMP),CURRENT_TIMESTAMP
FROM businesses b
WHERE NOT EXISTS (
  SELECT 1 FROM business_payments p WHERE p.business_id=b.id
);
