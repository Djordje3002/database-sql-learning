-- 04: Normalization / Normalizacija: one fact, one owner / jedna činjenica, jedan vlasnik

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS subscriptions;
DROP TABLE IF EXISTS plans;
DROP TABLE IF EXISTS staging_subscription_import;

-- A deliberately poor import shape / Namerno loš oblik uvoza.
CREATE TABLE staging_subscription_import (
  customer_email TEXT,
  customer_city TEXT,
  plan_name TEXT,
  monthly_price_cents INTEGER
);

INSERT INTO staging_subscription_import VALUES
  ('ana@example.com', 'Beograd', 'Reader', 999),
  ('marko@example.com', 'Novi Sad', 'Reader', 999),
  ('jelena@example.com', 'Niš', 'Professional', 1999);

CREATE TABLE plans (
  plan_id INTEGER PRIMARY KEY,
  plan_name TEXT NOT NULL UNIQUE,
  monthly_price_cents INTEGER NOT NULL CHECK (monthly_price_cents >= 0)
);

CREATE TABLE subscriptions (
  subscription_id INTEGER PRIMARY KEY,
  customer_id INTEGER NOT NULL,
  plan_id INTEGER NOT NULL,
  started_at TEXT NOT NULL,
  UNIQUE (customer_id, plan_id),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  FOREIGN KEY (plan_id) REFERENCES plans(plan_id)
);

INSERT INTO plans (plan_id, plan_name, monthly_price_cents) VALUES
  (1, 'Reader', 999),
  (2, 'Professional', 1999);

INSERT INTO subscriptions (subscription_id, customer_id, plan_id, started_at) VALUES
  (1, 1, 1, '2026-01-01'),
  (2, 2, 1, '2026-02-01'),
  (3, 3, 2, '2026-03-01');

SELECT c.full_name, p.plan_name, p.monthly_price_cents, s.started_at
FROM subscriptions AS s
JOIN customers AS c ON c.customer_id = s.customer_id
JOIN plans AS p ON p.plan_id = s.plan_id
ORDER BY s.subscription_id;
