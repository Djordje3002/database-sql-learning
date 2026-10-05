# Dizajn tabela, indeksi i performanse

## Pravila dizajna

- Svaka tabela ima jasan predmet: knjige nisu isto što i izdavači.
- Svaki red ima primarni ključ.
- Veze se čuvaju stranim ključevima, ne kopiranjem naziva u svaku tabelu.
- Koristi odgovarajući tip podatka: broj kao broj, datum kao datum, iznos kao decimalni tip.
- Dodaj `NOT NULL`, `UNIQUE`, `CHECK` i `DEFAULT` kada poslovno pravilo to zahteva.

## Indeksi

Indeks ubrzava pronalaženje redova, naročito za kolone koje se često koriste u `WHERE`, `JOIN` i `ORDER BY`. Ali indeks usporava `INSERT`, `UPDATE` i `DELETE` i zauzima prostor — zato se ne dodaje naslepo.

Dobar početak je indeks na stranim ključevima, na primer `knjige(id_izdavaca)`. Pre optimizacije izmeri problem i pogledaj plan izvršavanja (`EXPLAIN` ili `EXPLAIN ANALYZE`, zavisno od baze).
