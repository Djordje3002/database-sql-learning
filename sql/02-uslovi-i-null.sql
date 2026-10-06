-- 02: Conditions and NULL / WHERE, logički operatori, opsezi, obrasci i NULL

SELECT naziv, cena
FROM knjige
WHERE cena >= 1000;

SELECT naziv, godina_izdanja, cena
FROM knjige
WHERE godina_izdanja BETWEEN 2020 AND 2023
  AND cena < 1300;

SELECT naziv, cena
FROM knjige
WHERE id_izdavaca IN (1, 3);

SELECT naziv
FROM knjige
WHERE naziv LIKE 'H%';

-- Use IS NULL, not email = NULL / IS NULL, a ne: email = NULL
SELECT ime, grad
FROM kupci
WHERE email IS NULL;

SELECT naziv, cena
FROM knjige
WHERE (cena < 900 OR cena IS NULL)
  AND godina_izdanja >= 2020;
