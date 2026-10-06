# 02 — Transactions and isolation: all succeeds, or nothing changes

> **English** · [Srpski](../../docs/02-transactions-isolation.md)

A transaction is the boundary of one business operation. Creating an order can involve a header, items, payment state, and inventory. If one step fails, the database must not keep an incomplete order.

| ACID property | Practical meaning |
| --- | --- |
| Atomicity | all changes succeed together or all are undone |
| Consistency | constraints and business rules hold after success |
| Isolation | concurrent operations do not expose contradictory unfinished state |
| Durability | after `COMMIT`, data survives according to the database guarantees and configuration |

```sql
BEGIN;
  -- checks and changes
COMMIT;

-- use this instead of COMMIT when the operation cannot finish
ROLLBACK;
```

`SAVEPOINT` is a local rollback point inside a larger transaction; it is not a substitute for a properly defined business boundary. Critical transitions should also guard their old state:

```sql
UPDATE orders
SET status = 'paid'
WHERE order_id = :order_id
  AND status = 'new';
```

The application must verify that exactly one row changed. That prevents two requests from both treating the same new order as newly paid.

SQLite provides atomic transactions but allows only one active writer per database file. Keep transactions short; never hold one open while waiting for a person or an HTTP call. For write contention, `BEGIN IMMEDIATE` detects the conflict earlier. PostgreSQL and MySQL have different concurrency models, so test their isolation behavior directly.

Before release, test: success, rollback, duplicated request, timeout, and interruption between steps. Run the [transaction lab](../../sql/02-transactions-isolation.sql).
