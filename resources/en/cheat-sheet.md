# SQL Cheat Sheet

[Srpski](../cheat-sheet.md) | [English](cheat-sheet.md)

A quick reference for this SQL course. The examples use the SQLite database from [the setup script](../../sql/00-priprema-baze.sql), while the basic query shapes also transfer to PostgreSQL and MySQL. Follow the links to the full lessons for the *why* behind each choice; this document is a reference, not a replacement for them.

> Readability rule: write SQL keywords in uppercase and table/column names in lowercase. End every statement with `;`.

## 1. How SQL “thinks”

You write a query in this order:

```sql
SELECT ...
FROM ...
JOIN ... ON ...
WHERE ...
GROUP BY ...
HAVING ...
ORDER BY ...
LIMIT ...;
```

The database processes it approximately in this order:

```text
FROM / JOIN → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT
```

That is why, for example, a `SELECT` alias usually cannot be used in `WHERE`, but can be used in `ORDER BY`. Full explanation (in Serbian): [syntax and readability](../../docs/02-osnovna-pravila.md).

## 2. Reading data

```sql
-- List exactly the columns you need
SELECT naziv, godina_izdanja
FROM knjige;

-- Alias a column or a table
SELECT k.naziv AS naslov
FROM knjige AS k;

-- Return unique values
SELECT DISTINCT id_izdavaca
FROM knjige;
```

Use `SELECT *` only for quick exploration of a known table. In application code, list the exact columns you need. Practice with [basic reading queries](../../sql/01-citanje-podataka.sql) (Serbian).

## 3. Filtering: `WHERE`

```sql
SELECT naziv, cena
FROM knjige
WHERE cena >= 1000
  AND id_izdavaca IN (1, 2)
  AND godina_izdanja BETWEEN 2020 AND 2025;
```

| Need | Shape |
| --- | --- |
| equal / not equal | `=`, `!=`, or `<>` |
| compare values | `>`, `>=`, `<`, `<=` |
| both conditions | `AND` |
| either condition | `OR` |
| set of values | `IN ('A', 'B')` |
| inclusive range | `BETWEEN 10 AND 20` |
| text pattern | `LIKE 'Ana%'`, `LIKE '%SQL%'` |
| missing value | `IS NULL`, `IS NOT NULL` |

`NULL` is neither an empty string nor zero. Therefore `column = NULL` is wrong; write `column IS NULL`. Add parentheses to a complex condition whenever they make precedence unambiguous.

Full lesson (Serbian): [conditions and `NULL`](../../docs/03-uslovi-i-null.md), with [runnable queries](../../sql/02-uslovi-i-null.sql).

## 4. Sorting, limiting, and pages

```sql
SELECT naziv, cena
FROM knjige
ORDER BY cena DESC, naziv ASC
LIMIT 10 OFFSET 20;
```

- `ASC` means ascending and is the default; `DESC` means descending.
- Add a stable secondary criterion (for example `id_knjige`) when the primary criterion can tie.
- `LIMIT 10 OFFSET 20` skips the first 20 rows and returns the next 10. For large tables, investigate keyset pagination later: a large `OFFSET` can be slow.

## 5. Functions and calculated fields

```sql
SELECT
  UPPER(naziv) AS naziv_velikim_slovima,
  ROUND(cena * 1.10, 2) AS cena_sa_porezom,
  COALESCE(cena, 0) AS cena_za_prikaz
FROM knjige;
```

| Kind | Common examples |
| --- | --- |
| text | `UPPER()`, `LOWER()`, `TRIM()`, `LENGTH()` |
| numeric | `ROUND()`, `ABS()` |
| missing value | `COALESCE(column, replacement)` |
| conditional logic | `CASE WHEN condition THEN value ELSE value END` |

Date functions vary most across SQLite, PostgreSQL, and MySQL. Check the lesson for the dialect you are using: [functions and aggregates](../../docs/04-funkcije-i-agregacije.md) (Serbian).

## 6. Aggregates: counting and grouping

```sql
SELECT
  id_izdavaca,
  COUNT(*) AS broj_redova,
  COUNT(cena) AS broj_poznatih_cena,
  ROUND(AVG(cena), 2) AS prosecna_cena
FROM knjige
GROUP BY id_izdavaca
HAVING COUNT(*) >= 3
ORDER BY broj_redova DESC;
```

- `COUNT(*)` counts every row in a group.
- `COUNT(column)` excludes rows where that column is `NULL`.
- `SUM`, `AVG`, `MIN`, and `MAX` operate on values; check how `NULL` affects the result.
- Every selected column that is not aggregated must appear in `GROUP BY`.
- `WHERE` filters rows **before** grouping; `HAVING` filters groups **after** grouping.

More practice: [aggregates](../../sql/03-funkcije-i-agregacije.sql) (Serbian).

## 7. Combining tables: `JOIN`

```sql
-- Only rows that have a match on both sides
SELECT k.naziv, i.naziv AS izdavac
FROM knjige AS k
INNER JOIN izdavaci AS i ON i.id = k.id_izdavaca;

-- Keep every book, even if its publisher is missing
SELECT k.naziv, i.naziv AS izdavac
FROM knjige AS k
LEFT JOIN izdavaci AS i ON i.id = k.id_izdavaca;
```

