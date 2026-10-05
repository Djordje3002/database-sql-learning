# Izmena podataka bez rizika

`INSERT` dodaje, `UPDATE` menja, a `DELETE` uklanja redove. Sve tri komande trajno menjaju podatke nakon potvrde transakcije.

## Bezbedan postupak

1. Napiši `SELECT` sa istim `WHERE` uslovom.
2. Proveri broj i sadržaj izabranih redova.
3. Pokreni `UPDATE` ili `DELETE` unutar transakcije.
4. Proveri rezultat i izaberi `COMMIT` ili `ROLLBACK`.

```sql
BEGIN;

UPDATE knjige
SET cena = cena * 1.10
WHERE id_izdavaca = 1;

-- Ako je rezultat dobar:
COMMIT;
-- Ako nije dobar, umesto COMMIT koristi ROLLBACK;
```

U aplikacijama obavezno koristi parametre, a nikad spajanje teksta u SQL upit. Time se sprečava SQL injection.
