# 07 — Mini project: a report you can defend

> **English** · [Srpski](../../docs/07-mini-project.md)

Build a sales report for every paid or shipped order. It must show the customer, date, total amount, that customer's order number, change from their previous finalized order, running customer spend, customer lifetime-spend rank, and whether the customer is in the top three.

## Acceptance criteria

- Order amount is `quantity * unit_price_cents` per order.
- Each customer has an independent sequence with `PARTITION BY customer_id`.
- Ordering is stable: `ORDER BY ordered_at, order_id`.
- Customer ranking considers every finalized order before result filtering.
- The query uses named CTEs that describe each business stage.
- `new` and `cancelled` orders are excluded from recognized revenue.

Suggested plan: calculate order totals; add `LAG`, `ROW_NUMBER`, and running `SUM`; calculate and rank customer totals in a separate stage; join customer names and a top-three flag. Then inspect the plan before considering an index.

Try it first, then compare with the [commented capstone solution](../../sql/07-capstone-analytics.sql). The valuable outcome is the explanation of your assumptions, not only the returned rows.
