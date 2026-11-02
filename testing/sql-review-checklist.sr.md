# Kontrolna lista SQL review-a

> **Srpski** · [English](sql-review-checklist.md)

## Tačnost

- [ ] Može li autor jednom rečenicom opisati zrno rezultata?
- [ ] Da li join koristi stabilne identifikatore i da li je kardinalnost jasna?
- [ ] Da li su `NULL`, nula, prazan ulaz, izjednačenja i vremenska zona namerni?
- [ ] Da li su `WHERE`, `HAVING` i filteri spoljnog join-a na pravom mestu?
- [ ] Da li novac koristi istorijsku vrednost i tačnu reprezentaciju?

## Bezbednost

- [ ] Da li su sve vrednosti iz aplikacije bind parametri?
- [ ] Da li se dinamički identifikatori biraju iz allow-list-e?
- [ ] Da li DML ima uzak uslov, prethodni `SELECT` i plan transakcije?
- [ ] Da li su prava/RLS policy-ji minimalni i testabilni?

## Performanse i operacije

- [ ] Da li je oblik upita izmeren pre dodavanja indeksa?
- [ ] Da li kolone indeksa namerno odgovaraju jednakosti, opsegu, redosledu i biranim poljima?
- [ ] Da li su razmotreni indeksi stranih ključeva za join/cascade?
- [ ] Da li migracija čuva kompatibilnost i ima plan oporavka?
- [ ] Da li su obim podataka, timeout, lock, i connection pooling relevantni za ovu putanju?
