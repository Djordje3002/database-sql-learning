-- 07: Capstone analytics / Završna analitika

WITH finalized_order_totals AS (
  SELECT o.order_id,
         o.customer_id,
         o.ordered_at,
         SUM(oi.quantity * oi.unit_price_cents) AS total_cents
  FROM orders AS o
  JOIN order_items AS oi ON oi.order_id = o.order_id
  WHERE o.status IN ('paid', 'shipped')
  GROUP BY o.order_id, o.customer_id, o.ordered_at
), customer_order_history AS (
  SELECT fot.*,
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
  FROM finalized_order_totals AS fot
), customer_totals AS (
  SELECT customer_id,
         SUM(total_cents) AS lifetime_spend_cents
  FROM finalized_order_totals
  GROUP BY customer_id
), ranked_customers AS (
  SELECT customer_id,
         lifetime_spend_cents,
         DENSE_RANK() OVER (ORDER BY lifetime_spend_cents DESC) AS customer_spend_rank
  FROM customer_totals
)
SELECT c.full_name,
       h.order_id,
       h.ordered_at,
       h.total_cents,
       h.customer_order_number,
       h.total_cents - h.previous_order_cents AS change_from_previous_cents,
       h.running_spend_cents,
       r.customer_spend_rank,
       CASE WHEN r.customer_spend_rank <= 3 THEN 1 ELSE 0 END AS is_top_three_customer
FROM customer_order_history AS h
JOIN customers AS c ON c.customer_id = h.customer_id
JOIN ranked_customers AS r ON r.customer_id = h.customer_id
ORDER BY r.customer_spend_rank, h.customer_id, h.ordered_at, h.order_id;
