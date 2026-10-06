-- 02: Transactions and SAVEPOINT / Transakcije i SAVEPOINT
-- This lab rolls back at the end, so it is safe to repeat / Na kraju se radi ROLLBACK, pa je bezbedna za ponavljanje.

BEGIN IMMEDIATE;

-- Reserve stock atomically inside one business operation / Rezerviši zalihu unutar jedne poslovne operacije.
UPDATE products
SET stock = stock - 1
WHERE product_id = 1
  AND stock >= 1;

SAVEPOINT optional_gift;
INSERT INTO orders (order_id, customer_id, ordered_at, status)
VALUES (108, 4, '2026-04-01', 'new');
INSERT INTO order_items (order_id, product_id, quantity, unit_price_cents)
VALUES (108, 4, 1, 0);

-- The optional gift is rejected; undo only that optional section / Poklon se odbija; poništi samo taj deo.
ROLLBACK TO optional_gift;
RELEASE optional_gift;

SELECT product_id, name, stock
FROM products
WHERE product_id = 1;

SELECT order_id
FROM orders
WHERE order_id = 108;

-- Reset the whole lab / Vrati celu vežbu na početno stanje.
ROLLBACK;