| `JOIN` | Result |
| --- | --- |
| `INNER JOIN` | only rows with a match in both tables |
| `LEFT JOIN` | every row from the left table plus matching rows from the right |

Be deliberate about conditions on the right table in a `LEFT JOIN`. A `WHERE` condition that requires a value from the right table can accidentally turn the result into an `INNER JOIN`; often that condition belongs in `ON` instead.

Details: [`JOIN` guide](../../docs/05-join.md) and [examples](../../sql/04-join.sql) (Serbian).

## 8. Subqueries, CTEs, and sets

```sql
-- A CTE names an intermediate result
WITH prosecne_cene AS (
  SELECT id_izdavaca, AVG(cena) AS prosek
  FROM knjige
  GROUP BY id_izdavaca
)
SELECT *
FROM prosecne_cene
WHERE prosek > 1000;

-- Does a related row exist?
SELECT naziv
FROM izdavaci AS i
WHERE EXISTS (
  SELECT 1
  FROM knjige AS k
  WHERE k.id_izdavaca = i.id
);
```

- A subquery can return one value, one column/a set, or act as a condition via `EXISTS`.
- A CTE starts with `WITH`; use it to split a long query into named steps.
- `UNION` removes duplicates; `UNION ALL` retains them and is usually faster.

Continue with [subqueries and CTEs](../../docs/06-podupiti-i-cte.md) (Serbian).

## 9. Changing data safely

```sql
-- 1. Inspect the exact rows first
SELECT id_knjige, naziv, cena
FROM knjige
WHERE id_knjige = 1;

-- 2. Then change that same set
UPDATE knjige
SET cena = 1299
WHERE id_knjige = 1;
```

| Statement | Use it for |
| --- | --- |
| `INSERT INTO ... VALUES ...` | creating a new row |
| `UPDATE ... SET ... WHERE ...` | changing existing rows |
| `DELETE FROM ... WHERE ...` | removing existing rows |
| `BEGIN` / `COMMIT` / `ROLLBACK` | confirming or undoing a group of changes |

Before `UPDATE` or `DELETE`, run the same `WHERE` as a `SELECT`. When testing several changes, use a transaction and commit only after reviewing the result. Never run `UPDATE` or `DELETE` without `WHERE` unless modifying every row is explicitly intended.

Guide: [safe data changes](../../docs/07-izmena-podataka.md) and [DML exercises](../../sql/06-izmena-podataka.sql) (Serbian).

## 10. Design, data quality, and speed

```sql
CREATE TABLE primer (
  id INTEGER PRIMARY KEY,
  naziv TEXT NOT NULL,
  kod TEXT UNIQUE,
  roditelj_id INTEGER,
  FOREIGN KEY (roditelj_id) REFERENCES roditelj(id)
);
```

- A `PRIMARY KEY` uniquely identifies a row.
- A `FOREIGN KEY` protects a relationship between tables.
- `NOT NULL`, `UNIQUE`, `CHECK`, and defaults protect data quality in the database itself.
- An index speeds up particular reads but slows writes and consumes space. Add one based on real `WHERE`, `JOIN`, and `ORDER BY` patterns—not automatically to every column.
- For an unexpectedly slow query, inspect its execution plan (`EXPLAIN` or `EXPLAIN QUERY PLAN`, depending on the database).

Details: [design and performance](../../docs/08-dizajn-i-performanse.md) and [the practice schema](../../sql/07-dizajn-tabela.sql) (Serbian).

## 11. Security and a quick quality check

Before a query reaches an application or an important report, check:

- Are required columns named explicitly rather than using `SELECT *`?
- Is every `JOIN` condition present, and are there accidental duplicate rows from an incorrect relationship?
- Does the query handle `NULL` deliberately with `IS NULL`, `COALESCE`, or a stated rule?
- Is the aggregate result grouped by every necessary column?
- Was every `UPDATE`/`DELETE` reviewed first with the equivalent `SELECT`?
- Does application code use parameterized queries rather than concatenating user input into SQL text?
- Do test data cover: no related row, several related rows, `NULL`, a duplicate, and a boundary value?

## Quick navigation

| I want to… | Open |
| --- | --- |
| understand the library model | [database and model](../../docs/01-baza-i-model.md) (Serbian) |
| write my first `SELECT` | [reading data](../../sql/01-citanje-podataka.sql) (Serbian) |
| solve conditions or `NULL` | [conditions and `NULL`](../../docs/03-uslovi-i-null.md) (Serbian) |
| add up or count data | [functions and aggregates](../../docs/04-funkcije-i-agregacije.md) (Serbian) |
| connect two or more tables | [`JOIN` examples](../../sql/04-join.sql) (Serbian) |
| split a complex query into steps | [subqueries and CTEs](../../docs/06-podupiti-i-cte.md) (Serbian) |
| modify data safely | [DML guide](../../docs/07-izmena-podataka.md) (Serbian) |
| add a lesson or exercise | [contribution guide](../../CONTRIBUTING.en.md) |
