# SQL intervju laboratorija

> **Srpski** · [English](README.md)

Ovo nije lista za bubanje. Svako pitanje tretiraj kao mali design review: razjasni zrno podataka, navedi granične slučajeve, reci koji dijalekt pretpostavljaš, napiši najjednostavniji ispravan upit i objasni kako bi ga proverio/la ili skalirao/la.

| Materijal | Namena |
| --- | --- |
| [Pitanja za osnove](foundation-questions.sr.md) | join, agregacije, `NULL`, grupisanje i bezbedan DML |
| [Napredna pitanja](advanced-questions.sr.md) | prozori, transakcije, indeksi, RLS, dizajn i operacije |
| [Početni izazovi](sql/interview-challenges.sql) | praktični SQL zadaci sa vremenom |
| [Referentni odgovori](sql/interview-answers.sql) | pregled posle iskrenog pokušaja |

## Okvir odgovora na intervjuu

1. **Razjasni:** Šta predstavlja jedan izlazni red? Koji dijalekt/verziju i obim podataka pretpostavljaš?
2. **Dizajniraj:** Objasni kardinalnost join-a, trenutak filtera i tretman `NULL`/praznog ulaza.
3. **Napiši:** Koristi jasne alias-e i eksplicitan redosled. Izbegni `SELECT *`.
4. **Proveri:** Navedi mali kontra-primer ili kontrolni zbir.
5. **Skaliraj:** Imenuj indeks, plan upita, lock ili bezbednosni problem samo kada je zaista bitan.

Provedi 20–30 minuta nad izazovom pre nego što pogledaš odgovor. Kratak, dobro obrazložen upit je bolji od složenog upita koji ne možeš da odbraniš.
