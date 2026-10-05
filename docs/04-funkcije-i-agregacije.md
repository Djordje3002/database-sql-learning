# Funkcije i agregacije

Funkcija prima vrednost i vraća novu vrednost. Agregatna funkcija sabira više redova u jedan rezultat.

## Česte funkcije po redovima

| Vrsta | Funkcije | Primer |
| --- | --- | --- |
| tekst | `UPPER`, `LOWER`, `LENGTH`, `TRIM`, `SUBSTR` | `UPPER(naziv)` |
| brojevi | `ROUND`, `ABS`, `COALESCE` | `ROUND(cena, 2)` |
| logika | `CASE`, `COALESCE`, `NULLIF` | `COALESCE(email, 'nije unet')` |
| datum | zavisi od baze | pogledaj napomenu ispod |

## Agregatne funkcije

| Funkcija | Rezultat |
| --- | --- |
| `COUNT(*)` | broj svih redova |
| `COUNT(kolona)` | broj redova gde kolona nije `NULL` |
| `SUM(kolona)` | zbir |
| `AVG(kolona)` | prosek |
| `MIN(kolona)` / `MAX(kolona)` | najmanja / najveća vrednost |

`GROUP BY` deli redove na grupe, a zatim računa agregate unutar svake grupe. `WHERE` filtrira redove **pre** grupisanja; `HAVING` filtrira grupe **posle** grupisanja.

```sql
SELECT id_izdavaca, COUNT(*) AS broj_knjiga
FROM knjige
WHERE cena IS NOT NULL
GROUP BY id_izdavaca
HAVING COUNT(*) >= 2;
```

## Funkcije za datum

Ovo je najčešća razlika između baza:

| Zadatak | PostgreSQL | MySQL | SQLite |
| --- | --- | --- | --- |
| današnji datum | `CURRENT_DATE` | `CURRENT_DATE` | `date('now')` |
| godina iz datuma | `EXTRACT(YEAR FROM d)` | `YEAR(d)` | `strftime('%Y', d)` |
| dodaj 7 dana | `d + INTERVAL '7 days'` | `DATE_ADD(d, INTERVAL 7 DAY)` | `date(d, '+7 days')` |

`CURRENT_DATE` je prenosiv izbor kad ti treba samo tekući datum.
