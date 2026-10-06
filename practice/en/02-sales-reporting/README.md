# Project 02 — Bookstore Sales Reporting

> Build reports a team can trust: revenue, customers, products, statuses, and monthly trends.

[Srpska verzija →](../../02-prodaja-izvestavanje/README.md) · [Back to practice](../README.md)

## Scenario

An online bookstore has grown beyond manually reading orders. The owner needs monthly revenue, best-selling titles, customer value, and cancellation rate. Financial totals must remain correct even if the current catalog price changes later.

This project adds a realistic order dataset to the base database. Run `seed.sql` before beginning.

## Business definitions

| Term | Rule in this project |
| --- | --- |
| Recognized revenue | The sum of `kolicina × cena_u_trenutku` only for `placena` and `poslata` statuses. |
| Finalized order | An order whose status is `placena` or `poslata`. |
| Order value | The sum of its line items; it is never copied from `knjige.cena`. |
| Customer with zero revenue | A customer without a finalized order; they must remain visible whenever the request says “all customers.” |
| Order month | The first seven characters of the ISO date: `YYYY-MM`. |

## Tasks

### Required work

| # | Request | Constraint that tests understanding |
| --- | --- | --- |
| 1 | Create the `vw_praksa_prodaja_redovi` view. | One row must represent **one order line**, not a book and not an entire order. |
| 2 | Build monthly revenue and finalized-order counts. | Calculate the order total first, then group by month; this avoids inflated order counts. |
| 3 | Build revenue by customer city. | Retain a city whose customers produced no revenue. |
| 4 | Show the top three books by revenue and units sold. | In the complete report, books without sales must be able to appear with zeroes, even if you later limit to three rows. |
| 5 | Rank customers by recognized revenue. | Use `DENSE_RANK()` and retain the customer with zero revenue. |
| 6 | Calculate monthly cancellation rate. | The numerator is only `otkazana`; the denominator is all orders in the month. Prevent division by zero. |

### Capstone task

7. Create an owner’s monthly overview with: total orders, finalized orders, recognized revenue, average finalized-order value, and cumulative revenue. Use at least two CTEs and a window function for the running total.

### Stretch tasks

8. Show customers whose first finalized purchase occurred in a chosen month, regardless of later purchases.

9. Write a query to identify order lines whose historical price differs from the **current** catalog price. Do not label the difference an error by default: a historical price may reflect a promotion.

## Success criteria

- After loading the seed, there are 7 customers and 12 orders.
- Total recognized revenue is **25,876.00**.
- `nova` and `otkazana` orders are excluded from revenue.
- The customer report includes `Sara Savić` with revenue `0`.
- Monthly revenue covers `2026-01` through `2026-06`; March has the control total **6,093.00**.
- Finalized-order counts are not multiplied by the number of order lines.

## Workflow

From the repository root, create a clean database and load the data:

```bash
sqlite3 practice.db < sql/00-priprema-baze.sql
sqlite3 practice.db < practice/02-prodaja-izvestavanje/seed.sql
sqlite3 practice.db
```

Then, in the SQLite shell:

```sql
.read practice/02-prodaja-izvestavanje/starter.sql
-- write and run your own queries
.read practice/02-prodaja-izvestavanje/verify.sql
```

When you are satisfied with your approach, review the shared [reference solution](../../02-prodaja-izvestavanje/solution.sql). It is one clear implementation, not the only correct one.

## What to watch closely

1. **Query grain.** `stavke_narudzbine` produces multiple rows per order. Counting `n.id` immediately can count the same order more than once.
2. **Filter timing.** A finalized-order CTE with `WHERE n.status IN (...)` is easier to reason about than filtering after a large join.
3. **Zeroes versus missing values.** A business report usually needs `0`, while `NULL` means unknown or absent.
4. **Status is not revenue.** Order statuses change during the lifecycle; always document the revenue definition in the query or its documentation.

If you can explain why order totals are calculated before monthly aggregation, you have learned a pattern used in nearly every sales report.
