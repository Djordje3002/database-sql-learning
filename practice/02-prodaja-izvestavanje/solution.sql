-- Project 02: Bookstore Sales Reporting — reference solution for SQLite
-- Prerequisites:
--   1) sql/00-priprema-baze.sql
--   2) practice/02-prodaja-izvestavanje/seed.sql

-- Task 1: order-line fact view. Its grain is exactly one order line.
DROP VIEW IF EXISTS vw_praksa_prodaja_redovi;

CREATE VIEW vw_praksa_prodaja_redovi AS
SELECT
  n.id AS order_id,
  n.datum AS order_date,
  n.status AS order_status,
  ku.id AS customer_id,
  ku.ime AS customer_name,
  ku.grad AS customer_city,
  k.id_knjige AS book_id,
  k.naziv AS book_title,
  sn.kolicina AS quantity,
  sn.cena_u_trenutku AS historical_unit_price,
  sn.kolicina * sn.cena_u_trenutku AS line_total
FROM narudzbine AS n
JOIN kupci AS ku ON ku.id = n.id_kupca
JOIN stavke_narudzbine AS sn ON sn.id_narudzbine = n.id
JOIN knjige AS k ON k.id_knjige = sn.id_knjige;

SELECT *
FROM vw_praksa_prodaja_redovi
ORDER BY order_id, book_id;

-- Reusable order-level measure. One row now represents one order, which is the
-- correct grain for counting orders and calculating order-average metrics.
WITH finalized_order_totals AS (
  SELECT
    p.order_id,
    p.order_date,
    p.customer_id,
    SUM(p.line_total) AS order_revenue
  FROM vw_praksa_prodaja_redovi AS p
  WHERE p.order_status IN ('placena', 'poslata')
  GROUP BY p.order_id, p.order_date, p.customer_id
)
SELECT
  substr(order_date, 1, 7) AS order_month,
  COUNT(*) AS finalized_order_count,
  SUM(order_revenue) AS recognized_revenue
FROM finalized_order_totals
GROUP BY substr(order_date, 1, 7)
ORDER BY order_month;

-- Task 3: revenue by city. The customer table stays on the left so that a city
-- with only zero-revenue customers remains in the output.
WITH finalized_order_totals AS (
  SELECT
    p.order_id,
    p.customer_id,
    SUM(p.line_total) AS order_revenue
  FROM vw_praksa_prodaja_redovi AS p
  WHERE p.order_status IN ('placena', 'poslata')
  GROUP BY p.order_id, p.customer_id
),
customer_revenue AS (
  SELECT
    customer_id,
    SUM(order_revenue) AS recognized_revenue
  FROM finalized_order_totals
  GROUP BY customer_id
)
SELECT
  ku.grad AS customer_city,
  COUNT(ku.id) AS customer_count,
  COALESCE(SUM(cr.recognized_revenue), 0) AS recognized_revenue
FROM kupci AS ku
LEFT JOIN customer_revenue AS cr ON cr.customer_id = ku.id
GROUP BY ku.grad
ORDER BY recognized_revenue DESC, customer_city;

-- Task 4: all-book sales first; the final LIMIT chooses the top three without
-- losing the correctness of the reusable full report.
WITH book_sales AS (
  SELECT
    p.book_id,
    SUM(CASE WHEN p.order_status IN ('placena', 'poslata') THEN p.quantity ELSE 0 END) AS units_sold,
    SUM(CASE WHEN p.order_status IN ('placena', 'poslata') THEN p.line_total ELSE 0 END) AS recognized_revenue
  FROM vw_praksa_prodaja_redovi AS p
  GROUP BY p.book_id
),
all_books AS (
  SELECT
    k.id_knjige AS book_id,
    k.naziv AS book_title,
    COALESCE(bs.units_sold, 0) AS units_sold,
    COALESCE(bs.recognized_revenue, 0) AS recognized_revenue
  FROM knjige AS k
  LEFT JOIN book_sales AS bs ON bs.book_id = k.id_knjige
)
SELECT
  book_id,
  book_title,
  units_sold,
  recognized_revenue
FROM all_books
ORDER BY recognized_revenue DESC, units_sold DESC, book_title
LIMIT 3;

