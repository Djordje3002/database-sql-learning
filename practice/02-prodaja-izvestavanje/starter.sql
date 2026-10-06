-- Project 02: Bookstore Sales Reporting
-- Prerequisites:
--   1) sql/00-priprema-baze.sql
--   2) practice/02-prodaja-izvestavanje/seed.sql
--
-- The starting statements are valid but intentionally incomplete. Extend them
-- rather than treating their current result as the requested report.

-- Task 1: one row per order line in a reusable view.
-- TODO: join order, customer, and book details; calculate line_total.
SELECT
  sn.id_narudzbine AS order_id,
  sn.id_knjige AS book_id,
  sn.kolicina AS quantity,
  sn.cena_u_trenutku AS unit_price
FROM stavke_narudzbine AS sn
ORDER BY sn.id_narudzbine, sn.id_knjige;

-- Task 2: monthly recognized revenue and finalized-order count.
-- TODO: calculate one total per order before grouping by substr(order_date, 1, 7).
SELECT
  substr(n.datum, 1, 7) AS order_month,
  n.id AS order_id,
  n.status
FROM narudzbine AS n
ORDER BY order_month, order_id;

-- Task 3: revenue by customer city, including zero-revenue customers/cities.
-- TODO: decide which table must be the preserved left side of the join.
SELECT
  ku.grad AS customer_city,
  COUNT(ku.id) AS customer_count
FROM kupci AS ku
GROUP BY ku.grad
ORDER BY ku.grad;

-- Task 4: book revenue and units sold; then return the top three.
-- TODO: use historical line prices and preserve unsold books in the full report.
SELECT
  k.id_knjige AS book_id,
  k.naziv AS book_title
FROM knjige AS k
ORDER BY k.naziv;

-- Task 5: customer revenue with DENSE_RANK().
-- TODO: first derive recognized revenue per customer, then apply the window function.
SELECT
  ku.id AS customer_id,
  ku.ime AS customer_name
FROM kupci AS ku
ORDER BY ku.ime;

-- Task 6: monthly cancellation rate.
-- TODO: denominator = every order in the month; numerator = only otkazana orders.
SELECT
  substr(n.datum, 1, 7) AS order_month,
  n.status
FROM narudzbine AS n
ORDER BY order_month, n.id;

-- Task 7: owner dashboard with at least two CTEs and a running revenue total.
-- TODO: include total orders, finalized orders, revenue, average finalized order value,
-- and SUM(revenue) OVER (ORDER BY order_month).

-- Task 8 (stretch): first finalized purchase month per customer.
-- Task 9 (stretch): historical unit price versus current catalog price.
