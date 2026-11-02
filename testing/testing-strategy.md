# Database testing strategy

> **English** · [Srpski](testing-strategy.sr.md)

## Test at the boundary where a failure would be expensive

| Layer | What to prove | Example |
| --- | --- | --- |
| schema | invalid states are rejected | a negative price violates `CHECK` |
| migration | old data reaches the new shape safely | backfill is resumable and counts reconcile |
| query | result grain and totals are correct | one order is counted once despite many lines |
| transaction | partial work cannot persist | failed checkout leaves no stock decrement |
| concurrency | competing requests preserve invariants | two reservations cannot overlap |
| access | a role/tenant sees only permitted rows | RLS denies a missing tenant context |
| recovery | data can be restored within objective | scheduled restore drill passes |

## Fixture design

Small fixtures should deliberately include: zero related rows, multiple related rows, `NULL`, duplicate-looking labels with different IDs, tied sort values, rejected status, and boundary time. A fixture made only of happy paths cannot expose a wrong join or filter.

## Assertions versus snapshots

Use an assertion for a business invariant (`revenue = 4,995` under known data). Use a snapshot sparingly for large report shape. Snapshots can normalize a wrong result if they are accepted without review.

For migrations, test both a fresh install and an upgrade from a representative earlier version. For high-risk changes, test rollback or the forward-fix path before production.
