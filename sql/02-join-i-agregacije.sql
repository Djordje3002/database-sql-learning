-- 02: JOIN i agregacije
-- Pretpostavljene tabele:
-- izdavaci(id, naziv)
-- knjige(id_knjige, naziv, id_izdavaca)

-- Broj knjiga za svakog izdavača koji ima najmanje jednu knjigu.
SELECT izdavaci.naziv,
       COUNT(knjige.id_knjige) AS broj_knjiga
FROM izdavaci
JOIN knjige ON izdavaci.id = knjige.id_izdavaca
GROUP BY izdavaci.id, izdavaci.naziv
ORDER BY broj_knjiga ASC;

-- LEFT JOIN zadržava i izdavače bez ijedne knjige.
SELECT izdavaci.naziv,
       COUNT(knjige.id_knjige) AS broj_knjiga
FROM izdavaci
LEFT JOIN knjige ON izdavaci.id = knjige.id_izdavaca
GROUP BY izdavaci.id, izdavaci.naziv
ORDER BY broj_knjiga ASC, izdavaci.naziv ASC;

-- Samo izdavači sa najmanje pet knjiga.
SELECT izdavaci.naziv,
       COUNT(knjige.id_knjige) AS broj_knjiga
FROM izdavaci
JOIN knjige ON izdavaci.id = knjige.id_izdavaca
GROUP BY izdavaci.id, izdavaci.naziv
HAVING COUNT(knjige.id_knjige) >= 5
ORDER BY broj_knjiga DESC;
