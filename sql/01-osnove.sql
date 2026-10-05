-- 01: Osnovni SQL primeri
-- Pretpostavljena tabela: knjige(id_knjige, naziv, godina_izdanja, cena, id_izdavaca)

-- 1. Prikaži sve kolone i sve redove.
SELECT *
FROM knjige;

-- 2. Prikaži samo naziv i godinu izdanja.
SELECT naziv, godina_izdanja
FROM knjige;

-- 3. Knjige objavljene od 2020. godine.
SELECT naziv, godina_izdanja
FROM knjige
WHERE godina_izdanja >= 2020;

-- 4. Sortiranje po nazivu, od A do Ž.
SELECT naziv, godina_izdanja
FROM knjige
ORDER BY naziv ASC;

-- 5. Ukupan broj knjiga.
SELECT COUNT(*) AS ukupan_broj_knjiga
FROM knjige;
