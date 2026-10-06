-- 03: Indexes and query plans / Indeksi i planovi upita

DROP INDEX IF EXISTS idx_orders_customer_date;

EXPLAIN QUERY PLAN
SELECT order_id, ordered_at, status
FROM orders
WHERE customer_id = 2
  AND ordered_at >= '2026-01-01'
ORDER BY ordered_at DESC;

CREATE INDEX idx_orders_customer_date
ON orders (customer_id, ordered_at DESC);

EXPLAIN QUERY PLAN
SELECT order_id, ordered_at, status
FROM orders
WHERE customer_id = 2
  AND ordered_at >= '2026-01-01'
ORDER BY ordered_at DESC;

SELECT order_id, ordered_at, status
FROM orders
WHERE customer_id = 2
  AND ordered_at >= '2026-01-01'
ORDER BY ordered_at DESC;
