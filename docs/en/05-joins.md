# JOIN: combining tables

> **English** · [Srpski](../05-join.md)

`JOIN` combines rows from two tables through a shared value, most often a primary key and a foreign key.

```sql
SELECT k.naziv, i.naziv AS izdavac
FROM knjige AS k
JOIN izdavaci AS i ON i.id = k.id_izdavaca;
```

| Type | What it returns |
| --- | --- |
| `INNER JOIN` / `JOIN` | only rows that have a match in both tables |
| `LEFT JOIN` | every row from the left table, plus matches from the right |
| `RIGHT JOIN` | the reverse of `LEFT JOIN`; not supported everywhere |
| `FULL OUTER JOIN` | every row from both tables; not supported everywhere |
| `CROSS JOIN` | every combination of rows; use rarely and deliberately |

With a `LEFT JOIN`, count `COUNT(right_table.id)`, not `COUNT(*)`, when you need zero for rows without a match.

The most common mistake is a join without `ON`: it produces a huge number of incorrect combinations.
