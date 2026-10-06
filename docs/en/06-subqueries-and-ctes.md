# Subqueries, CTEs, and sets

> **English** · [Srpski](../06-podupiti-i-cte.md)

A subquery is a `SELECT` inside another query. Use it when the answer to one question feeds another question.

```sql
SELECT naziv, cena
FROM knjige
WHERE cena > (SELECT AVG(cena) FROM knjige);
```

A CTE (`WITH`) is a named temporary result within one query. It makes a complex query easier to read:

```sql
WITH prodaja_po_knjizi AS (
  SELECT id_knjige, SUM(kolicina) AS ukupno
  FROM stavke_narudzbine
  GROUP BY id_knjige
)
SELECT *
FROM prodaja_po_knjizi;
```

`UNION` combines compatible results and removes duplicates; `UNION ALL` keeps every row and is usually faster. `INTERSECT` keeps common rows, while `EXCEPT` removes rows (support depends on the database).
