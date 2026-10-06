-- Project 02: non-destructive control queries.
-- Prerequisites: base setup and this project's seed.sql.

-- Expected population after the seed.
SELECT
  (SELECT COUNT(*) FROM kupci) AS expected_customer_count,
  (SELECT COUNT(*) FROM narudzbine) AS expected_order_count,
  (SELECT COUNT(*) FROM stavke_narudzbine) AS expected_order_line_count;

-- Correct recognized revenue is 25876.0. Current catalog prices are not used.
SELECT
  SUM(sn.kolicina * sn.cena_u_trenutku) AS expected_recognized_revenue
FROM narudzbine AS n
JOIN stavke_narudzbine AS sn ON sn.id_narudzbine = n.id
WHERE n.status IN ('placena', 'poslata');

-- Correct March revenue is 6093.0. This query is order-line safe for revenue,
-- but do not use COUNT(n.id) here as an order count without DISTINCT or pre-aggregation.
SELECT
  substr(n.datum, 1, 7) AS order_month,
  SUM(sn.kolicina * sn.cena_u_trenutku) AS expected_recognized_revenue
FROM narudzbine AS n
JOIN stavke_narudzbine AS sn ON sn.id_narudzbine = n.id
WHERE n.status IN ('placena', 'poslata')
GROUP BY substr(n.datum, 1, 7)
ORDER BY order_month;

-- The customer report must retain this zero-revenue customer.
SELECT
  ku.id AS expected_zero_revenue_customer_id,
  ku.ime AS expected_zero_revenue_customer
FROM kupci AS ku
LEFT JOIN narudzbine AS n
  ON n.id_kupca = ku.id
 AND n.status IN ('placena', 'poslata')
WHERE ku.ime = 'Sara Savić'
GROUP BY ku.id, ku.ime
HAVING COUNT(n.id) = 0;

-- Order-level control values: one row per order, before monthly aggregation.
SELECT
  n.id AS order_id,
  n.datum AS order_date,
  n.status AS order_status,
  SUM(sn.kolicina * sn.cena_u_trenutku) AS order_value
FROM narudzbine AS n
JOIN stavke_narudzbine AS sn ON sn.id_narudzbine = n.id
GROUP BY n.id, n.datum, n.status
ORDER BY n.datum, n.id;
