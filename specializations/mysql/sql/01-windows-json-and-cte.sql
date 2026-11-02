-- Modern MySQL 8 query features / Savremene MySQL 8 mogućnosti. Run after 00 / Posle 00.

WITH order_totals AS (
  SELECT o.order_id,
         o.customer_id,
         o.ordered_at,
         SUM(ol.quantity * ol.unit_price_cents) AS total_cents
  FROM learning_orders AS o
  JOIN learning_order_lines AS ol ON ol.order_id = o.order_id
  WHERE o.status IN ('paid', 'shipped')
  GROUP BY o.order_id, o.customer_id, o.ordered_at
)
SELECT customer_id,
       order_id,
       total_cents,
       ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY ordered_at, order_id) AS customer_order_number,
       SUM(total_cents) OVER (
         PARTITION BY customer_id
         ORDER BY ordered_at, order_id
         ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS running_spend_cents
FROM order_totals
ORDER BY customer_id, customer_order_number;

SELECT item_id, title, author_name
FROM learning_catalog_items
WHERE JSON_UNQUOTE(JSON_EXTRACT(attributes, '$.level')) = 'advanced';

SELECT i.title, jt.attribute_key, jt.attribute_value
FROM learning_catalog_items AS i
JOIN JSON_TABLE(
  i.attributes,
  '$' COLUMNS (
    attribute_key FOR ORDINALITY,
    attribute_value VARCHAR(200) PATH '$.author'
  )
) AS jt
WHERE i.item_id = 1;
