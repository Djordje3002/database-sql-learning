# Podupiti, CTE i skupovi

> **Srpski** · [English](en/06-subqueries-and-ctes.md)

Podupit je `SELECT` unutar drugog upita. Koristi se kada odgovor jednog pitanja treba drugom pitanju.

```sql
SELECT naziv, cena
FROM knjige
WHERE cena > (SELECT AVG(cena) FROM knjige);
```

CTE (`WITH`) je imenovani privremeni rezultat unutar jednog upita. Čini složen upit čitljivijim:

```sql
WITH prodaja_po_knjizi AS (
  SELECT id_knjige, SUM(kolicina) AS ukupno
  FROM stavke_narudzbine
  GROUP BY id_knjige
)
SELECT *
FROM prodaja_po_knjizi;
```

`UNION` spaja rezultate istog oblika i uklanja duplikate; `UNION ALL` zadržava sve redove i obično je brži. `INTERSECT` zadržava zajedničke redove, a `EXCEPT` oduzima redove (podrška zavisi od baze).
