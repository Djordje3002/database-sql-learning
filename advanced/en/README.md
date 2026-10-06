# 🚀 Advanced Database Course

> **English** · [Srpski](../README.md)

![Abstract query optimization flow](../../assets/advanced-query-optimization.png)

This is the production-minded continuation of the foundation course. Instead of isolated commands, each module solves a realistic bookstore problem: analytical reporting, consistent state changes, slow queries, data design, and safe application access.

## How to use it

The runnable labs target **SQLite 3** first, so they work locally with no server. Each theory lesson highlights material differences for PostgreSQL and MySQL.

```bash
# from the repository root
sqlite3 advanced.db < advanced/sql/00-advanced-setup.sql

# then run modules in order against the same database
sqlite3 advanced.db < advanced/sql/01-window-functions.sql
sqlite3 advanced.db < advanced/sql/02-transactions-isolation.sql
```

Run `00-advanced-setup.sql` again whenever you need a clean start. It only resets the advanced-course tables.

## Course path

| Module | Question answered | Theory | Runnable lab |
| --- | --- | --- | --- |
| 00 | What does the practice database contain? | — | [database setup](../sql/00-advanced-setup.sql) |
| 01 | How can we rank, compare, and accumulate without collapsing rows? | [window functions](docs/01-window-functions.md) | [`OVER` analytics](../sql/01-window-functions.sql) |
| 02 | How do many changes become one dependable business operation? | [transactions and isolation](docs/02-transactions-and-isolation.md) | [transactions and `SAVEPOINT`](../sql/02-transactions-isolation.sql) |
| 03 | Why is a query slow and which index actually helps? | [indexes and execution plans](docs/03-indexes-and-explain.md) | [`EXPLAIN QUERY PLAN`](../sql/03-indexes-and-explain.sql) |
| 04 | How can a schema prevent duplicated and invalid facts? | [normalization and design](docs/04-normalization-and-design.md) | [from import to model](../sql/04-normalization-and-design.sql) |
| 05 | When should a query become a view or automation become a trigger? | [views and triggers](docs/05-views-and-triggers.md) | [report and audit trail](../sql/05-views-and-triggers.sql) |
| 06 | How does SQL stay safe in a real application? | [security and parameters](docs/06-security-and-parameters.md) | [safe patterns](../sql/06-security-and-parameters.sql) |
| 07 | How do we combine everything into a defensible report? | [mini project](docs/07-mini-project.md) | [capstone analytics](../sql/07-capstone-analytics.sql) |

## Outcomes

By the end, you can:

- use `ROW_NUMBER`, `RANK`, `LAG`, and explicit window frames for analysis;
- model a business state change as a transaction with deliberate rollback boundaries;
- inspect a query plan, design a composite index, and measure the outcome;
- separate entities, relationships, and integrity rules without over-normalizing;
- build a focused `VIEW`, a constrained `TRIGGER`, and an auditable state change;
- use parameters, least privilege, and allow-lists for dynamic SQL safely.

## One operating rule

1. Write the clearest correct query.
2. Test it with known data and edge cases.
3. Inspect the plan and measure the real problem.
4. Only then add an index, cache, or denormalized copy — and measure again.

Fast but incorrect reporting is still a defect. A complex index without evidence is future maintenance cost.

## Dialect notes

| Topic | SQLite | PostgreSQL | MySQL 8+ |
| --- | --- | --- | --- |
| Window functions | supported in modern versions | supported | supported |
| Query plan | `EXPLAIN QUERY PLAN` | `EXPLAIN (ANALYZE, BUFFERS)` | `EXPLAIN ANALYZE` |
| Users and grants | not stored inside the database file | rich roles and privileges | users and privileges |
| Materialized view | no built-in feature | `MATERIALIZED VIEW` | use a table/tooling |
| Concurrent writes | one writer per database file | MVCC, multiple writers | InnoDB MVCC/locking |

Before translating a lab into production work, back up data, use version-controlled migrations, and test rollback. These are safe local exercises, not an automatic production migration plan.
