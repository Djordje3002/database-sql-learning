# Analitika i data engineering staza

> **Srpski** · [English](README.md)

Ova staza uči bazu pouzdane analitike: definiši metriku pre računanja, sačuvaj zrno činjenica, napravi malu star šemu, izmeri kohorte i pronađi probleme kvaliteta pre nego što dashboard deluje autoritativno sa pogrešnim brojevima.

## Lokalno pokretanje

```bash
sqlite3 analytics.db < sql/00-analytics-setup.sql
sqlite3 analytics.db < sql/01-kpis-and-windows.sql
sqlite3 analytics.db < sql/02-cohorts-and-retention.sql
sqlite3 analytics.db < sql/03-data-quality-checks.sql
```

Skripte su SQLite-first i bezbedne za potrošnu bazu. Koriste samostalan analitički model i ne menjaju knjižarsku practice bazu.

## Moduli

| # | Tema | Ishod | SQL |
| --- | --- | --- | --- |
| 00 | Fact i dimension model | razumeš zrno, dimenzije, činjenice i istorijsku novčanu vrednost | [priprema](sql/00-analytics-setup.sql) |
| 01 | KPI i prozori | prihod, prosečna vrednost porudžbine, aktivni kupci i rolling prihod | [KPI vežba](sql/01-kpis-and-windows.sql) |
| 02 | Kohorte i retencija | kohorte prve kupovine i naredni aktivni periodi | [kohorte](sql/02-cohorts-and-retention.sql) |
| 03 | Kvalitet podataka | dupli događaji, nevalidni redovi i reconciliation prekidi | [kvalitet](sql/03-data-quality-checks.sql) |

Pre pripreme pročitaj [star šemu i zrno](data-model.sr.md), a pre dashboarda [ugovore metrika](metric-contracts.sr.md).

## Pravila protiv pogrešne analitike

- Pre join-a ili agregacije napiši **zrno**: jedna narudžbina, stavka, sesija ili customer-month.
- Fact tabele su append-oriented. Istorijski prihod pripada trenutku kupovine, ne trenutnoj ceni proizvoda.
- Metrika mora imati naziv, brojilac, imenilac, filter statusa/datuma, vremensku zonu, vlasnika i pravilo za granične slučajeve.
- Ne spajaj dve detail-level fact tabele bez bridge-a ili prethodne agregacije; to tiho množi mere.
- Provere kvaliteta su pravi rezultat. Dashboard koji ne pokazuje svežinu i neuspele provere nije završen.

U produkcionom warehouse-u ove ideje proširi orkestratorom, verzionisanim transformacijama, kontrolom pristupa, inkrementalnim učitavanjem i praćenim data contract-ima.
