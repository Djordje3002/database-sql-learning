-- MySQL 8+ / InnoDB setup. Destructive only for learning_ tables / Briše samo learning_ tabele.

DROP TABLE IF EXISTS learning_order_lines;
DROP TABLE IF EXISTS learning_orders;
DROP TABLE IF EXISTS learning_catalog_items;
DROP TABLE IF EXISTS learning_customers;

CREATE TABLE learning_customers (
  customer_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  full_name VARCHAR(200) NOT NULL,
  email VARCHAR(320) NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (customer_id),
  UNIQUE KEY learning_customers_email_uq (email)
) ENGINE=InnoDB;

CREATE TABLE learning_catalog_items (
  item_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  title VARCHAR(300) NOT NULL,
  price_cents INT UNSIGNED NOT NULL,
  attributes JSON NOT NULL,
  author_name VARCHAR(200) GENERATED ALWAYS AS (JSON_UNQUOTE(JSON_EXTRACT(attributes, '$.author'))) STORED,
  PRIMARY KEY (item_id),
  KEY learning_catalog_items_author_idx (author_name),
  CONSTRAINT learning_catalog_items_price_ck CHECK (price_cents >= 0)
) ENGINE=InnoDB;

CREATE TABLE learning_orders (
  order_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  customer_id BIGINT UNSIGNED NOT NULL,
  status ENUM('new', 'paid', 'shipped', 'cancelled') NOT NULL,
  ordered_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (order_id),
  KEY learning_orders_customer_date_idx (customer_id, ordered_at DESC),
  CONSTRAINT learning_orders_customer_fk FOREIGN KEY (customer_id)
    REFERENCES learning_customers(customer_id)
) ENGINE=InnoDB;

CREATE TABLE learning_order_lines (
  order_id BIGINT UNSIGNED NOT NULL,
  item_id BIGINT UNSIGNED NOT NULL,
  quantity INT UNSIGNED NOT NULL,
  unit_price_cents INT UNSIGNED NOT NULL,
  PRIMARY KEY (order_id, item_id),
  KEY learning_order_lines_item_idx (item_id),
  CONSTRAINT learning_order_lines_order_fk FOREIGN KEY (order_id)
    REFERENCES learning_orders(order_id) ON DELETE CASCADE,
  CONSTRAINT learning_order_lines_item_fk FOREIGN KEY (item_id)
    REFERENCES learning_catalog_items(item_id),
  CONSTRAINT learning_order_lines_quantity_ck CHECK (quantity > 0)
) ENGINE=InnoDB;

INSERT INTO learning_customers (full_name, email) VALUES
  ('Ana Anić', 'ana@example.com'),
  ('Marko Marković', 'marko@example.com');

INSERT INTO learning_catalog_items (title, price_cents, attributes) VALUES
  ('MySQL in Practice', 3299, JSON_OBJECT('author', 'M. Data', 'level', 'advanced', 'format', 'paperback')),
  ('SQL Foundations', 2499, JSON_OBJECT('author', 'A. Query', 'level', 'beginner', 'format', 'ebook'));

INSERT INTO learning_orders (customer_id, status, ordered_at) VALUES
  (1, 'paid', '2026-01-15 09:30:00'),
  (2, 'shipped', '2026-02-11 10:00:00');

INSERT INTO learning_order_lines (order_id, item_id, quantity, unit_price_cents) VALUES
  (1, 1, 1, 3299),
  (2, 2, 2, 2499);
