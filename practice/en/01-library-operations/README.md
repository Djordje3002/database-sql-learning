# Project 01 — Library Operations

> Turn raw tables into a catalog that a librarian can genuinely use.

[Srpska verzija →](../../01-biblioteka-operacije/README.md) · [Back to practice](../README.md)

## Scenario

You are taking over the internal database of a small library. The librarian does not want “all the tables”; they need answers to concrete questions: which books exist, who wrote them, which publisher issued them, what is selling, and where the data is incomplete. Your job is to build reliable queries for that day-to-day work.

Work with the base schema in `sql/00-priprema-baze.sql`. This project has no additional data, and you should not change existing rows.

## Business rules

- One book belongs to one publisher and may have multiple authors.
- The book–author relationship is stored through `knjige_autori`.
- A book with no recorded author is not the same as a missing book: it must remain visible in the catalog.
- Only orders with status `placena` or `poslata` count as recognized revenue.
- Historical sales must use `stavke_narudzbine.cena_u_trenutku`, never the current catalog value in `knjige.cena`.

## Data model

```text
izdavaci 1 ───< knjige >───< knjige_autori >─── 1 autori
                         \
                          \
kupci 1 ───< narudzbine 1 ───< stavke_narudzbine >─── 1 knjige
```

## Tasks

### Required work

| # | Request | Expected output |
| --- | --- | --- |
| 1 | Browseable catalog | Book ID, title, publisher, publication year, price, and page count, sorted by title. |
| 2 | Publisher overview | Every publisher and its book count, including a publisher with no books. |
| 3 | Author completeness check | Books with no matching row in `knjige_autori`; do not hide them with an inner `JOIN`. |
| 4 | Bibliography | One row per author: full name, number of books, and book titles. Authors with no books must remain in the report. |
| 5 | Customer profile | For every customer, show total orders, finalized orders, and the date of the latest order. |
| 6 | Sales by book | Every book, units sold, and recognized revenue. Books with no sales must show zero, not `NULL`. |

### Capstone task

7. Create a view named `vw_praksa_katalog` exposing one row per book with: ID, title, publisher, year, price, and combined author names. Then write a case-insensitive search query over title, publisher, **or** author.

You may recreate the view with `DROP VIEW IF EXISTS vw_praksa_katalog`; do not modify the base tables.

### Stretch task

8. Write one data-quality query that returns both books without authors and publishers without books, with a column that clearly labels the issue type. Use `UNION ALL` only when you intentionally want to retain every detected item.

## Success criteria

- The catalog contains all 7 books in the base database.
- The publisher overview includes `Mali princ` with a count of `0`.
- The author-completeness check returns `Uvod u baze podataka`.
- Sales by book does not emit `NULL` for units or revenue.
- Revenue excludes the `nova` order; the base-data control total is **4,995.00**.
- Grouped reports use a stable ID alongside any displayed text where appropriate.

## Workflow

```bash
sqlite3 practice.db < sql/00-priprema-baze.sql
sqlite3 practice.db
```

Then, in the SQLite shell:

```sql
.read practice/01-biblioteka-operacije/starter.sql
-- write your attempts below each task or in a separate .sql file
.read practice/01-biblioteka-operacije/verify.sql
```

After you finish, open the shared [solution](../../01-biblioteka-operacije/solution.sql) and compare the **reasoning**: is the grain the same, did you preserve rows without related data, and is the status filter in the correct place?

## Review questions

- Why does `COUNT(k.id_knjige)` work with a `LEFT JOIN`, while `COUNT(*)` would not return zero for a publisher without books?
- Why should you not blindly put `WHERE n.status IN (...)` after a `LEFT JOIN` when you want to retain customers with no orders?
- What changes if a book has three authors and you aggregate sales immediately after joining `knjige_autori`?

Those details matter more than memorizing syntax: they prevent silent reporting errors.
