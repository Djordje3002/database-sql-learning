# SQL Cheat Sheet

[Srpski](cheat-sheet.md) | [English](en/cheat-sheet.md)

Brzi podsetnik za SQL kurs. Primeri su pisani za SQLite bazu iz [pripreme baze](../sql/00-priprema-baze.sql), ali su osnovni oblici prenosivi na PostgreSQL i MySQL. Za objašnjenje *zašto* se nešto koristi, prati linkove ka punim lekcijama — ova datoteka nije zamena za njih.

> Pravilo čitljivosti: ključne reči piši velikim slovima, a tabele i kolone malim slovima. Svaki upit završava se sa `;`.

## 1. Kako SQL „razmišlja“

Upit se piše ovim redom:

```sql
SELECT ...
FROM ...
JOIN ... ON ...
WHERE ...
GROUP BY ...
HAVING ...
ORDER BY ...
LIMIT ...;
```

Ali ga baza približno obrađuje ovim redom:

```text
FROM / JOIN → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT
```

To objašnjava, na primer, zašto alias iz `SELECT` najčešće ne možeš koristiti u `WHERE`, ali možeš u `ORDER BY`. Više o osnovnoj sintaksi: [pravila i čitljivost](../docs/02-osnovna-pravila.md).

## 2. Čitanje podataka

```sql
-- Tačno navedene kolone
SELECT naziv, godina_izdanja
FROM knjige;

-- Alias kolone ili tabele
SELECT k.naziv AS naslov
FROM knjige AS k;

-- Jedinstvene vrednosti
SELECT DISTINCT id_izdavaca
FROM knjige;
```

Koristi `SELECT *` samo za kratko istraživanje poznate tabele. U stvarnom kodu navedi samo kolone koje su ti potrebne. Vežbaj u [osnovnim upitima](../sql/01-citanje-podataka.sql).

## 3. Filtriranje: `WHERE`

```sql
SELECT naziv, cena
FROM knjige
WHERE cena >= 1000
  AND id_izdavaca IN (1, 2)
  AND godina_izdanja BETWEEN 2020 AND 2025;
```

| Potreba | Oblik |
| --- | --- |
| jednako / različito | `=`, `!=` ili `<>` |
| poređenje | `>`, `>=`, `<`, `<=` |
| oba uslova | `AND` |
| makar jedan uslov | `OR` |
| skup vrednosti | `IN ('A', 'B')` |
| opseg, uključujući granice | `BETWEEN 10 AND 20` |
| obrazac teksta | `LIKE 'Ana%'`, `LIKE '%SQL%'` |
| nedostajuća vrednost | `IS NULL`, `IS NOT NULL` |

`NULL` nije ni prazan tekst ni nula. Zato je `kolona = NULL` pogrešno; piši `kolona IS NULL`. Kod složenih uslova dodaj zagrade kada god mogu da uklone dilemu.

Puna obrada: [uslovi i `NULL`](../docs/03-uslovi-i-null.md) i [upiti za vežbu](../sql/02-uslovi-i-null.sql).

## 4. Redosled, ograničenje i stranice

```sql
SELECT naziv, cena
FROM knjige
ORDER BY cena DESC, naziv ASC
LIMIT 10 OFFSET 20;
```

- `ASC` je rastući redosled i podrazumevan je; `DESC` je opadajući.
- Uvek dodaj stabilan drugi kriterijum (na primer `id_knjige`) kada rezultat može imati isti prvi kriterijum.
- `LIMIT 10 OFFSET 20` preskače prvih 20 i uzima sledećih 10 redova. Za velike tabele kasnije istraži paginaciju po ključu, jer veliki `OFFSET` ume da bude spor.

## 5. Funkcije i izračunata polja

```sql
SELECT
  UPPER(naziv) AS naziv_velikim_slovima,
  ROUND(cena * 1.10, 2) AS cena_sa_porezom,
  COALESCE(cena, 0) AS cena_za_prikaz
FROM knjige;
```

