# Core rules and syntax

> **English** · [Srpski](../02-osnovna-pravila.md)

The usual shape of a query is:

```sql
SELECT columns
FROM table_name
WHERE condition
ORDER BY column_name ASC
LIMIT 10;
```

We write it in that order, but the database logically evaluates it in this order:

```text
FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT
```

That is why a `SELECT` alias can usually be used in `ORDER BY`, but not in `WHERE`.

## Readability conventions

- Put one idea per line: start each clause on a new line.
- Use table aliases when multiple tables appear, for example `knjige AS k`.
- Give result columns helpful names: `COUNT(*) AS number_of_books`.
- Write text with single quotes: `'Derviš i smrt'`.
- Do not quote numbers unless the column deliberately stores text.

## `DISTINCT`, `ORDER BY`, and `LIMIT`

- `DISTINCT` removes duplicate rows from a result.
- `ORDER BY` sorts the result; `ASC` is ascending and `DESC` is descending.
- `LIMIT` caps the number of returned rows. PostgreSQL, SQLite, and MySQL all support this form.

Never rely on a table's incidental order. If order matters, state it with `ORDER BY`.
