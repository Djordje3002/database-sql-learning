# Napredna intervju pitanja

> **Srpski** · [English](advanced-questions.md)

1. Uporedi `ROW_NUMBER`, `RANK` i `DENSE_RANK` na primeru izjednačene prodaje.
2. Zašto kumulativni zbir treba eksplicitno da navede `ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`?
3. Dizajniraj idempotentan payment callback. Koje ograničenje čini retry bezbednim?
4. Objasni atomicity i isolation kroz checkout sa zalihom. Gde počinje i gde se završava transakcija?
5. Za `WHERE customer_id = ? AND created_at >= ? ORDER BY created_at DESC` predloži indeks i opravdaj redosled kolona.
6. PostgreSQL plan pokazuje sequential scan. Koji dokaz ti treba pre dodavanja indeksa?
7. Kada je parcijalni indeks bolji od punog? Šta mora da važi za predikat upita?
8. Kako sprečavaš čitanje drugog tenant-a ako aplikacija slučajno izostavi filter? Opiši RLS i zahteve performansi.
9. Dizajniraj više-prema-više vezu koja čuva činjenice o samoj vezi.
10. Kako bi dodao/la non-null kolonu u veliku živu tabelu bez lomljenja starih verzija aplikacije?
11. Objasni backup RPO/RTO i zašto uspešan backup job nije dovoljan dokaz.
12. Zašto se u bankarskom ledger-u ispravke rade reversing stavkama, a ne update-om?

Dobar odgovor pokazuje trade-off. Indeks može poboljšati čitanje i povećati cenu pisanja; mehanizam izolacije može povećati tačnost i promeniti složenost i propusnost.