-- Task 5: customer revenue and dense ranking. The outer SELECT makes it clear
-- that the window operates on customer-level rows, not line-level rows.
WITH finalized_order_totals AS (
  SELECT
    p.order_id,
    p.customer_id,
    SUM(p.line_total) AS order_revenue
  FROM vw_praksa_prodaja_redovi AS p
  WHERE p.order_status IN ('placena', 'poslata')
  GROUP BY p.order_id, p.customer_id
),
customer_revenue AS (
  SELECT
    customer_id,
    SUM(order_revenue) AS recognized_revenue
  FROM finalized_order_totals
  GROUP BY customer_id
),
customers_with_revenue AS (
  SELECT
    ku.id AS customer_id,
    ku.ime AS customer_name,
    ku.grad AS customer_city,
    COALESCE(cr.recognized_revenue, 0) AS recognized_revenue
  FROM kupci AS ku
  LEFT JOIN customer_revenue AS cr ON cr.customer_id = ku.id
)
SELECT
  customer_id,
  customer_name,
  customer_city,
  recognized_revenue,
  DENSE_RANK() OVER (ORDER BY recognized_revenue DESC) AS revenue_rank
FROM customers_with_revenue
ORDER BY revenue_rank, customer_name;

-- Task 6: monthly cancellation rate. Multiplying by 100.0 forces a decimal
-- result in SQLite, and NULLIF protects a future empty denominator.
WITH monthly_orders AS (
  SELECT
    substr(datum, 1, 7) AS order_month,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN status = 'otkazana' THEN 1 ELSE 0 END) AS cancelled_orders
  FROM narudzbine
  GROUP BY substr(datum, 1, 7)
)
SELECT
  order_month,
  total_orders,
  cancelled_orders,
  ROUND(100.0 * cancelled_orders / NULLIF(total_orders, 0), 2) AS cancellation_rate_pct
FROM monthly_orders
ORDER BY order_month;

-- Task 7: owner dashboard. The first CTE makes one row per order; the second
-- calculates a monthly metric layer; the final query adds a running total.
WITH order_totals AS (
  SELECT
    n.id AS order_id,
    n.datum AS order_date,
    n.status AS order_status,
    SUM(sn.kolicina * sn.cena_u_trenutku) AS order_value
  FROM narudzbine AS n
  JOIN stavke_narudzbine AS sn ON sn.id_narudzbine = n.id
  GROUP BY n.id, n.datum, n.status
),
monthly_metrics AS (
  SELECT
    substr(order_date, 1, 7) AS order_month,
    COUNT(*) AS total_order_count,
    SUM(CASE WHEN order_status IN ('placena', 'poslata') THEN 1 ELSE 0 END) AS finalized_order_count,
    SUM(CASE WHEN order_status IN ('placena', 'poslata') THEN order_value ELSE 0 END) AS recognized_revenue,
    AVG(CASE WHEN order_status IN ('placena', 'poslata') THEN order_value END) AS avg_finalized_order_value
  FROM order_totals
  GROUP BY substr(order_date, 1, 7)
)
SELECT
  order_month,
  total_order_count,
  finalized_order_count,
  recognized_revenue,
  ROUND(avg_finalized_order_value, 2) AS avg_finalized_order_value,
  SUM(recognized_revenue) OVER (ORDER BY order_month) AS cumulative_revenue
FROM monthly_metrics
ORDER BY order_month;

-- Task 8: customer acquisition by first finalized purchase month.
WITH first_finalized_purchase AS (
  SELECT
    n.id_kupca AS customer_id,
    MIN(n.datum) AS first_finalized_order_date
  FROM narudzbine AS n
  WHERE n.status IN ('placena', 'poslata')
  GROUP BY n.id_kupca
)
SELECT
  substr(ffp.first_finalized_order_date, 1, 7) AS acquisition_month,
  ku.id AS customer_id,
  ku.ime AS customer_name,
  ffp.first_finalized_order_date
FROM first_finalized_purchase AS ffp
JOIN kupci AS ku ON ku.id = ffp.customer_id
ORDER BY acquisition_month, customer_name;

-- Task 9: historical and current prices can differ legitimately, but the report
-- makes those differences reviewable.
SELECT
  n.id AS order_id,
  n.datum AS order_date,
  n.status AS order_status,
  k.naziv AS book_title,
  sn.cena_u_trenutku AS historical_unit_price,
  k.cena AS current_catalog_price,
  sn.cena_u_trenutku - k.cena AS price_difference
FROM stavke_narudzbine AS sn
JOIN narudzbine AS n ON n.id = sn.id_narudzbine
JOIN knjige AS k ON k.id_knjige = sn.id_knjige
WHERE sn.cena_u_trenutku <> k.cena
ORDER BY n.datum, n.id, k.naziv;
