# MySQL 8 Track

> **English** · [Srpski](README.sr.md)

This track teaches MySQL 8+ and InnoDB after the common SQL foundation. It is deliberately comparison-driven: MySQL shares most query syntax with PostgreSQL and SQLite, but differs in stored-program syntax, JSON access, generated columns, index capabilities, transaction behavior, and query-plan tools.

## Run locally

Use a local disposable MySQL database:

```bash
mysql -u root -p -e 'CREATE DATABASE sql_learning_mysql'
mysql -u root -p sql_learning_mysql < sql/00-mysql-schema.sql
mysql -u root -p sql_learning_mysql < sql/01-windows-json-and-cte.sql
mysql -u root -p sql_learning_mysql < sql/02-procedures-and-transactions.sql
mysql -u root -p sql_learning_mysql < sql/03-performance-and-indexes.sql
```

The setup script resets only tables with the `learning_` prefix in the selected database. Never point it at production.

## Modules

| # | Focus | Difference worth remembering | Lab |
| --- | --- | --- | --- |
| 00 | InnoDB schema | `BIGINT` auto increment, `DECIMAL`, `DATETIME`, generated columns | [setup](sql/00-mysql-schema.sql) |
| 01 | Modern query features | CTEs, window functions, `JSON_EXTRACT`, `JSON_TABLE` | [query lab](sql/01-windows-json-and-cte.sql) |
| 02 | Procedures and transactions | `DELIMITER`, `SIGNAL`, explicit transaction control | [procedure lab](sql/02-procedures-and-transactions.sql) |
| 03 | Performance | composite indexes, `EXPLAIN ANALYZE`, no native partial indexes | [performance lab](sql/03-performance-and-indexes.sql) |

## MySQL habits for production

- Use InnoDB; it provides transactions, foreign keys, and row-level locking.
- Use `DECIMAL(p,s)` or integer minor units for money, never `FLOAT` or `DOUBLE`.
- Index foreign keys and query patterns deliberately. In a composite index, equality filters usually precede range/order columns.
- Read `EXPLAIN ANALYZE` rather than guessing. `EXPLAIN` estimates; `ANALYZE` executes the query and reports actual work.
- MySQL has no PostgreSQL-style partial index. If you need a selective access pattern, consider a generated column plus a composite index, but measure before adding complexity.
- Keep transaction scopes short. Lock rows only for the short state transition, not while calling other services.

See [PostgreSQL Track](../postgresql/README.md) for the corresponding PostgreSQL approach and [operations runbooks](../../operations/README.md) for migration, backup, and deployment practices.
