-- 01: SELECT, DISTINCT, ORDER BY, LIMIT i aliasi

-- Sve kolone: korisno za istraživanje, ali ne i za stvarni program.
SELECT *
FROM knjige;

-- Izaberi samo potrebne kolone i daj čitljiv alias.
SELECT naziv AS naslov, cena AS cena_dinara
FROM knjige;

-- Različiti gradovi kupaca, bez duplikata.
SELECT DISTINCT grad
FROM kupci
ORDER BY grad ASC;

-- Pet najskupljih knjiga.
SELECT naziv, cena
FROM knjige
ORDER BY cena DESC, naziv ASC
LIMIT 5;
