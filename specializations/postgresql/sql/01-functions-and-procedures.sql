-- Functions and procedures / Funkcije i procedure. Run after 00-postgresql-schema.sql / Pokreni posle 00.

CREATE OR REPLACE FUNCTION academy.apply_catalog_discount(
  p_item_id bigint,
  p_percent numeric
)
RETURNS academy.catalog_items
LANGUAGE plpgsql
AS $$
DECLARE
  updated_item academy.catalog_items;
BEGIN
  IF p_percent <= 0 OR p_percent > 100 THEN
    RAISE EXCEPTION 'Discount percentage must be between 0 and 100';
  END IF;

  UPDATE academy.catalog_items
  SET price_cents = round(price_cents * (1 - p_percent / 100.0))::integer
  WHERE item_id = p_item_id
  RETURNING * INTO updated_item;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Catalog item % does not exist', p_item_id;
  END IF;

  RETURN updated_item;
END;
$$;

CREATE OR REPLACE PROCEDURE academy.mark_order_paid(
  p_order_id bigint,
  p_payment_reference text
)
LANGUAGE plpgsql
AS $$
BEGIN
  IF nullif(trim(p_payment_reference), '') IS NULL THEN
    RAISE EXCEPTION 'Payment reference is required';
  END IF;

  UPDATE academy.orders
  SET status = 'paid',
      payment_reference = p_payment_reference
  WHERE order_id = p_order_id
    AND status = 'new';

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Order % is missing or not new', p_order_id;
  END IF;
END;
$$;

BEGIN;
SELECT (academy.apply_catalog_discount(1, 10)).price_cents AS discounted_price_cents;
CALL academy.mark_order_paid(1, 'payment-demo-001');
SELECT order_id, status, payment_reference
FROM academy.orders
WHERE order_id = 1;
ROLLBACK;

-- Keep COMMIT/ROLLBACK in the application workflow / Granicu COMMIT/ROLLBACK drži u toku rada aplikacije.
