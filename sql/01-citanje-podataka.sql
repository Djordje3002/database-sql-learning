-- 01: Reading data / Čitanje podataka — SELECT, DISTINCT, ORDER BY, LIMIT, aliases

-- All columns: useful for exploration, not production / Sve kolone: korisno za istraživanje, ne i za produkciju.
SELECT *
FROM knjige;

-- Select only needed columns and use a clear alias / Izaberi samo potrebne kolone i daj čitljiv alias.
SELECT naziv AS naslov, cena AS cena_dinara
FROM knjige;

-- Distinct customer cities, without duplicates / Različiti gradovi kupaca, bez duplikata.
SELECT DISTINCT grad
FROM kupci
ORDER BY grad ASC;

-- Five most expensive books / Pet najskupljih knjiga.
SELECT naziv, cena
FROM knjige
ORDER BY cena DESC, naziv ASC
LIMIT 5;
