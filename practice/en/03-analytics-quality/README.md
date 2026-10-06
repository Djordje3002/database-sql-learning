# Project 03 — Analytics and Data Quality

> Turn user events and operational tables into metrics a team can trust.

[Srpska verzija →](../../03-analitika-kvalitet/README.md) · [Back to practice](../README.md)

## Scenario

The team needs to know where visitors abandon a purchase, which customers generate revenue, and whether the database has visible gaps. You receive website events and the bookstore practice database. Build analytics that never confuse the grain of a session, a customer, and an order.

Start from a clean database:

```bash
sqlite3 practice.db < sql/00-priprema-baze.sql
sqlite3 practice.db < practice/03-analitika-kvalitet/seed.sql
```

## Business rules

- Funnel steps are counted by `session_id`, never by raw event rows.
- Recognized revenue comes only from `placena` and `poslata` orders.
- An event with no known customer is valid: a visitor does not need to be signed in.
- A data-quality check may correctly return zero rows when it finds no defect.

## Tasks

| # | Request | Focus |
| --- | --- | --- |
| 1 | Show event count and distinct-session count by event type. | grain, `COUNT(DISTINCT ...)` |
| 2 | Build `visit` → `search` → `add_to_cart` → `checkout` → `purchase` with visit-to-step conversion. | conditional aggregation, `NULLIF` |
| 3 | Segment every customer as `no revenue`, `standard`, or `vip` using recognized revenue. | `LEFT JOIN`, `CASE`, `COALESCE` |
| 4 | Show each session's last event and whether it reached purchase. | `ROW_NUMBER()`, CTE |
| 5 | Return one quality report for books without authors, customers without email, and publishers without books. | `UNION ALL`, explicit problem label |
| 6 | Find finalized orders with no line items. Explain why an empty result is useful. | anti-join, integrity |

## Completion checks

- The funnel has 5 visits, 4 searches, 3 cart additions, 2 checkouts, and 1 purchase.
- The segmentation keeps every customer, including `Jelena Jovanović` with zero revenue.
- The quality report includes at least `Uvod u baze podataka`, `Jelena Jovanović`, and `Mali princ`.
- Revenue is not multiplied by joining orders to events.

Work from [starter.sql](../../03-analitika-kvalitet/starter.sql), check [verify.sql](../../03-analitika-kvalitet/verify.sql), then compare with [solution.sql](../../03-analitika-kvalitet/solution.sql).
