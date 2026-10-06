# Table design, indexes, and performance

> **English** · [Srpski](../08-dizajn-i-performanse.md)

## Design rules

- Every table has one clear subject: books are not publishers.
- Every row has a primary key.
- Store relationships with foreign keys, not by copying names into every row.
- Choose the right type: a number as a number, a date as a date, an amount as a decimal.
- Add `NOT NULL`, `UNIQUE`, `CHECK`, and `DEFAULT` when a business rule requires them.

## Indexes

An index speeds up finding rows, especially for columns commonly used in `WHERE`, `JOIN`, and `ORDER BY`. But an index uses storage and slows `INSERT`, `UPDATE`, and `DELETE`; never add one blindly.

A useful starting point is an index on a foreign key, such as `knjige(id_izdavaca)`. Measure before optimizing and inspect the execution plan with `EXPLAIN` or `EXPLAIN ANALYZE`, depending on the database.
