-- 01: Window functions / Prozorske funkcije

WITH finalized_order_totals AS (
  SELECT o.order_id,
         o.customer_id,
         o.ordered_at,
         SUM(oi.quantity * oi.unit_price_cents) AS total_cents
  FROM orders AS o
  JOIN order_items AS oi ON oi.order_id = o.order_id
  WHERE o.status IN ('paid', 'shipped')
  GROUP BY o.order_id, o.customer_id, o.ordered_at
)
SELECT customer_id,
       order_id,
       ordered_at,
       total_cents,
       ROW_NUMBER() OVER (
         PARTITION BY customer_id
         ORDER BY ordered_at, order_id
       ) AS customer_order_number,
       LAG(total_cents) OVER (
         PARTITION BY customer_id
         ORDER BY ordered_at, order_id
       ) AS previous_order_cents,
       SUM(total_cents) OVER (
         PARTITION BY customer_id
         ORDER BY ordered_at, order_id
         ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS running_spend_cents
FROM finalized_order_totals
ORDER BY customer_id, ordered_at, order_id;

WITH product_revenue AS (
  SELECT p.category,
         p.name,
         SUM(oi.quantity * oi.unit_price_cents) AS revenue_cents
  FROM products AS p
  JOIN order_items AS oi ON oi.product_id = p.product_id
  JOIN orders AS o ON o.order_id = oi.order_id
  WHERE o.status IN ('paid', 'shipped')
  GROUP BY p.product_id, p.category, p.name
)
SELECT category,
       name,
       revenue_cents,
       DENSE_RANK() OVER (
         PARTITION BY category
         ORDER BY revenue_cents DESC
       ) AS revenue_rank_in_category
FROM product_revenue
ORDER BY category, revenue_rank_in_category, name;
