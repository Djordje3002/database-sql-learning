# PostgreSQL Track

> **English** · [Srpski](README.sr.md)

This is a PostgreSQL 16+ specialization for learners who have completed the SQL foundations. It focuses on features and engineering choices that do not translate directly to SQLite: strong types, `JSONB`, stored functions and procedures, row-level security, query plans, partial/covering indexes, full-text search, and connection behavior.

## How to run

Create an empty local database, then execute the labs in order:

```bash
createdb sql_learning_pg
psql -d sql_learning_pg -f sql/00-postgresql-schema.sql
psql -d sql_learning_pg -f sql/01-functions-and-procedures.sql
psql -d sql_learning_pg -f sql/02-row-level-security.sql
psql -d sql_learning_pg -f sql/03-performance-and-indexes.sql
psql -d sql_learning_pg -f sql/04-jsonb-and-search.sql
```

The RLS lab creates non-login demonstration roles, so run it only in a disposable local database that you own. Do not use the reset scripts against production data.

## Modules

| # | Topic | What you learn | Lab |
| --- | --- | --- | --- |
| 00 | PostgreSQL-first schema | `bigint` identity keys, `timestamptz`, `numeric`, constraints, and foreign-key indexes | [schema](sql/00-postgresql-schema.sql) |
| 01 | Functions and procedures | `plpgsql`, `RETURNING`, validation, clear transaction boundaries | [function/procedure lab](sql/01-functions-and-procedures.sql) |
| 02 | Multi-tenant security | least-privilege roles, Row-Level Security, safe session context | [RLS lab](sql/02-row-level-security.sql) |
| 03 | Performance evidence | `EXPLAIN (ANALYZE, BUFFERS)`, composite, partial, and covering indexes | [performance lab](sql/03-performance-and-indexes.sql) |
| 04 | Flexible data, deliberate access | `JSONB`, GIN/expression indexes, and full-text search | [JSONB/search lab](sql/04-jsonb-and-search.sql) |

## Production rules to carry forward

- Prefer `bigint GENERATED ... AS IDENTITY` for durable IDs, `timestamptz` for event time, and exact `numeric` or integer minor units for money.
- PostgreSQL does **not** automatically index foreign-key columns; index them when joins, deletes, or cascades need to scale.
- Add indexes for observed queries, then verify them with `EXPLAIN (ANALYZE, BUFFERS)` on representative data. A sequential scan is not automatically wrong.
- Put equality predicates before range/order columns in a composite B-tree index. Match a partial-index predicate exactly in the query.
- Use a pooler in applications; do not open a PostgreSQL connection per request. Keep transactions short and never hold locks during an HTTP call.
- RLS is a database-enforced tenant boundary, not a substitute for application authorization. Index policy columns and make a missing tenant context deny access.

## Important safety notes

`SECURITY DEFINER` functions and RLS policies deserve code review. A `SECURITY DEFINER` function runs with the owner’s privileges: set a safe `search_path`, validate the caller’s identity, keep it in a non-exposed schema, and revoke execution from roles that should not invoke it.

The SQL comments are bilingual because the executable syntax is shared. Read this guide together with the English foundation and [Advanced Database Course](../../advanced/en/README.md).
