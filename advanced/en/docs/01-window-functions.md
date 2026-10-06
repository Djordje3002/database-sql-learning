# 01 — Window functions: analytics without losing detail

> **English** · [Srpski](../../docs/01-window-functions.md)

A window function calculates across related rows while keeping one output row for each input row. Unlike `GROUP BY`, it does not collapse a group into one row. That makes it right for rankings, running totals, and comparison with the previous order.

```sql
function(...) OVER (
  PARTITION BY grouping_column
  ORDER BY ordering_column
  ROWS BETWEEN ... AND ...
)
```

- `PARTITION BY` creates independent groups, for example one group per customer.
- `ORDER BY` defines sequence inside a group.
- `ROWS` or `RANGE` defines which rows participate for the current row.
- Without `PARTITION BY`, the whole result is one group.

| Function | Use | Important detail |
| --- | --- | --- |
| `ROW_NUMBER()` | unique sequence number | add a tie-breaker for stable output |
| `RANK()` | rank with gaps | `1, 1, 3` after a tie |
| `DENSE_RANK()` | rank without gaps | `1, 1, 2` after a tie |
| `LAG()` / `LEAD()` | previous / next value | avoids a manual self-join |
| `SUM()` / `AVG()` with `OVER` | running or moving calculation | use an explicit frame when it matters |
| `NTILE(n)` | approximate segments | useful for analysis, not strict rules |

For a running total, state the frame explicitly. Default frames can include tied sort values in surprising ways:

```sql
SUM(total_cents) OVER (
  PARTITION BY customer_id
  ORDER BY ordered_at, order_id
  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
) AS running_spend_cents
```

Window functions are evaluated after `WHERE` and grouping, so filter a window alias in an outer query or CTE. Build the base measure first, apply the window second, and filter last. See the [runnable lab](../../sql/01-window-functions.sql).