| Vrsta | Česti primeri |
| --- | --- |
| tekst | `UPPER()`, `LOWER()`, `TRIM()`, `LENGTH()` |
| brojevi | `ROUND()`, `ABS()` |
| nedostajuća vrednost | `COALESCE(kolona, zamena)` |
| grananje | `CASE WHEN uslov THEN vrednost ELSE vrednost END` |

Funkcije za datume se najviše razlikuju između SQLite-a, PostgreSQL-a i MySQL-a. Zato prvo proveri lekciju za dijalekt koji koristiš: [funkcije i agregacije](../docs/04-funkcije-i-agregacije.md).

## 6. Agregacije: brojanje i grupisanje

```sql
SELECT
  id_izdavaca,
  COUNT(*) AS broj_redova,
  COUNT(cena) AS broj_poznatih_cena,
  ROUND(AVG(cena), 2) AS prosecna_cena
FROM knjige
GROUP BY id_izdavaca
HAVING COUNT(*) >= 3
ORDER BY broj_redova DESC;
```

- `COUNT(*)` broji sve redove u grupi.
- `COUNT(kolona)` ne broji redove gde je ta kolona `NULL`.
- `SUM`, `AVG`, `MIN` i `MAX` rade nad vrednostima; proveri kako `NULL` utiče na rezultat.
- Svaka kolona u `SELECT` koja nije agregirana mora biti u `GROUP BY`.
- `WHERE` filtrira redove **pre** grupisanja, a `HAVING` filtrira grupe **posle** grupisanja.

Više primera: [agregacije](../sql/03-funkcije-i-agregacije.sql).

## 7. Spajanje tabela: `JOIN`

```sql
-- Samo redovi koji imaju par u obe tabele
SELECT k.naziv, i.naziv AS izdavac
FROM knjige AS k
INNER JOIN izdavaci AS i ON i.id = k.id_izdavaca;

-- Sačuvaj sve knjige, čak i bez povezanog izdavača
SELECT k.naziv, i.naziv AS izdavac
FROM knjige AS k
LEFT JOIN izdavaci AS i ON i.id = k.id_izdavaca;
```

| `JOIN` | Rezultat |
| --- | --- |
| `INNER JOIN` | samo redovi sa parom u obe tabele |
| `LEFT JOIN` | svi redovi leve tabele i odgovarajući redovi desne |

Za `LEFT JOIN` pažljivo smeštaj uslove za desnu tabelu. Uslov u `WHERE` koji zahteva vrednost iz desne tabele može nenamerno pretvoriti rezultat u `INNER JOIN`; često je pravi dom za takav uslov deo `ON` klauzule.

Detaljno: [vodič za `JOIN`](../docs/05-join.md) i [primeri](../sql/04-join.sql).

## 8. Podupiti, CTE i skupovi

```sql
-- CTE daje ime međurezultatu
WITH prosecne_cene AS (
  SELECT id_izdavaca, AVG(cena) AS prosek
  FROM knjige
  GROUP BY id_izdavaca
)
SELECT *
FROM prosecne_cene
WHERE prosek > 1000;

-- Postoji li povezani red?
SELECT naziv
FROM izdavaci AS i
WHERE EXISTS (
  SELECT 1
  FROM knjige AS k
  WHERE k.id_izdavaca = i.id_izdavaca
);
```

- Podupit vraća jednu vrednost, jednu kolonu/skup ili služi kao uslov preko `EXISTS`.
- CTE počinje sa `WITH`; upotrebi ga da dugačak upit podeliš na imenovane korake.
- `UNION` uklanja duplikate; `UNION ALL` ih zadržava i obično je brži.

Nastavi sa [podupitima i CTE-om](../docs/06-podupiti-i-cte.md).

## 9. Izmena podataka bez rizika

```sql
-- 1. Prvo proveri tačan skup redova
SELECT id_knjige, naziv, cena
FROM knjige
WHERE id_knjige = 1;

-- 2. Tek onda promeni isti skup
UPDATE knjige
SET cena = 1299
WHERE id_knjige = 1;
```

