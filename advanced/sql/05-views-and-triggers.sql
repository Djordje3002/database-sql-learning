-- 05: Views and triggers / Pogledi i okidači

DROP VIEW IF EXISTS v_product_sales;
DROP TRIGGER IF EXISTS trg_orders_status_audit;

CREATE VIEW v_product_sales AS
SELECT p.product_id,
       p.name,
       COALESCE(SUM(CASE WHEN o.status IN ('paid', 'shipped') THEN oi.quantity ELSE 0 END), 0) AS units_sold,
       COALESCE(SUM(CASE WHEN o.status IN ('paid', 'shipped') THEN oi.quantity * oi.unit_price_cents ELSE 0 END), 0) AS revenue_cents
FROM products AS p
LEFT JOIN order_items AS oi ON oi.product_id = p.product_id
LEFT JOIN orders AS o ON o.order_id = oi.order_id
GROUP BY p.product_id, p.name;

CREATE TRIGGER trg_orders_status_audit
AFTER UPDATE OF status ON orders
FOR EACH ROW
WHEN OLD.status IS NOT NEW.status
BEGIN
  INSERT INTO order_status_audit (order_id, old_status, new_status, changed_at)
  VALUES (NEW.order_id, OLD.status, NEW.status, datetime('now'));
END;

SELECT *
FROM v_product_sales
ORDER BY revenue_cents DESC, name;

BEGIN;
UPDATE orders
SET status = 'shipped'
WHERE order_id = 101;
SELECT order_id, old_status, new_status
FROM order_status_audit;
ROLLBACK;
