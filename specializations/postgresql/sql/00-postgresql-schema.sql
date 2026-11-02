-- PostgreSQL 16+ setup / Priprema za PostgreSQL 16+ stazu. Destructive in this schema / Briše samo academy šemu.

DROP SCHEMA IF EXISTS academy CASCADE;
CREATE SCHEMA academy;

CREATE TABLE academy.customers (
  customer_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  full_name text NOT NULL,
  email text NOT NULL UNIQUE,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE academy.catalog_items (
  item_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  title text NOT NULL,
  price_cents integer NOT NULL CHECK (price_cents >= 0),
  attributes jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE academy.orders (
  order_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  customer_id bigint NOT NULL REFERENCES academy.customers(customer_id) ON DELETE RESTRICT,
  status text NOT NULL CHECK (status IN ('new', 'paid', 'shipped', 'cancelled')),
  payment_reference text UNIQUE,
  purchased_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE academy.order_lines (
  order_id bigint NOT NULL REFERENCES academy.orders(order_id) ON DELETE CASCADE,
  item_id bigint NOT NULL REFERENCES academy.catalog_items(item_id) ON DELETE RESTRICT,
  quantity integer NOT NULL CHECK (quantity > 0),
  unit_price_cents integer NOT NULL CHECK (unit_price_cents >= 0),
  PRIMARY KEY (order_id, item_id)
);

-- PostgreSQL does not create these foreign-key indexes automatically / PostgreSQL ne pravi FK indekse automatski.
CREATE INDEX orders_customer_id_idx ON academy.orders(customer_id);
CREATE INDEX order_lines_item_id_idx ON academy.order_lines(item_id);

INSERT INTO academy.customers (full_name, email) VALUES
  ('Ana Anić', 'ana@example.com'),
  ('Marko Marković', 'marko@example.com');

INSERT INTO academy.catalog_items (title, price_cents, attributes) VALUES
  ('PostgreSQL in Practice', 3499, '{"format":"paperback","level":"advanced","author":"M. Data"}'),
  ('SQL Foundations', 2499, '{"format":"ebook","level":"beginner","author":"A. Query"}');

INSERT INTO academy.orders (customer_id, status, purchased_at) VALUES
  (1, 'new', '2026-01-15 09:30:00+01'),
  (2, 'shipped', '2026-02-11 10:00:00+01');

INSERT INTO academy.order_lines (order_id, item_id, quantity, unit_price_cents) VALUES
  (1, 1, 1, 3499),
  (2, 2, 2, 2499);
