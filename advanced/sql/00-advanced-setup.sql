-- Advanced database course setup / Priprema za napredni kurs (SQLite 3)

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS order_status_audit;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
  customer_id INTEGER PRIMARY KEY,
  full_name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  city TEXT NOT NULL
);

CREATE TABLE products (
  product_id INTEGER PRIMARY KEY,
  sku TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  category TEXT NOT NULL,
  current_price_cents INTEGER NOT NULL CHECK (current_price_cents >= 0),
  stock INTEGER NOT NULL CHECK (stock >= 0)
);

CREATE TABLE orders (
  order_id INTEGER PRIMARY KEY,
  customer_id INTEGER NOT NULL,
  ordered_at TEXT NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('new', 'paid', 'shipped', 'cancelled')),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
  order_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,
  quantity INTEGER NOT NULL CHECK (quantity > 0),
  unit_price_cents INTEGER NOT NULL CHECK (unit_price_cents >= 0),
  PRIMARY KEY (order_id, product_id),
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE order_status_audit (
  audit_id INTEGER PRIMARY KEY,
  order_id INTEGER NOT NULL,
  old_status TEXT NOT NULL,
  new_status TEXT NOT NULL,
  changed_at TEXT NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

INSERT INTO customers (customer_id, full_name, email, city) VALUES
  (1, 'Ana Anić', 'ana@example.com', 'Beograd'),
  (2, 'Marko Marković', 'marko@example.com', 'Novi Sad'),
  (3, 'Jelena Jovanović', 'jelena@example.com', 'Niš'),
  (4, 'Sara Savić', 'sara@example.com', 'Kragujevac');

INSERT INTO products (product_id, sku, name, category, current_price_cents, stock) VALUES
  (1, 'SQL-101', 'SQL Fundamentals', 'technical', 2499, 15),
  (2, 'DB-220', 'Database Design', 'technical', 3299, 8),
  (3, 'NOV-1984', '1984', 'fiction', 1199, 22),
  (4, 'NOV-ANIMAL', 'Animal Farm', 'fiction', 999, 12);

INSERT INTO orders (order_id, customer_id, ordered_at, status) VALUES
  (101, 1, '2026-01-10', 'paid'),
  (102, 2, '2026-01-15', 'shipped'),
  (103, 1, '2026-02-03', 'shipped'),
  (104, 3, '2026-02-18', 'cancelled'),
  (105, 2, '2026-03-01', 'paid'),
  (106, 1, '2026-03-12', 'new'),
  (107, 3, '2026-03-20', 'shipped');

INSERT INTO order_items (order_id, product_id, quantity, unit_price_cents) VALUES
  (101, 1, 1, 2499), (101, 3, 1, 1199),
  (102, 2, 1, 3199),
  (103, 4, 2, 999),
  (104, 3, 1, 1199),
  (105, 1, 1, 2399), (105, 2, 1, 3299),
  (106, 4, 1, 999),
  (107, 3, 3, 1099);
