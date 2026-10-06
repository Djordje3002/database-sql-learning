-- 06: INSERT, UPDATE, DELETE, and transactions / i transakcije
-- This is a lab: run one block at a time / Ova datoteka je vežba: pokreći blokove jedan po jedan.
-- ROLLBACK reverts changes, so the base stays unchanged / ROLLBACK vraća promene, pa baza ostaje ista.

BEGIN;

INSERT INTO izdavaci (id, naziv, grad, godina_osnivanja)
VALUES (5, 'Primer izdavač', 'Kragujevac', 2026);

UPDATE knjige
SET cena = cena * 1.05
WHERE id_izdavaca = 2;

-- Always inspect rows before deleting / Uvek proveri pre brisanja.
SELECT *
FROM izdavaci
WHERE id = 5;

DELETE FROM izdavaci
WHERE id = 5;

-- Revert all changes from this lab block / Za vežbu poništi sve izmene iz ovog bloka.
ROLLBACK;
