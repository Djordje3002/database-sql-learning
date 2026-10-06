-- Project 03 seed / Podaci za projekat 03. Safe to run more than once / Bezbedno za ponavljanje.

PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS web_events (
  event_id INTEGER PRIMARY KEY,
  session_id TEXT NOT NULL,
  customer_id INTEGER,
  event_type TEXT NOT NULL CHECK (event_type IN ('visit', 'search', 'add_to_cart', 'checkout', 'purchase')),
  occurred_at TEXT NOT NULL,
  FOREIGN KEY (customer_id) REFERENCES kupci(id)
);

INSERT OR IGNORE INTO web_events (event_id, session_id, customer_id, event_type, occurred_at) VALUES
  (1, 's-100', 1, 'visit', '2026-01-10 09:00:00'),
  (2, 's-100', 1, 'search', '2026-01-10 09:01:00'),
  (3, 's-100', 1, 'add_to_cart', '2026-01-10 09:02:00'),
  (4, 's-100', 1, 'checkout', '2026-01-10 09:03:00'),
  (5, 's-100', 1, 'purchase', '2026-01-10 09:04:00'),
  (6, 's-101', 2, 'visit', '2026-01-12 11:00:00'),
  (7, 's-101', 2, 'search', '2026-01-12 11:01:00'),
  (8, 's-102', 3, 'visit', '2026-02-02 16:00:00'),
  (9, 's-103', NULL, 'visit', '2026-03-01 08:00:00'),
  (10, 's-103', NULL, 'search', '2026-03-01 08:01:00'),
  (11, 's-103', NULL, 'add_to_cart', '2026-03-01 08:02:00'),
  (12, 's-104', 2, 'visit', '2026-03-02 13:00:00'),
  (13, 's-104', 2, 'search', '2026-03-02 13:01:00'),
  (14, 's-104', 2, 'add_to_cart', '2026-03-02 13:02:00'),
  (15, 's-104', 2, 'checkout', '2026-03-02 13:03:00');
