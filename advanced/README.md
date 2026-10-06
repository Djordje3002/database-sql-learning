# 🚀 Advanced Database Course

> **Srpski** · [English](en/README.md)

> Praktičan nastavak osnovnog SQL kursa: od pouzdanih analitičkih upita do dizajna, performansi i bezbednosti baze u produkciji.

Ovaj deo kursa nije zbirka izolovanih komandi. Svaka lekcija rešava problem koji se javlja u stvarnoj aplikaciji za prodaju knjiga: kako pronaći najvažnije podatke, sačuvati konzistentnost porudžbine, ubrzati spor upit i zaštititi korisničke podatke.

![Apstraktan tok optimizacije upita](../assets/advanced-query-optimization.png)

## Kako se koristi

Primeri su prvenstveno napisani za **SQLite 3**. To znači da mogu odmah da se pokrenu lokalno, bez servera. U svakoj lekciji su jasno obeležene razlike za PostgreSQL i MySQL.

```bash
# Iz korena repozitorijuma
sqlite3 advanced.db < advanced/sql/00-advanced-setup.sql

# Zatim pokreni lekcije redom, nad istom bazom
sqlite3 advanced.db < advanced/sql/01-window-functions.sql
sqlite3 advanced.db < advanced/sql/02-transactions-isolation.sql
```

Ako želiš potpuno čist početak, ponovo pokreni `00-advanced-setup.sql`. Ona briše samo tabele iz **advanced** vežbe, ne osnovnu bazu iz glavnog kursa.

## Putanja kroz kurs

| Modul | Pitanje na koje odgovara | Teorija | Praktični rad |
| --- | --- | --- | --- |
| 00 | Kako izgleda radna baza? | — | [priprema baze](sql/00-advanced-setup.sql) |
| 01 | Kako računati rang, trend i kumulativni zbir bez podupita po redu? | [prozorske funkcije](docs/01-window-functions.md) | [analitika sa `OVER`](sql/01-window-functions.sql) |
| 02 | Kako više izmena postaju jedna pouzdana poslovna celina? | [transakcije i izolacija](docs/02-transactions-isolation.md) | [transakcije i `SAVEPOINT`](sql/02-transactions-isolation.sql) |
| 03 | Zašto je upit spor i koji indeks zaista pomaže? | [indeksi i plan izvršavanja](docs/03-indexes-and-explain.md) | [`EXPLAIN QUERY PLAN`](sql/03-indexes-and-explain.sql) |
| 04 | Kako šema sprečava dupliranje i greške u podacima? | [normalizacija i dizajn](docs/04-normalization-and-design.md) | [od sirovih do povezanih tabela](sql/04-normalization-and-design.sql) |
| 05 | Kada apstrahovati upit pogledom, a kada automatizovati pravilom? | [view i trigger](docs/05-views-and-triggers.md) | [izveštaj i audit trag](sql/05-views-and-triggers.sql) |
| 06 | Kako SQL ostaje otporan na zloupotrebu i bezbedan za podatke? | [bezbednost i parametri](docs/06-security-and-parameters.md) | [bezbedni obrasci](sql/06-security-and-parameters.sql) |
| 07 | Kako spojiti sve u mali, proverljiv izveštaj? | [mini-projekat](docs/07-mini-project.md) | [capstone analitika](sql/07-capstone-analytics.sql) |

## Ishodi

Po završetku možeš da:

- napišeš analitički upit sa `ROW_NUMBER`, `RANK`, `LAG` i kontrolisanim prozorskim okvirom;
- modeluješ promenu stanja kao transakciju sa jasnim granicama i mogućnošću poništavanja;
- pročitaš plan izvršavanja, napraviš odgovarajući složeni indeks i izmeriš efekat;
- razdvojiš entitete, veze i pravila integriteta bez preterane normalizacije;
- napraviš koristan `VIEW`, ograničen `TRIGGER` i proverljiv audit zapis;
- koristiš parametre, princip najmanjih privilegija i bezbedno rukuješ dinamičkim SQL-om.

## Pravilo rada: prvo razumevanje, zatim optimizacija

1. Napiši najjasniji ispravan upit.
2. Testiraj ga nad poznatim podacima i proveri granične slučajeve.
3. Pogledaj plan izvršavanja i stvarno merenje.
4. Tek tada dodaj indeks, keš ili denormalizaciju — i ponovo izmeri.

To pravilo štiti i brzinu razvoja i kvalitet podataka. Brz, ali netačan izveštaj je greška; složen indeks bez dokaza je dug za održavanje.

## Važne razlike po bazi

| Tema | SQLite | PostgreSQL | MySQL 8+ |
| --- | --- | --- | --- |
| Prozorske funkcije | podržane od 3.25 | podržane | podržane |
| Plan upita | `EXPLAIN QUERY PLAN` | `EXPLAIN (ANALYZE, BUFFERS)` | `EXPLAIN ANALYZE` |
| Prava korisnika | nema korisnike/`GRANT` u samoj datoteci | detaljne role i privilegije | korisnici i privilegije |
| Materijalizovani pogled | nema ugrađen | `MATERIALIZED VIEW` | nema ugrađen; koristi tabelu/alat |
| Pisanje paralelno | jedan writer po bazi | MVCC, više writer-a | InnoDB MVCC/zaključavanja |

Detalji nisu izgovor da se preskoči princip. Uvek proveri dokumentaciju verzije baze koju aplikacija stvarno koristi.

## Predlog ritma

Za svaku lekciju odvoji 45–90 minuta: pročitaj teoriju, pokreni primer, promeni jedan uslov, pa reši zadatak iz dokumenta bez gledanja u rešenje. Nakon svaka dva modula vrati se na ranije upite i objasni naglas *zašto* rade — ne samo šta vraćaju.

---

**Pre usklađivanja šeme sa produkcionom bazom:** napravi kopiju podataka, koristi migracije pod verzionom kontrolom i testiraj povratak unazad. Vežbe ovde su bezbedne za lokalnu radnu bazu, nisu automatski plan za produkciju.
