-- 06: Safe query patterns / Bezbedni obrasci upita
-- Application drivers should bind real values; this CTE simulates a bound value / Drajver aplikacije binduje vrednost; CTE je simulacija.

WITH input_email(email) AS (
  VALUES ('ana@example.com')
)
SELECT c.customer_id, c.full_name, c.email
FROM customers AS c
JOIN input_email AS i ON i.email = c.email;

-- Use an allow-list for dynamic sorting / Za dinamičko sortiranje koristi dozvoljenu listu.
WITH requested_sort(sort_key) AS (
  VALUES ('date')
)
SELECT order_id, ordered_at, status
FROM orders
CROSS JOIN requested_sort
ORDER BY CASE WHEN sort_key = 'date' THEN ordered_at END DESC,
         CASE WHEN sort_key = 'status' THEN status END ASC,
         order_id ASC;

DROP VIEW IF EXISTS v_customer_directory;
CREATE VIEW v_customer_directory AS
SELECT customer_id,
       full_name,
       substr(email, 1, 2) || '***' AS masked_email,
       city
FROM customers;

SELECT *
FROM v_customer_directory
ORDER BY customer_id;
