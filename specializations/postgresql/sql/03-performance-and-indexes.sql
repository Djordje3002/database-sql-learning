-- Measure first, then index / Prvo izmeri, pa dodaj indeks. Run after 00 / Pokreni posle 00.

EXPLAIN (ANALYZE, BUFFERS)
SELECT o.order_id, o.purchased_at,
       SUM(ol.quantity * ol.unit_price_cents) AS total_cents
FROM academy.orders AS o
JOIN academy.order_lines AS ol ON ol.order_id = o.order_id
WHERE o.customer_id = 2
  AND o.status IN ('paid', 'shipped')
  AND o.purchased_at >= timestamptz '2026-01-01 00:00:00+00'
GROUP BY o.order_id, o.purchased_at
ORDER BY o.purchased_at DESC;

-- Equality column first; partial predicate matches the query; INCLUDE supports index-only reads / Jednakost prva; parcijalni predikat odgovara upitu; INCLUDE je pokrivni indeks.
CREATE INDEX orders_finalized_customer_date_idx
ON academy.orders (customer_id, purchased_at DESC)
INCLUDE (order_id)
WHERE status IN ('paid', 'shipped');

EXPLAIN (ANALYZE, BUFFERS)
SELECT o.order_id, o.purchased_at
FROM academy.orders AS o
WHERE o.customer_id = 2
  AND o.status IN ('paid', 'shipped')
  AND o.purchased_at >= timestamptz '2026-01-01 00:00:00+00'
ORDER BY o.purchased_at DESC;

-- A tiny table can correctly use a sequential scan / Sekvencijalni scan je ispravan za malu tabelu.
