# Database and data model

> **English** · [Srpski](../01-baza-i-model.md)

A relational database stores data in tables. Each row is one record; each column describes one property of that record.

| Term | Meaning | Example |
| --- | --- | --- |
| table | a collection of similar records | `knjige` (books) |
| row | one record | one book |
| column | a record property | `naziv`, `cena` |
| primary key | a unique row identifier | `knjige.id_knjige` |
| foreign key | a relationship to another table | `knjige.id_izdavaca` |

## Our model

```text
izdavaci 1 ───< knjige >───< knjige_autori >─── 1 autori
kupci    1 ───< narudzbine 1 ───< stavke_narudzbine >─── 1 knjige
```

`1 ───<` means “one to many.” One publisher can have many books; in this simplified model, each book belongs to one publisher.

## Data integrity

Keys and constraints are not decoration: they prevent invalid data. A foreign key can reject a book whose publisher does not exist, while `CHECK (cena >= 0)` can reject a negative price.
