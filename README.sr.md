# Database SQL Learning

<p align="center">
  <img src="assets/database-learning-hero.png" alt="Apstraktne relacionе tabele povezane svetlećim linijama" width="100%" />
</p>

<p align="center">
  Praktičan, dvojezičan kurs baza podataka — od prvog <code>SELECT</code> upita do planova izvršavanja, transakcija i ozbiljnog dizajna.
</p>

<p align="center">
  <strong>Srpski</strong> · <a href="README.md">English</a>
</p>

## Zašto postoji ovaj repozitorijum

Ovo je dugoročni prostor za učenje, a ne nepovezana zbirka upita. Svaka tema kombinuje sažetu teoriju, SQL koji možeš odmah da pokreneš i realističan model biblioteke i prodavnice knjiga. Redosled je nameran: najpre naučiš pitanje, zatim sintaksu, pa kako da odgovor bude bezbedan i brz.

## Počni ovde

1. Pročitaj [plan učenja](docs/00-plan-ucenja.md).
2. Učitaj radnu bazu iz [00-priprema-baze.sql](sql/00-priprema-baze.sql).
3. Otvaraj lekcije po redosledu brojeva i ručno pokreći svaki upit.

Za početak je preporučen SQLite jer ne traži server. Primeri koriste prenosiv SQL gde god je moguće, uz jasne napomene za PostgreSQL, MySQL i SQLite razlike.

```bash
sqlite3 biblioteka.db < sql/00-priprema-baze.sql
sqlite3 biblioteka.db
```

Zatim nalepi upit iz `sql/` datoteka u SQLite konzolu.

## Gradivo

### Osnove

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

### Advanced Database Course

[Napredni kurs baza](advanced/README.md) pretvara osnove u ozbiljne veštine: prozorske funkcije, transakcije i izolacija, optimizacija upita, view/trigger, dizajn modela i bezbednost.

### Praktikum

[Praktikum](practice/README.md) sadrži projekte i zadatke rastuće težine. Prvo rešavaš realan problem iz izveštavanja, kvaliteta podataka ili analitike, pa tek onda čitaš rešenje.

## Šta ćeš znati

- Da napišeš ispravne, čitljive upite nad povezanim tabelama.
- Da razumeš `NULL`, agregacije, duplikate i kardinalnost.
- Da modeluješ veze ključevima i ograničenjima.
- Da bezbedno menjaš podatke kroz transakcije.
- Da pročitaš plan izvršavanja, smisleno izabereš indeks i izbegneš česte probleme sa performansama.
- Da u aplikaciji koristiš parametrizovane upite umesto spajanja teksta.

## Struktura

```text
docs/          Teorija osnova na srpskom
docs/en/       Teorija osnova na engleskom
sql/           Zajednički, izvršivi SQLite-first primeri
advanced/      Advanced kurs: teorija i laboratorijske vežbe
practice/      Projektni zadaci, izazovi i rešenja
resources/     Referentni materijal i cheat sheet
assets/        Originalni vizuali kursa
```

## Pravila rada

- Svaki SQL iskaz se završava sa `;`.
- Pišemo ključne reči velikim slovima, a opisne nazive malim slovima.
- Pre `UPDATE` i `DELETE` prvo pokreni isti uslov kao `SELECT`.
- U aplikaciji nikada ne spajaj korisnički unos u SQL tekst: koristi parametre.
- `SELECT *` je dobar za istraživanje, ali ne i kao navika u produkcionom kodu.

## Jezici

Osnovna teorija postoji paralelno na srpskom i engleskom. SQL je zajednički jer su SQL ključne reči univerzalne; komentari su kratki i jasni. Veće celine kursa međusobno povezuju odgovarajuće jezičke verzije.

## Dodavanje novih lekcija

Pogledaj [CONTRIBUTING.md](CONTRIBUTING.md) za pravila imenovanja, prevoda, testiranja i kvaliteta pri dodavanju sledeće lekcije, zadatka ili projekta.

---

Kurs raste kroz dobro objašnjene probleme. Pošalji sledeći zadatak kada budeš spreman.
