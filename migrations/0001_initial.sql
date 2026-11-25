PRAGMA foreign_keys = ON;
CREATE TABLE IF NOT EXISTS categories (
  id INTEGER PRIMARY KEY,
  slug TEXT NOT NULL UNIQUE,
  name_ar TEXT NOT NULL,
  name_en TEXT,
  sort_order INTEGER NOT NULL DEFAULT 0,
  is_active INTEGER NOT NULL DEFAULT 1 CHECK (is_active IN (0,1)),
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS cities (
  id INTEGER PRIMARY KEY,
  slug TEXT NOT NULL UNIQUE,
  name_ar TEXT NOT NULL,
  name_en TEXT,
  is_active INTEGER NOT NULL DEFAULT 1 CHECK (is_active IN (0,1)),
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS regions (
  id INTEGER PRIMARY KEY,
  city_id INTEGER NOT NULL REFERENCES cities(id) ON DELETE RESTRICT,
  slug TEXT NOT NULL,
  name_ar TEXT NOT NULL,
  name_en TEXT,
  is_active INTEGER NOT NULL DEFAULT 1 CHECK (is_active IN (0,1)),
  UNIQUE(city_id,slug)
);
CREATE TABLE IF NOT EXISTS businesses (
  id TEXT PRIMARY KEY,
  slug TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  description TEXT NOT NULL,
  category_id INTEGER NOT NULL REFERENCES categories(id) ON DELETE RESTRICT,
  city_id INTEGER NOT NULL REFERENCES cities(id) ON DELETE RESTRICT,
  region_id INTEGER REFERENCES regions(id) ON DELETE SET NULL,
  address TEXT,
  phone TEXT,
  website TEXT,
  status TEXT NOT NULL DEFAULT 'pending' CHECK(status IN ('pending','published','suspended')),
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS business_images (
  id TEXT PRIMARY KEY,
  business_id TEXT NOT NULL REFERENCES businesses(id) ON DELETE CASCADE,
  object_key TEXT NOT NULL UNIQUE,
  content_type TEXT NOT NULL,
  size_bytes INTEGER NOT NULL CHECK(size_bytes > 0),
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS submissions (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT NOT NULL,
  city_text TEXT NOT NULL,
  category_text TEXT NOT NULL,
  phone TEXT,
  website TEXT,
  status TEXT NOT NULL CHECK(status IN ('approved','rejected','needs_review','pending_retry')),
  ai_score INTEGER,
  ai_reason TEXT,
  request_hash TEXT NOT NULL UNIQUE,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS reports (
  id TEXT PRIMARY KEY,
  business_id TEXT NOT NULL REFERENCES businesses(id) ON DELETE CASCADE,
  reason TEXT NOT NULL,
  details TEXT,
  status TEXT NOT NULL DEFAULT 'open' CHECK(status IN ('open','reviewing','resolved','dismissed')),
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS processing_logs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  submission_id TEXT REFERENCES submissions(id) ON DELETE SET NULL,
  event TEXT NOT NULL,
  details TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_businesses_status_created ON businesses(status,created_at DESC);
CREATE INDEX IF NOT EXISTS idx_businesses_city_category ON businesses(city_id,category_id,status);
CREATE INDEX IF NOT EXISTS idx_businesses_region ON businesses(region_id,status);
CREATE INDEX IF NOT EXISTS idx_submissions_status_created ON submissions(status,created_at);
CREATE INDEX IF NOT EXISTS idx_reports_status_created ON reports(status,created_at);
INSERT OR IGNORE INTO cities(slug,name_ar,name_en) VALUES ('aleppo','حلب','Aleppo');
INSERT OR IGNORE INTO categories(slug,name_ar,name_en,sort_order) VALUES
('restaurants-cafes','المطاعم والمقاهي','Restaurants & Cafes',1),
('shops','المتاجر والمحلات','Shops',2),
('fashion','الملابس والأزياء','Fashion',3),
('electronics','الإلكترونيات','Electronics',4),
('maintenance','الصيانة والتصليح','Maintenance',5),
('home-services','الخدمات المنزلية','Home Services',6),
('education','التعليم والتدريب','Education',7),
('health','الصحة والخدمات الطبية','Health',8),
('automotive','السيارات','Automotive',9),
('companies','الشركات والمكاتب','Companies',10),
('design-development','التصميم والبرمجة','Design & Development',11),
('other','خدمات أخرى','Other Services',12);
