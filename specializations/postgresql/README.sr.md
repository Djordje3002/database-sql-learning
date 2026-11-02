# PostgreSQL staza

> **Srpski** · [English](README.md)

Ovo je PostgreSQL 16+ specijalizacija za učenike koji su završili SQL osnove. Pokriva delove koji se ne prenose direktno iz SQLite-a: stroge tipove, `JSONB`, funkcije i procedure, Row-Level Security, planove upita, parcijalne/pokrivne indekse, full-text pretragu i ponašanje konekcija.

## Pokretanje

Napravi praznu lokalnu bazu, pa redom pokreni laboratorijske vežbe:

```bash
createdb sql_learning_pg
psql -d sql_learning_pg -f sql/00-postgresql-schema.sql
psql -d sql_learning_pg -f sql/01-functions-and-procedures.sql
psql -d sql_learning_pg -f sql/02-row-level-security.sql
psql -d sql_learning_pg -f sql/03-performance-and-indexes.sql
psql -d sql_learning_pg -f sql/04-jsonb-and-search.sql
```

RLS vežba pravi demonstracione role bez prijave; pokreći je samo nad lokalnom, potrošnom bazom koju poseduješ. Reset skripte nikada ne pokreći nad produkcionim podacima.

## Moduli

| # | Tema | Šta učiš | Vežba |
| --- | --- | --- | --- |
| 00 | PostgreSQL šema | `bigint` identity ključevi, `timestamptz`, `numeric`, ograničenja i FK indeksi | [šema](sql/00-postgresql-schema.sql) |
| 01 | Funkcije i procedure | `plpgsql`, `RETURNING`, validacija i jasne granice transakcije | [vežba](sql/01-functions-and-procedures.sql) |
| 02 | Multi-tenant bezbednost | role sa minimalnim pravima, RLS i bezbedan session context | [RLS](sql/02-row-level-security.sql) |
| 03 | Dokaz performansi | `EXPLAIN (ANALYZE, BUFFERS)`, složeni, parcijalni i pokrivni indeksi | [performanse](sql/03-performance-and-indexes.sql) |
| 04 | Fleksibilni podaci | `JSONB`, GIN/expression indeksi i full-text pretraga | [JSONB/pretraga](sql/04-jsonb-and-search.sql) |

## Pravila za produkciju

- Za trajne ID-jeve koristi `bigint GENERATED ... AS IDENTITY`, za vreme događaja `timestamptz`, a za novac `numeric` ili najmanju celobrojnu jedinicu.
- PostgreSQL ne pravi indeks automatski nad stranim ključem; dodaj ga kada JOIN, brisanje ili `CASCADE` treba da skaliraju.
- Indeks dodaj zbog posmatranog upita, pa proveri efekat kroz `EXPLAIN (ANALYZE, BUFFERS)` nad realističnim podacima.
- U složenom B-tree indeksu jednakosti dolaze pre raspona ili sortiranja. Predikat parcijalnog indeksa mora odgovarati upitu.
- Aplikacija koristi pooler; ne otvara novu PostgreSQL konekciju za svaki zahtev. Transakcije neka budu kratke, bez HTTP poziva dok drže lock.
- RLS je granica koju sprovodi baza, ali ne zamenjuje autorizaciju u aplikaciji. Indeksiraj kolone iz policy-ja, a odsutan tenant kontekst neka znači zabranu pristupa.

`SECURITY DEFINER` funkcije i RLS policy-ji zahtevaju code review. Izvršive SQL datoteke imaju dvojezične komentare; ovu stazu prati uz [osnove](../../docs/README.md) i [Advanced Database Course](../../advanced/README.md).
