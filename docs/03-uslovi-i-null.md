# Uslovi, operatori i NULL

`WHERE` bira redove pre prikaza ili računanja. Uslovi mogu da koriste:

| Namena | Primer |
| --- | --- |
| poređenje | `cena >= 1000` |
| više uslova | `godina >= 2020 AND cena < 2000` |
| izbor iz liste | `id IN (1, 3, 5)` |
| opseg | `cena BETWEEN 500 AND 1500` |
| obrazac | `naziv LIKE 'SQL%'` |
| nedostajuća vrednost | `email IS NULL` |

## Važno: `NULL` nije prazno niti nula

`NULL` znači da vrednost nije poznata ili nije primenljiva. Zato je `kolona = NULL` pogrešno — rezultat nije tačan ni netačan, već nepoznat. Koristi `IS NULL` ili `IS NOT NULL`.

Kod složenih uslova koristi zagrade kada želiš da ukloniš svaku dilemu:

```sql
WHERE (cena < 1000 OR cena IS NULL)
  AND godina_izdanja >= 2020;
```
