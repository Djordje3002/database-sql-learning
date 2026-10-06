# Projekat 03 — Analitika i kvalitet podataka

> Od događaja korisnika i sirovih tabela do metrika kojima možeš da veruješ.

[English version →](../en/03-analytics-quality/README.md) · [Nazad na praktikum](../README.md)

## Scenario

Tim želi da zna gde korisnici odustaju u kupovini, koji kupci donose prihod i da li podaci imaju očigledne rupe. Dobijaš događaje sa sajta i početnu bazu knjižare. Napravi analitiku koja ne meša zrno sesije, korisnika i narudžbine.

Pre rada napravi čistu bazu i učitaj podatke:

```bash
sqlite3 practice.db < sql/00-priprema-baze.sql
sqlite3 practice.db < practice/03-analitika-kvalitet/seed.sql
```

## Poslovna pravila

- Funnel se računa po `session_id`, nikada prostim brojem redova događaja.
- Prepoznat prihod dolazi samo iz `placena` i `poslata` narudžbina.
- Događaj sa nepoznatim korisnikom je dozvoljen: posetilac ne mora biti prijavljen.
- Kontrola kvaliteta vraća i nula-redova rezultat ako greška nije pronađena; i to je koristan nalaz.

## Zadaci

| # | Zahtev | Fokus |
| --- | --- | --- |
| 1 | Prikaži broj događaja i broj jedinstvenih sesija po vrsti događaja. | zrno podataka, `COUNT(DISTINCT ...)` |
| 2 | Napravi funnel: `visit` → `search` → `add_to_cart` → `checkout` → `purchase`, sa stopom prelaska iz posete u svaki sledeći korak. | uslovna agregacija, `NULLIF` |
| 3 | Segmentiraj sve kupce kao `bez prihoda`, `standard` ili `vip` na osnovu prepoznatog prihoda. | `LEFT JOIN`, `CASE`, `COALESCE` |
| 4 | Za svaku sesiju pokaži poslednji događaj i da li je dostigla kupovinu. | `ROW_NUMBER()`, CTE |
| 5 | Napravi jedan izveštaj kvaliteta koji vraća: knjige bez autora, kupce bez email-a i izdavače bez knjiga. | `UNION ALL`, jasna oznaka problema |
| 6 | Napiši upit koji pronalazi finalizovanu narudžbinu bez stavki. Objasni zašto prazan rezultat ne znači da upit nije koristan. | anti-join, integritet |

## Kriterijumi uspeha

- Funnel ima 5 poseta, 4 pretrage, 3 dodavanja u korpu, 2 checkout-a i 1 kupovinu.
- Segmentacija zadržava sve kupce, uključujući `Jelena Jovanović` sa prihodom nula.
- Izveštaj kvaliteta vraća najmanje: `Uvod u baze podataka`, `Jelena Jovanović` i `Mali princ`.
- Ne dupliraš prihod spajanjem narudžbina sa događajima.

Počni u [starteru](starter.sql), proveri kontrolne rezultate u [verify.sql](verify.sql), pa tek onda otvori [rešenje](solution.sql).
