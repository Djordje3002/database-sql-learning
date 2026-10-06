# JOIN: spajanje tabela

> **Srpski** · [English](en/05-joins.md)

`JOIN` povezuje redove iz dve tabele preko zajedničke vrednosti, najčešće primarnog i stranog ključa.

```sql
SELECT k.naziv, i.naziv AS izdavac
FROM knjige AS k
JOIN izdavaci AS i ON i.id = k.id_izdavaca;
```

| Tip | Šta vraća |
| --- | --- |
| `INNER JOIN` / `JOIN` | samo redove koji imaju par u obe tabele |
| `LEFT JOIN` | sve redove leve tabele, plus poklapanja iz desne |
| `RIGHT JOIN` | obrnuto od `LEFT JOIN`; nije podržan svuda |
| `FULL OUTER JOIN` | sve redove iz obe tabele; nije podržan svuda |
| `CROSS JOIN` | svaku kombinaciju redova; koristi se retko i pažljivo |

Kod `LEFT JOIN` broji `COUNT(desna_tabela.id)`, a ne `COUNT(*)`, ako želiš nulu za redove bez poklapanja.

Najčešća greška je spajanje bez `ON`: tada se dobija ogroman broj pogrešnih kombinacija redova.
