-- Banking ledger starter schema / Početna šema bankarskog ledger projekta.

CREATE SCHEMA IF NOT EXISTS banking;

CREATE TABLE banking.customers (
  customer_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  full_name text NOT NULL,
  external_reference text NOT NULL UNIQUE
);

CREATE TABLE banking.accounts (
  account_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  customer_id bigint NOT NULL REFERENCES banking.customers(customer_id),
  currency char(3) NOT NULL,
  status text NOT NULL CHECK (status IN ('open', 'frozen', 'closed')),
  opened_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE banking.transfers (
  transfer_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  initiated_by_customer_id bigint NOT NULL REFERENCES banking.customers(customer_id),
  idempotency_key uuid NOT NULL UNIQUE,
  status text NOT NULL CHECK (status IN ('pending', 'completed', 'reversed', 'failed')),
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE banking.ledger_entries (
  ledger_entry_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  transfer_id bigint NOT NULL REFERENCES banking.transfers(transfer_id) ON DELETE RESTRICT,
  account_id bigint NOT NULL REFERENCES banking.accounts(account_id) ON DELETE RESTRICT,
  direction text NOT NULL CHECK (direction IN ('debit', 'credit')),
  amount_cents bigint NOT NULL CHECK (amount_cents > 0),
  currency char(3) NOT NULL,
  posted_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (transfer_id, direction)
);

CREATE INDEX accounts_customer_id_idx ON banking.accounts(customer_id);
CREATE INDEX ledger_entries_account_posted_at_idx ON banking.ledger_entries(account_id, posted_at DESC);
CREATE INDEX ledger_entries_transfer_id_idx ON banking.ledger_entries(transfer_id);

-- Add an append-only trigger as an exercise: reject UPDATE/DELETE for posted ledger entries.
