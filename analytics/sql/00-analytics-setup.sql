-- Analytics track setup / Priprema analitičke staze (SQLite 3). Destructive only for analytics tables / Briše samo analytics tabele.

DROP TABLE IF EXISTS fact_orders;
DROP TABLE IF EXISTS dim_customers;
DROP TABLE IF EXISTS dim_products;
DROP TABLE IF EXISTS staging_events;

CREATE TABLE dim_customers (
  customer_id INTEGER PRIMARY KEY,
  full_name TEXT NOT NULL,
  acquisition_month TEXT NOT NULL,
  acquisition_channel TEXT NOT NULL
);

CREATE TABLE dim_products (
  product_id INTEGER PRIMARY KEY,
  product_name TEXT NOT NULL,
  category TEXT NOT NULL
);

-- Grain: one order with recognized historical revenue / Zrno: jedna narudžbina sa istorijskim prihodom.
CREATE TABLE fact_orders (
  order_id INTEGER PRIMARY KEY,
  customer_id INTEGER NOT NULL REFERENCES dim_customers(customer_id),
  product_id INTEGER NOT NULL REFERENCES dim_products(product_id),
  ordered_at TEXT NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('new', 'paid', 'shipped', 'cancelled')),
  revenue_cents INTEGER NOT NULL CHECK (revenue_cents >= 0)
);

CREATE TABLE staging_events (
  event_id INTEGER,
  session_id TEXT,
  event_type TEXT,
  occurred_at TEXT
);

INSERT INTO dim_customers VALUES
  (1, 'Ana Anić', '2026-01', 'organic'),
  (2, 'Marko Marković', '2026-01', 'paid_search'),
  (3, 'Jelena Jovanović', '2026-02', 'organic'),
  (4, 'Sara Savić', '2026-02', 'referral'),
  (5, 'Luka Lukić', '2026-03', 'paid_search');

INSERT INTO dim_products VALUES
  (1, 'SQL Foundations', 'technical'),
  (2, 'Database Design', 'technical'),
  (3, '1984', 'fiction');

INSERT INTO fact_orders VALUES
  (1001, 1, 1, '2026-01-10', 'paid', 1000),
  (1002, 2, 2, '2026-01-15', 'shipped', 2000),
  (1003, 1, 3, '2026-02-03', 'shipped', 1500),
  (1004, 3, 1, '2026-02-18', 'paid', 900),
  (1005, 2, 2, '2026-03-01', 'paid', 1500),
  (1006, 3, 3, '2026-03-05', 'cancelled', 900),
  (1007, 4, 1, '2026-03-20', 'shipped', 2200),
  (1008, 1, 2, '2026-04-12', 'paid', 1200),
  (1009, 5, 3, '2026-04-25', 'new', 1000),
  (1010, 2, 1, '2026-05-07', 'paid', 1700),
  (1011, 4, 2, '2026-05-21', 'shipped', 1800),
  (1012, 5, 3, '2026-06-11', 'paid', 1400);

INSERT INTO staging_events VALUES
  (1, 's-1', 'visit', '2026-01-10 09:00:00'),
  (1, 's-1', 'visit', '2026-01-10 09:00:00'),
  (2, NULL, 'search', '2026-01-10 09:01:00'),
  (3, 's-2', NULL, '2026-01-10 10:00:00');