| Naredba | Namenjena za |
| --- | --- |
| `INSERT INTO ... VALUES ...` | unos novog reda |
| `UPDATE ... SET ... WHERE ...` | izmenu postojećih redova |
| `DELETE FROM ... WHERE ...` | brisanje postojećih redova |
| `BEGIN` / `COMMIT` / `ROLLBACK` | potvrdu ili poništavanje grupe promena |

Pre `UPDATE` i `DELETE` obavezno pokreni isti `WHERE` kao `SELECT`. Ako testiraš više promena, radi unutar transakcije i potvrdi ih tek kada proveriš rezultat. Ne izvršavaj `UPDATE` ili `DELETE` bez `WHERE` osim ako je namera eksplicitno da obuhvatiš celu tabelu.

Vodič: [bezbedne izmene](../docs/07-izmena-podataka.md) i [DML vežbe](../sql/06-izmena-podataka.sql).

## 10. Dizajn, kvalitet i brzina

```sql
CREATE TABLE primer (
  id INTEGER PRIMARY KEY,
  naziv TEXT NOT NULL,
  kod TEXT UNIQUE,
  roditelj_id INTEGER,
  FOREIGN KEY (roditelj_id) REFERENCES roditelj(id)
);
```

- `PRIMARY KEY` jedinstveno identifikuje red.
- `FOREIGN KEY` čuva vezu između tabela.
- `NOT NULL`, `UNIQUE`, `CHECK` i podrazumevane vrednosti štite kvalitet podataka u samoj bazi.
- Indeks ubrzava određena čitanja, ali usporava upise i zauzima prostor. Dodaje se na osnovu stvarnih obrazaca `WHERE`, `JOIN` i `ORDER BY`, ne unapred na svaku kolonu.
- Za nejasno spor upit pogledaj plan izvršavanja (`EXPLAIN` / `EXPLAIN QUERY PLAN`, zavisno od sistema).

Detaljnije: [dizajn i performanse](../docs/08-dizajn-i-performanse.md) i [šema za vežbanje](../sql/07-dizajn-tabela.sql).

## 11. Bezbednost i mini-kontrola kvaliteta

Pre nego što upit ode u aplikaciju ili važan izveštaj, proveri:

- Da li su kolone precizno navedene umesto `SELECT *`?
- Da li su svi `JOIN` uslovi napisani i da li rezultat nema duplirane redove zbog pogrešne veze?
- Da li `NULL` tretiraš sa `IS NULL`, `COALESCE` ili jasnim pravilom?
- Da li je agregatni rezultat grupisan po svim potrebnim kolonama?
- Da li je `UPDATE`/`DELETE` prvo proveren ekvivalentnim `SELECT` upitom?
- Da li aplikacija koristi parametrizovane upite, a ne lepljenje korisničkog unosa u SQL tekst?
- Da li su test podaci dovoljni da pokriju: nema povezanog reda, više povezanih redova, `NULL`, duplikat i graničnu vrednost?

## Brza navigacija

| Želim da… | Otvori |
| --- | --- |
| razumem model biblioteke | [bazu i model](../docs/01-baza-i-model.md) |
| napišem prvi `SELECT` | [čitanje podataka](../sql/01-citanje-podataka.sql) |
| rešim uslove ili `NULL` | [uslove i `NULL`](../docs/03-uslovi-i-null.md) |
| saberem ili prebrojim podatke | [funkcije i agregacije](../docs/04-funkcije-i-agregacije.md) |
| povežem dve ili više tabela | [`JOIN` primere](../sql/04-join.sql) |
| podelim složen upit na korake | [podupite i CTE](../docs/06-podupiti-i-cte.md) |
| promenim podatke sigurno | [DML vodič](../docs/07-izmena-podataka.md) |
| dodam novu temu ili zadatak | [pravila za doprinos](../CONTRIBUTING.md) |
