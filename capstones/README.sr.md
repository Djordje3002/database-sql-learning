# Portfolio projekti

> **Srpski** · [English](README.md)

Ova četiri projekta pretvaraju kurs u portfolio dokaz znanja. Svaki ima realan domen, PostgreSQL-first početnu šemu, pravila koja se ne smeju prekršiti, kriterijume završetka i ER dijagram. API ili reporting sloj radi u jeziku koji izabereš, ali migracije, seed podaci i dokaz testiranja ostaju uz projekat.

| Projekat | Domen | Glavne veštine |
| --- | --- | --- |
| [01 — Webshop](01-webshop/README.sr.md) | katalog, korpa, checkout, zaliha | transakcioni checkout, idempotentnost, plaćanja, indeksi |
| [02 — Univerzitet](02-university/README.sr.md) | predmeti, upis, ocene | preduslovi, vremenska pravila, izveštaji, RLS |
| [03 — Bankarski ledger](03-banking-ledger/README.sr.md) | računi i transferi | nepromenljiv ledger, double-entry, konkurentnost |
| [04 — Rezervacije](04-booking/README.sr.md) | sobe i rezervacije | vremenski opsezi, exclusion ograničenja, dostupnost |

## Kada je projekat gotov

- Šema dolazi kroz verzionisane migracije, ne kroz ručne produkcione izmene.
- Svaki strani ključ i česta putanja upita ima promišljeno obrazloženje indeksa.
- Seed podaci imaju srećan put i granične slučajeve.
- Promene stanja koriste transakcije i idempotentne su kada klijent može ponoviti zahtev.
- Postoji bar jedan snimljen `EXPLAIN (ANALYZE, BUFFERS)` ili razlog zašto je skup podataka premali za smislen plan.
- Osetljivi i tenant podaci imaju dokumentovanu strategiju pristupa.
- README objašnjava jedan trade-off i jednu promenu koja bi bila potrebna na 100× većem sistemu.
