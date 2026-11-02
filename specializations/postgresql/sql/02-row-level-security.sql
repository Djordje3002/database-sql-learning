-- Row-Level Security lab / RLS vežba. Run only in a local disposable database / Samo lokalna test baza.

CREATE TABLE academy.workspaces (
  workspace_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name text NOT NULL UNIQUE
);

CREATE TABLE academy.workspace_orders (
  workspace_order_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  workspace_id bigint NOT NULL REFERENCES academy.workspaces(workspace_id) ON DELETE CASCADE,
  description text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX workspace_orders_workspace_id_idx ON academy.workspace_orders(workspace_id);

INSERT INTO academy.workspaces (name) VALUES ('Alpha'), ('Beta');
INSERT INTO academy.workspace_orders (workspace_id, description) VALUES
  (1, 'Alpha internal order'),
  (2, 'Beta internal order');

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'academy_app') THEN
    CREATE ROLE academy_app NOLOGIN;
  END IF;
  EXECUTE format('GRANT academy_app TO %I', current_user);
END;
$$;

REVOKE ALL ON SCHEMA academy FROM PUBLIC;
REVOKE ALL ON academy.workspace_orders FROM PUBLIC;
GRANT USAGE ON SCHEMA academy TO academy_app;
GRANT SELECT, INSERT, UPDATE ON academy.workspace_orders TO academy_app;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA academy TO academy_app;

ALTER TABLE academy.workspace_orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE academy.workspace_orders FORCE ROW LEVEL SECURITY;

CREATE POLICY workspace_orders_tenant_policy
ON academy.workspace_orders
FOR ALL TO academy_app
USING (
  workspace_id = NULLIF(current_setting('app.workspace_id', true), '')::bigint
)
WITH CHECK (
  workspace_id = NULLIF(current_setting('app.workspace_id', true), '')::bigint
);

-- In a trusted transaction after authentication / U pouzdanoj transakciji nakon autentikacije:
BEGIN;
SET LOCAL ROLE academy_app;
SET LOCAL app.workspace_id = '1';
SELECT workspace_id, description FROM academy.workspace_orders ORDER BY workspace_order_id;
ROLLBACK;

-- A missing context evaluates to NULL and permits no rows / Nedostajući kontekst ne dozvoljava nijedan red.
