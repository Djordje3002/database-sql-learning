# Changing data safely

> **English** · [Srpski](../07-izmena-podataka.md)

`INSERT` adds rows, `UPDATE` changes rows, and `DELETE` removes rows. After a transaction is committed, all three make persistent changes.

## A safe workflow

1. Write a `SELECT` with the same `WHERE` condition.
2. Check the number and content of the selected rows.
3. Run `UPDATE` or `DELETE` inside a transaction.
4. Check the result and choose `COMMIT` or `ROLLBACK`.

```sql
BEGIN;

UPDATE knjige
SET cena = cena * 1.10
WHERE id_izdavaca = 1;

-- If the result is right:
COMMIT;
-- If it is not, use ROLLBACK instead of COMMIT.
```

In applications, always use parameters; never build an SQL statement by concatenating text. This prevents SQL injection.
