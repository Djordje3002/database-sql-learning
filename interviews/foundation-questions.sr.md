# Intervju pitanja — osnove

> **Srpski** · [English](foundation-questions.md)

1. Objasni razliku između `COUNT(*)`, `COUNT(kolona)` i `COUNT(DISTINCT kolona)` posle `LEFT JOIN`-a.
2. Zašto `WHERE desna_tabela.status = 'paid'` posle `LEFT JOIN`-a često pretvara upit u unutrašnji join? Pokaži dve bezbedne alternative.
3. Vrati izdavače sa najmanje tri knjige i objasni razliku između `WHERE` i `HAVING` u tom upitu.
4. Pronađi knjige bez autora bez slučajnog skrivanja tih knjiga.
5. Revenue upit duplira zbir posle spajanja autora. Koja je greška u zrnu podataka i kako je popravljaš?
6. Zašto je `email = NULL` pogrešno i kada prazan string nije isto što i `NULL`?
7. Napiši upit za drugu najveću različitu cenu; objasni izjednačenja i slučaj kada druga cena ne postoji.
8. Za dati `DELETE` opiši tačan bezbedan postupak pre `COMMIT`-a.
9. Uporedi `EXISTS`, `IN` i `JOIN` za „kupce koji imaju narudžbinu”. Kada join može napraviti duplikate?
10. Kako bi paginirao/la veliku listu narudžbina koja se često menja? Uporedi offset i keyset pagination.

Za svaki odgovor reci koji dijalekt baze pretpostavljaš. Datum, string agregacija, paginacija i sintaksa plana upita nisu isti u svim bazama.
