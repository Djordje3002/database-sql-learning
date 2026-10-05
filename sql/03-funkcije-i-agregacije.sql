-- 03: Funkcije po redovima, CASE i agregacije

SELECT naziv,
       UPPER(naziv) AS naziv_velikim_slovima,
       LENGTH(naziv) AS broj_znakova,
       ROUND(cena * 1.20, 2) AS cena_sa_porezom
FROM knjige;

SELECT ime,
       COALESCE(email, 'email nije unet') AS kontakt
FROM kupci;

SELECT naziv,
       cena,
       CASE
         WHEN cena >= 1300 THEN 'premium'
         WHEN cena >= 900 THEN 'srednja cena'
         ELSE 'povoljna'
       END AS kategorija_cene
FROM knjige;

SELECT COUNT(*) AS ukupan_broj_knjiga,
       ROUND(AVG(cena), 2) AS prosecna_cena,
       MIN(cena) AS najniza_cena,
       MAX(cena) AS najvisa_cena
FROM knjige;

SELECT i.naziv AS izdavac,
       COUNT(k.id_knjige) AS broj_knjiga,
       ROUND(AVG(k.cena), 2) AS prosecna_cena
FROM izdavaci AS i
JOIN knjige AS k ON k.id_izdavaca = i.id
GROUP BY i.id, i.naziv
HAVING COUNT(k.id_knjige) >= 2
ORDER BY broj_knjiga DESC, izdavac ASC;
