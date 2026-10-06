# 03 — Indexes and EXPLAIN: optimize with evidence

> **English** · [Srpski](../../docs/03-indexes-and-explain.md)

An index is an additional structure that helps the database find a small part of a table without scanning every row. It is not a speed switch: indexes take space and add work to `INSERT`, `UPDATE`, and `DELETE`.

For this frequent access pattern:

```sql
SELECT order_id, ordered_at, status
FROM orders
WHERE customer_id = ?
  AND ordered_at >= ?
ORDER BY ordered_at DESC;
```

a reasonable first candidate is:

```sql
CREATE INDEX idx_orders_customer_date
ON orders (customer_id, ordered_at DESC);
```

The equality column comes first; range and ordering columns follow. This is a design decision, not formatting. An index on `(a, b, c)` generally serves queries beginning with `a`, then often `a, b`; it rarely solves a search by only `b` or `c`.

Use `EXPLAIN QUERY PLAN` in SQLite, `EXPLAIN (ANALYZE, BUFFERS)` in PostgreSQL, and `EXPLAIN ANALYZE` in MySQL 8+. Compare plan, representative timing, and returned row count before and after. Avoid indexing every column, applying functions to indexed columns in filters, and assuming a low-cardinality column alone is selective.

The workflow is simple: capture the slow business query, measure, add the smallest matching index, compare, then watch the write cost. Run the [index lab](../../sql/03-indexes-and-explain.sql).
