# Practical SQL Course

> Learn SQL by solving realistic requests: a library catalog, bookstore sales reporting, and customer-behavior analytics.

[Srpski vodič →](../README.md)

This folder is the hands-on lab for the course. The main `docs/` material explains the concepts; the projects here turn those concepts into small, verifiable pieces of work. They are ordered by difficulty and use the SQLite database from the main course.

## Working method

1. Create a dedicated practice database so every attempt is safe and repeatable.
2. Load the base schema from `sql/00-priprema-baze.sql`.
3. Read the project brief, then solve the tasks in its starter file in order.
4. Run the validation queries only after you believe you are done.
5. Compare your reasoning with the solution, not just the final rows.

```bash
# from the repository root
sqlite3 practice.db < sql/00-priprema-baze.sql
sqlite3 practice.db
```

From the SQLite shell, load a file like this:

```sql
.read practice/01-biblioteka-operacije/starter.sql
```

Projects 02 and 03 also need their `seed.sql` file first. Every seed is idempotent through `INSERT OR IGNORE`, so it is safe to run it repeatedly against the same practice database.

## Project sequence

| Project | Scenario | Main skills | Level |
| --- | --- | --- | --- |
| [01 — Library operations](01-library-operations/README.md) | Catalog and librarian requests | `SELECT`, `JOIN`, `LEFT JOIN`, `GROUP BY`, views | Beginner → intermediate |
| [02 — Sales reporting](02-sales-reporting/README.md) | Online bookstore dashboard | CTEs, conditional aggregation, time series, window functions | Intermediate |
| [03 — Analytics and data quality](03-analytics-quality/README.md) | Funnel and quality checks | multi-step CTEs, funnels, segmentation, data-quality rules | Advanced |

Every project has a complete English brief under `practice/en/` and a matching Serbian brief in the parent language track. The runnable SQL is shared and uses concise bilingual comments so one verified implementation serves both paths.

## Production habits practiced here

- Use the historical line-item price (`stavke_narudzbine.cena_u_trenutku`) for revenue, never the current catalog price.
- Count only `placena` and `poslata` orders as recognized revenue; `nova` and `otkazana` orders are not revenue.
- Always know the grain of a query: does one row represent an order, an item, a customer, or a session? A wrong join can silently multiply totals.
- Use `LEFT JOIN` deliberately when zero-related records matter.
- Verify an `UPDATE` or `DELETE` predicate with a `SELECT` first and wrap changes in a transaction.
- Treat the solution as a review artifact, not as the first step.

## Completion standard

Each project has three levels of completion:

1. **Correctness** — the requested rows and columns are returned.
2. **Resilience** — the query still works with zero books, sales, or `NULL` values.
3. **Clarity** — aliases, CTE names, grouping, and column order make the query easy to review.

The project-level `verify.sql` files expose control totals and review lists rather than automatically grading a submission. That mirrors real database work: a query is validated against business rules, not merely because it executes.

Start with [Project 01](01-library-operations/README.md) and work through the sequence. The goal is not memorizing keywords; it is turning an ambiguous business question into a trustworthy query.
