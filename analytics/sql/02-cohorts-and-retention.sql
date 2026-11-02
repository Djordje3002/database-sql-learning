-- Cohorts and retention / Kohorte i retencija. Run after 00 / Posle 00.

WITH finalized_orders AS (
  SELECT customer_id,
         substr(ordered_at, 1, 7) AS order_month
  FROM fact_orders
  WHERE status IN ('paid', 'shipped')
  GROUP BY customer_id, substr(ordered_at, 1, 7)
), first_purchase AS (
  SELECT customer_id,
         MIN(order_month) AS cohort_month
  FROM finalized_orders
  GROUP BY customer_id
), cohort_activity AS (
  SELECT fp.cohort_month,
         fo.order_month,
         ((CAST(substr(fo.order_month, 1, 4) AS INTEGER) - CAST(substr(fp.cohort_month, 1, 4) AS INTEGER)) * 12)
           + CAST(substr(fo.order_month, 6, 2) AS INTEGER)
           - CAST(substr(fp.cohort_month, 6, 2) AS INTEGER) AS months_since_first_purchase,
         COUNT(DISTINCT fo.customer_id) AS active_customers
  FROM finalized_orders AS fo
  JOIN first_purchase AS fp ON fp.customer_id = fo.customer_id
  GROUP BY fp.cohort_month, fo.order_month, months_since_first_purchase
), cohort_size AS (
  SELECT cohort_month, COUNT(*) AS customers_in_cohort
  FROM first_purchase
  GROUP BY cohort_month
)
SELECT ca.cohort_month,
       ca.months_since_first_purchase,
       cs.customers_in_cohort,
       ca.active_customers,
       ROUND(100.0 * ca.active_customers / cs.customers_in_cohort, 2) AS retention_pct
FROM cohort_activity AS ca
JOIN cohort_size AS cs ON cs.cohort_month = ca.cohort_month
ORDER BY ca.cohort_month, ca.months_since_first_purchase;
