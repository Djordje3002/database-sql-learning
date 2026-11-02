# Portfolio Capstones

> **English** · [Srpski](README.sr.md)

These four projects turn the course into portfolio evidence. Each brief gives you a realistic domain, a PostgreSQL-first starter schema, non-negotiable rules, acceptance criteria, and an ER diagram. Implement the API or reporting layer in the language you prefer, but keep migrations, seed data, and evidence of tests in the project.

| Project | Domain | Core skills |
| --- | --- | --- |
| [01 — Webshop](01-webshop/README.md) | catalog, carts, checkout, inventory | transactional checkout, idempotency, payments, indexes |
| [02 — University](02-university/README.md) | courses, enrollment, grading | prerequisites, temporal rules, reporting, RLS |
| [03 — Banking ledger](03-banking-ledger/README.md) | accounts and transfers | immutable ledger, double-entry invariants, concurrency |
| [04 — Booking](04-booking/README.md) | rooms and reservations | time ranges, exclusion constraints, availability search |

## Definition of done

- Schema is delivered through versioned migrations, not manual production edits.
- Every foreign key and high-frequency query path has an intentional index rationale.
- Seed data includes happy paths and edge cases.
- State-changing paths use transactions and are idempotent where clients may retry.
- The project has at least one `EXPLAIN (ANALYZE, BUFFERS)` capture or documented reason why data is too small for a meaningful plan.
- Sensitive data and tenant data have a documented access strategy.
- README explains one trade-off you made and one change you would make at 100× scale.
