-- KPI definitions and rolling windows / KPI definicije i rolling prozori. Run after 00 / Posle 00.

WITH monthly AS (
  SELECT substr(ordered_at, 1, 7) AS order_month,
         COUNT(*) AS finalized_orders,
         COUNT(DISTINCT customer_id) AS active_customers,
         SUM(revenue_cents) AS revenue_cents,
         ROUND(AVG(revenue_cents), 2) AS average_order_value_cents
  FROM fact_orders
  WHERE status IN ('paid', 'shipped')
  GROUP BY substr(ordered_at, 1, 7)
)
SELECT order_month,
       finalized_orders,
       active_customers,
       revenue_cents,
       average_order_value_cents,
       SUM(revenue_cents) OVER (
         ORDER BY order_month
         ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ) AS rolling_three_month_revenue_cents
FROM monthly
ORDER BY order_month;

-- Product mix must preserve order grain before any unrelated fact is joined / Product mix čuva zrno narudžbine pre drugih fact tabela.
SELECT p.category,
       SUM(f.revenue_cents) AS revenue_cents,
       ROUND(100.0 * SUM(f.revenue_cents) / SUM(SUM(f.revenue_cents)) OVER (), 2) AS revenue_share_pct
FROM fact_orders AS f
JOIN dim_products AS p ON p.product_id = f.product_id
WHERE f.status IN ('paid', 'shipped')
GROUP BY p.category
ORDER BY revenue_cents DESC;
