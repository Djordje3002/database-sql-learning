# 01 — Prozorske funkcije: analitika bez gubitka redova

> **Srpski** · [English](../en/docs/01-window-functions.md)

Prozorska (window) funkcija računa vrednost nad skupom povezanih redova, ali za razliku od `GROUP BY` **ne sažima rezultat na jedan red po grupi**. Zato je idealna za rangiranje knjiga, kumulativni prihod i poređenje trenutne porudžbine sa prethodnom.

## Mentalni model

```sql
funkcija(...) OVER (
  PARTITION BY kolona_za_grupu
  ORDER BY redosled
  ROWS BETWEEN ... AND ...
)
```

- `PARTITION BY` deli rezultat na nezavisne grupe, na primer po kupcu.
- `ORDER BY` određuje redosled u okviru svake grupe.
- okvir (`ROWS` / `RANGE`) određuje koji redovi učestvuju u računanju za tekući red.
- bez `PARTITION BY` ceo rezultat je jedna grupa.

Prozorska funkcija se logički obrađuje posle `WHERE` i grupisanja, pa se njen alias obično ne koristi direktno u istom `WHERE`. Za filtriranje po rangu koristi CTE ili podupit.

## Funkcije koje moraš znati

| Funkcija | Namena | Važna nijansa |
| --- | --- | --- |
| `ROW_NUMBER()` | jedinstven redni broj | kod izjednačenja dodaj dodatni kriterijum u `ORDER BY` za stabilan rezultat |
| `RANK()` | rang sa "rupama" | rezultati 1, 1, 3 kada su prva dva izjednačena |
| `DENSE_RANK()` | rang bez rupa | rezultati 1, 1, 2 kada su prva dva izjednačena |
| `LAG()` / `LEAD()` | prethodna / sledeća vrednost | ne traže ručno spajanje tabele sa samom sobom |
| `SUM()` / `AVG()` sa `OVER` | kumulativni ili pomični obračun | eksplicitno napiši okvir kada je bitan |
| `NTILE(n)` | približno ravnomerna podela u `n` grupa | korisno za segmentaciju, ne za stroga poslovna pravila |

## `GROUP BY` naspram `OVER`

```sql
-- Jedan red po izdavaču: detalji o pojedinačnoj knjizi nestaju.
SELECT id_izdavaca, AVG(cena) AS prosecna_cena
FROM knjige
GROUP BY id_izdavaca;

-- Jedan red po knjizi: svaka knjiga vidi prosek svog izdavača.
SELECT
  id_knjige,
  naziv,
  cena,
  AVG(cena) OVER (PARTITION BY id_izdavaca) AS prosek_izdavaca
FROM knjige;
```

## Okvir prozora: najčešća zamka

Za kumulativni zbir nemoj se osloniti na podrazumevani okvir. Kada više redova ima istu vrednost u `ORDER BY`, ponašanje može biti iznenađujuće zbog "peer" redova. Napiši nameru jasno:

```sql
SUM(iznos) OVER (
  PARTITION BY id_kupca
  ORDER BY datum, id_narudzbine
  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
) AS kumulativno
```

`ROWS` broji fizičke redove. `RANGE` se odnosi na opseg vrednosti sortiranja i ima drugačija pravila među dijalektima. Za većinu izveštaja o redovima koristi eksplicitni `ROWS`.

## Dobar postupak

1. U CTE-u prvo pripremi pravu meru, na primer ukupan iznos porudžbine.
2. Zatim uvedi prozor nad tom merom.
3. Dodaj deterministički redosled (`datum, id`).
4. Ručno proveri prvi, poslednji i izjednačen slučaj.
5. Tek na kraju filtriraj `rn <= 3` u spoljašnjem upitu.

```sql
WITH porudzbine_sa_iznosom AS (
  SELECT n.id, n.id_kupca, n.datum,
         SUM(s.kolicina * s.cena_u_trenutku) AS iznos
  FROM narudzbine AS n
  JOIN stavke_narudzbine AS s ON s.id_narudzbine = n.id
  WHERE n.status IN ('placena', 'poslata')
  GROUP BY n.id, n.id_kupca, n.datum
), rangirane AS (
  SELECT *,
         ROW_NUMBER() OVER (
           PARTITION BY id_kupca
           ORDER BY iznos DESC, id ASC
         ) AS rn
  FROM porudzbine_sa_iznosom
)
SELECT *
FROM rangirane
WHERE rn <= 3;
```

## Performanse i dijalekti

Prozor često zahteva sortiranje. Indeks koji prati `PARTITION BY` pa `ORDER BY` može pomoći, ali nije univerzalno rešenje — proveri plan i podatke. Nemoj praviti indeks samo zato što se kolona pojavila u `OVER`.

- **SQLite:** funkcije su dostupne u modernim verzijama; nema `QUALIFY`.
- **PostgreSQL:** isti osnovni obrazac; koristi `EXPLAIN (ANALYZE, BUFFERS)` za realne podatke.
- **MySQL 8+:** prozorske funkcije postoje; proveri indeks i privremene tabele u planu.

## Vežba

Pokreni [praktične primere](../sql/01-window-functions.sql), a zatim napiši upit koji za svaku kategoriju knjiga prikazuje dve najskuplje knjige. Ako su cene iste, neka manji `id_knjige` bude prvi. Rešenje mora imati tačno dve faze: rangiranje i filtriranje.
