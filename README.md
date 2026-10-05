# 🗃️ Database SQL Learning

> Uređen, praktičan kurs SQL-a na srpskom jeziku — od prvog `SELECT` upita do dobrog dizajna baze i optimizacije.

Ovaj repozitorijum je naša zbirka znanja za celu godinu. Svaka tema ima kratku teoriju, komentarisane upite i bazu za bezbedno vežbanje. Novi zadaci se dodaju redom, tako da se gradivo lako ponavlja.

## Počni ovde

1. Pročitaj [plan učenja](docs/00-plan-ucenja.md).
2. Učitaj primer baze iz [00-priprema-baze.sql](sql/00-priprema-baze.sql).
3. Otvaraj lekcije po redosledu brojeva i pokreći upite jedan po jedan.

Za najlakši početak preporučen je **SQLite**: ne traži server i odličan je za učenje. Primeri su pretežno standardni SQL; tamo gde se PostgreSQL, MySQL i SQLite razlikuju, to je označeno.

```bash
sqlite3 biblioteka.db < sql/00-priprema-baze.sql
sqlite3 biblioteka.db
```

U SQLite konzoli zatim nalepi bilo koji upit iz datoteka `sql/`.

## Mapa gradiva

| Celina | Tema | Teorija | Primeri |
| --- | --- | --- | --- |
| 00 | Podešavanje radne baze | [baza i model](docs/01-baza-i-model.md) | [priprema](sql/00-priprema-baze.sql) |
| 01 | Čitanje podataka | [pravila i sintaksa](docs/02-osnovna-pravila.md) | [SELECT](sql/01-citanje-podataka.sql) |
| 02 | Uslovi i vrednosti | [operatori i NULL](docs/03-uslovi-i-null.md) | [WHERE](sql/02-uslovi-i-null.sql) |
| 03 | Funkcije i agregacije | [vodič za funkcije](docs/04-funkcije-i-agregacije.md) | [funkcije](sql/03-funkcije-i-agregacije.sql) |
| 04 | Spajanje tabela | [JOIN vodič](docs/05-join.md) | [JOIN](sql/04-join.sql) |
| 05 | Naprednije čitanje | [podupiti i CTE](docs/06-podupiti-i-cte.md) | [podupiti](sql/05-podupiti-i-cte.sql) |
| 06 | Izmena podataka | [DML pravila](docs/07-izmena-podataka.md) | [DML vežbe](sql/06-izmena-podataka.sql) |
| 07 | Dizajn i kvalitet | [DDL, ključevi, indeksi](docs/08-dizajn-i-performanse.md) | [šema](sql/07-dizajn-tabela.sql) |

## Pravila rada

- Svaki upit se završava znakom `;`.
- Pišemo ključne reči velikim slovima (`SELECT`, `FROM`, `WHERE`), a nazive tabela i kolona malim slovima. Baza ne zahteva ovo pravilo, ali čini kod čitljivim.
- Pre `UPDATE` i `DELETE` prvo napiši isti uslov kao `SELECT` i proveri koje redove biraš.
- Ne koristi `SELECT *` u stvarnom programu; navedi kolone koje su zaista potrebne.
- Nikada ne sastavljaj SQL spajanjem korisničkog unosa u tekst upita. U aplikaciji se koriste parametrizovani upiti.

## Kako izgleda jedna lekcija

```
docs/  → zašto i kada se nešto koristi
sql/   → upiti koje možeš odmah da pokreneš
```

Primeri koriste temu biblioteke: `knjige`, `autori`, `izdavaci`, `kupci` i `narudzbine`. To nam omogućava da nove zadatke rešavamo na poznatim tabelama, a kasnije ćemo dodavati zadatke, rešenja i mini-projekte.

## Beleške o dijalektima

SQL ima više varijanti. Osnovna pravila su ista, ali funkcije za datum, automatsko generisanje ID-a i ograničavanje broja redova se ponekad razlikuju. U ovom repozitorijumu je SQLite baza za vežbanje; napomene u lekcijama pokazuju PostgreSQL i MySQL ekvivalente.

---

**Sledeće:** pošalji novi zadatak ili temu, a dodaćemo je kao sledeću lekciju sa objašnjenjem i primerom.
