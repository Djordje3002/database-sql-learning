# Star šema i zrno

> **Srpski** · [English](data-model.md)

Star šema stavlja događajnu **fact** tabelu u sredinu, a opisne **dimension** tabele oko nje.

```text
dim_customers ──< fact_orders >── dim_products
                      |
                 dim_calendar
```

| Pojam | Na koje pitanje odgovara | Primer |
| --- | --- | --- |
| fact tabela | Šta se desilo, na kom merljivom zrnu? | jedna finalizovana narudžbina i njen priznati prihod |
| dimension | Kako opisujemo ili grupišemo činjenicu? | kanal akvizicije kupca, datum narudžbine, kategorija proizvoda |
| zrno | Šta predstavlja jedan red? | tačno jedna narudžbina, ne narudžbina × svaki proizvod × svaki događaj |
| surrogate/business key | Kako red ostaje prepoznatljiv kroz vreme? | nepromenljivi ID narudžbine; verzionisani ključ kupca u većem warehouse-u |

## Test zrna

Napiši: „Jedan red u `fact_orders` predstavlja jednu narudžbinu, sa konačnim istorijskim prihodom.” Zatim svaku vezu proveri prema tom obećanju. Join sa stavkama menja zrno u jednu stavku; join sa web događajima može pomnožiti narudžbinu svakim događajem. Prvo agregiraj kada želiš da se vratiš na zrno narudžbine.

U većem warehouse-u koristi posebnu fact tabelu za svako zrno (`fact_order_lines`, `fact_sessions`) i poveži ih kroz zajedničke dimenzije umesto direktnog spajanja nepovezanih činjenica.
