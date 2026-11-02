-- Reference answers / Referentni odgovori. Review only after attempting the prompts.

-- 1. Aggregate orders before joining the many-to-many author relation / Agregiraj pre potencijalnog više-prema-više join-a.
WITH revenue_by_book AS (
  SELECT sn.id_knjige,
         SUM(CASE WHEN n.status IN ('placena', 'poslata') THEN sn.kolicina * sn.cena_u_trenutku ELSE 0 END) AS prihod
  FROM stavke_narudzbine AS sn
  JOIN narudzbine AS n ON n.id = sn.id_narudzbine
  GROUP BY sn.id_knjige
)
SELECT i.naziv AS izdavac,
       COUNT(k.id_knjige) AS broj_knjiga,
       COALESCE(SUM(r.prihod), 0) AS prihod
FROM izdavaci AS i
LEFT JOIN knjige AS k ON k.id_izdavaca = i.id
LEFT JOIN revenue_by_book AS r ON r.id_knjige = k.id_knjige
GROUP BY i.id, i.naziv
ORDER BY prihod DESC, izdavac;

-- 2. Rank after per-book revenue is correct / Rangiraj tek posle tačnog prihoda po knjizi.
WITH revenue_by_book AS (
  SELECT k.id_knjige, k.id_izdavaca, k.naziv,
         COALESCE(SUM(CASE WHEN n.status IN ('placena', 'poslata') THEN sn.kolicina * sn.cena_u_trenutku ELSE 0 END), 0) AS prihod
  FROM knjige AS k
  LEFT JOIN stavke_narudzbine AS sn ON sn.id_knjige = k.id_knjige
  LEFT JOIN narudzbine AS n ON n.id = sn.id_narudzbine
  GROUP BY k.id_knjige, k.id_izdavaca, k.naziv
), ranked AS (
  SELECT *, DENSE_RANK() OVER (PARTITION BY id_izdavaca ORDER BY prihod DESC) AS rang
  FROM revenue_by_book
)
SELECT * FROM ranked WHERE rang <= 2 ORDER BY id_izdavaca, rang, naziv;

-- 3. Rank real orders first, then left join so customers with no orders remain visible.
-- Rangiraj stvarne narudžbine pre LEFT JOIN-a da kupci bez narudžbine ostanu vidljivi.
WITH ranked_orders AS (
  SELECT n.id, n.id_kupca, n.datum, n.status,
         ROW_NUMBER() OVER (
           PARTITION BY n.id_kupca
           ORDER BY n.datum DESC, n.id DESC
         ) AS rn
  FROM narudzbine AS n
)
SELECT ku.ime, ro.id AS poslednja_narudzbina, ro.datum, ro.status
FROM kupci AS ku
LEFT JOIN ranked_orders AS ro
  ON ro.id_kupca = ku.id
 AND ro.rn = 1
WHERE ro.id IS NULL
   OR ro.status NOT IN ('placena', 'poslata')
ORDER BY ku.ime;

-- 4. The grain is one order after the GROUP BY / Zrno je jedna narudžbina posle GROUP BY-a.
SELECT n.id AS id_narudzbine,
       n.status,
       SUM(sn.kolicina * sn.cena_u_trenutku) AS vrednost_narudzbine
FROM narudzbine AS n
JOIN stavke_narudzbine AS sn ON sn.id_narudzbine = n.id
GROUP BY n.id, n.status
HAVING SUM(sn.kolicina * sn.cena_u_trenutku) > 2000
ORDER BY vrednost_narudzbine DESC;
