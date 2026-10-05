-- 06: INSERT, UPDATE, DELETE i transakcije
-- Ova datoteka je vežba: pokreći blokove jedan po jedan.
-- ROLLBACK vraća promene, pa baza ostaje ista.

BEGIN;

INSERT INTO izdavaci (id, naziv, grad, godina_osnivanja)
VALUES (5, 'Primer izdavač', 'Kragujevac', 2026);

UPDATE knjige
SET cena = cena * 1.05
WHERE id_izdavaca = 2;

-- Uvek proveri pre brisanja.
SELECT *
FROM izdavaci
WHERE id = 5;

DELETE FROM izdavaci
WHERE id = 5;

-- Za vežbu poništi sve izmene iz ovog bloka.
ROLLBACK;
