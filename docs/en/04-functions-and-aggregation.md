# Functions and aggregation

> **English** · [Srpski](../04-funkcije-i-agregacije.md)

A scalar function takes a value and returns a value. An aggregate function summarizes many rows into one result.

## Common scalar functions

| Category | Functions | Example |
| --- | --- | --- |
| text | `UPPER`, `LOWER`, `LENGTH`, `TRIM`, `SUBSTR` | `UPPER(naziv)` |
| numbers | `ROUND`, `ABS`, `COALESCE` | `ROUND(cena, 2)` |
| logic | `CASE`, `COALESCE`, `NULLIF` | `COALESCE(email, 'not supplied')` |
| dates | database-specific | see the note below |

## Aggregate functions

| Function | Result |
| --- | --- |
| `COUNT(*)` | number of all rows |
| `COUNT(column)` | number of rows where the column is not `NULL` |
| `SUM(column)` | total |
| `AVG(column)` | average |
| `MIN(column)` / `MAX(column)` | smallest / largest value |

`GROUP BY` divides rows into groups and then calculates aggregates inside each group. `WHERE` filters rows **before** grouping; `HAVING` filters groups **after** grouping.

```sql
SELECT id_izdavaca, COUNT(*) AS broj_knjiga
FROM knjige
WHERE cena IS NOT NULL
GROUP BY id_izdavaca
HAVING COUNT(*) >= 2;
```

## Date functions

This is one of the most frequent dialect differences:

| Task | PostgreSQL | MySQL | SQLite |
| --- | --- | --- | --- |
| today's date | `CURRENT_DATE` | `CURRENT_DATE` | `date('now')` |
| year from a date | `EXTRACT(YEAR FROM d)` | `YEAR(d)` | `strftime('%Y', d)` |
| add 7 days | `d + INTERVAL '7 days'` | `DATE_ADD(d, INTERVAL 7 DAY)` | `date(d, '+7 days')` |

`CURRENT_DATE` is a portable choice when you only need the current date.
