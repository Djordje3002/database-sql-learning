# 07 — Mini-projekat: izveštaj koji možeš da odbraniš

> **Srpski** · [English](../en/docs/07-mini-project.md)

Zadatak je mali, ali namerno liči na stvarni zahtev: menadžer želi izveštaj o prodaji knjiga koji može da razume, proveri i koristi za odluku.

## Poslovni zahtev

Za svaku plaćenu ili poslatu porudžbinu prikaži:

- kupca, datum i ukupan iznos;
- redni broj porudžbine kupca po datumu;
- promenu iznosa u odnosu na njegovu prethodnu završenu porudžbinu;
- kumulativnu potrošnju kupca;
- rang kupca po ukupnoj potrošnji;
- oznaku da li je kupac među tri najveća potrošača.

Izveštaj ne sme računati otkazane ili nove porudžbine kao realizovanu prodaju.

## Kriterijumi prihvatanja

| Kriterijum | Kako proveravaš |
| --- | --- |
| Ukupan iznos je tačan | zbir `kolicina * cena_u_trenutku` po porudžbini |
| Svaki kupac ima sopstveni redosled | `PARTITION BY id_kupca` |
| Redosled je stabilan | `ORDER BY datum, id_narudzbine` |
| Rang uzima u obzir sve završene porudžbine | poseban CTE pre filtriranja prikaza |
| Prazni skup ne pravi grešku | `COALESCE` gde je poslovno smisleno |
| Upit je čitljiv | CTE nazivi opisuju poslovnu fazu |

## Predloženi plan

1. Izračunaj iznos jedne porudžbine u CTE-u `zavrsene_porudzbine`.
2. U sledećem CTE-u dodaj `LAG`, `ROW_NUMBER` i kumulativni `SUM`.
3. Napravi zbir po kupcu i rangiraj ga u posebnoj fazi.
4. Spoji rezultat sa kupcima i dodaj oznaku top 3.
5. Pokreni `EXPLAIN QUERY PLAN`; tek ako postoji dokaz problema, razmotri indeks.

Gotov, komentarisani primer je u [07-capstone-analytics.sql](../sql/07-capstone-analytics.sql). Pre pokretanja pokušaj da ga napišeš samostalno, pa poredi pristup — ne samo konačan rezultat.

## Dodatni izazovi

1. Dodaj period kao parametar datuma bez gubljenja istorije potrebne za rang.
2. Prikaži mesečni prihod i poređenje sa prethodnim mesecom, uključujući mesece bez prodaje.
3. Napiši test slučaj za porudžbinu bez stavki i odluči da li je to dozvoljeno stanje.
4. Napravi pogled za izveštaj i dokumentuj ko sme da ga čita.
5. U PostgreSQL-u dodaj indeks i uporedi `EXPLAIN (ANALYZE, BUFFERS)` pre i posle.

Najvredniji rezultat nije samo upit, već kratko obrazloženje: koje pretpostavke model ima, zašto se porudžbina računa ili ne računa kao realizovana i kako bi proverio rezultat na produkcionim podacima.
