-- Composite indexes and plan evidence / Složeni indeksi i dokaz iz plana. Run after 00 / Posle 00.

EXPLAIN ANALYZE
SELECT order_id, ordered_at, status
FROM learning_orders
WHERE customer_id = 2
  AND status IN ('paid', 'shipped')
  AND ordered_at >= '2026-01-01'
ORDER BY ordered_at DESC;

-- MySQL has no native partial index. A generated flag can support a selective composite index / Nema ugrađenog parcijalnog indeksa.
ALTER TABLE learning_orders
  ADD COLUMN is_finalized TINYINT GENERATED ALWAYS AS (status IN ('paid', 'shipped')) STORED,
  ADD INDEX learning_orders_finalized_customer_date_idx (is_finalized, customer_id, ordered_at DESC);

EXPLAIN ANALYZE
SELECT order_id, ordered_at, status
FROM learning_orders
WHERE is_finalized = 1
  AND customer_id = 2
  AND ordered_at >= '2026-01-01'
ORDER BY ordered_at DESC;

-- Measure write cost too; a generated column and index are not free / Izmeri i cenu pisanja; kolona i indeks nisu besplatni.
