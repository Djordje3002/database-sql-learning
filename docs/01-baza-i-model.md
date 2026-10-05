# Baza i model podataka

Relacijska baza čuva podatke u tabelama. Svaki red je jedan zapis, a svaka kolona opisuje osobinu tog zapisa.

| Pojam | Značenje | Primer |
| --- | --- | --- |
| tabela | skup istih vrsta zapisa | `knjige` |
| red | jedan zapis | jedna knjiga |
| kolona | osobina zapisa | `naziv`, `cena` |
| primarni ključ | jedinstven identifikator reda | `knjige.id_knjige` |
| strani ključ | veza ka drugoj tabeli | `knjige.id_izdavaca` |

## Naš model

```text
izdavaci 1 ───< knjige >───< knjige_autori >─── 1 autori
kupci    1 ───< narudzbine 1 ───< stavke_narudzbine >─── 1 knjige
```

Oznaka `1 ───<` znači „jedan prema više“. Jedan izdavač može imati više knjiga, dok svaka knjiga u ovoj pojednostavljenoj bazi pripada jednom izdavaču.

## Integritet podataka

Ključevi i ograničenja nisu ukras: štite bazu od pogrešnih podataka. Na primer, strani ključ sprečava knjigu sa izdavačem koji ne postoji, a `CHECK (cena >= 0)` sprečava negativnu cenu.
