-- Webshop starter schema / Početna šema webshop projekta (PostgreSQL 16+).

CREATE SCHEMA IF NOT EXISTS webshop;

CREATE TABLE webshop.customers (
  customer_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  email text NOT NULL UNIQUE,
  full_name text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE webshop.products (
  product_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  sku text NOT NULL UNIQUE,
  title text NOT NULL,
  price_cents integer NOT NULL CHECK (price_cents >= 0),
  stock_on_hand integer NOT NULL CHECK (stock_on_hand >= 0),
  archived_at timestamptz
);

CREATE TABLE webshop.carts (
  cart_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  customer_id bigint NOT NULL REFERENCES webshop.customers(customer_id),
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE webshop.cart_items (
  cart_id bigint NOT NULL REFERENCES webshop.carts(cart_id) ON DELETE CASCADE,
  product_id bigint NOT NULL REFERENCES webshop.products(product_id),
  quantity integer NOT NULL CHECK (quantity > 0),
  PRIMARY KEY (cart_id, product_id)
);

CREATE TABLE webshop.orders (
  order_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  customer_id bigint NOT NULL REFERENCES webshop.customers(customer_id),
  idempotency_key uuid NOT NULL UNIQUE,
  status text NOT NULL CHECK (status IN ('new', 'paid', 'shipped', 'cancelled')),
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE webshop.order_lines (
  order_id bigint NOT NULL REFERENCES webshop.orders(order_id) ON DELETE RESTRICT,
  product_id bigint NOT NULL REFERENCES webshop.products(product_id),
  quantity integer NOT NULL CHECK (quantity > 0),
  unit_price_cents integer NOT NULL CHECK (unit_price_cents >= 0),
  PRIMARY KEY (order_id, product_id)
);

CREATE TABLE webshop.payments (
  payment_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  order_id bigint NOT NULL UNIQUE REFERENCES webshop.orders(order_id),
  provider_reference text NOT NULL UNIQUE,
  status text NOT NULL CHECK (status IN ('pending', 'succeeded', 'failed')),
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX carts_customer_id_idx ON webshop.carts(customer_id);
CREATE INDEX orders_customer_created_at_idx ON webshop.orders(customer_id, created_at DESC);
CREATE INDEX order_lines_product_id_idx ON webshop.order_lines(product_id);
CREATE INDEX products_low_stock_idx ON webshop.products(stock_on_hand) WHERE archived_at IS NULL;
