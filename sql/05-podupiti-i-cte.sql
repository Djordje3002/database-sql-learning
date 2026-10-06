-- 05: Subqueries, CTEs, and UNION ALL / Podupiti, CTE i UNION ALL

-- Books more expensive than the overall average / Knjige skuplje od prosečne cene svih knjiga.
SELECT naziv, cena
FROM knjige
WHERE cena > (SELECT AVG(cena) FROM knjige)
ORDER BY cena DESC;

-- Publishers with at least one book / Izdavači koji imaju makar jednu knjigu.
SELECT naziv
FROM izdavaci AS i
WHERE EXISTS (
  SELECT 1
  FROM knjige AS k
  WHERE k.id_izdavaca = i.id
);

-- The CTE separates sales calculation from the final output / CTE razdvaja računanje prodaje od završnog prikaza.
WITH prodaja_po_knjizi AS (
  SELECT id_knjige,
         SUM(kolicina) AS prodato_komada
  FROM stavke_narudzbine
  GROUP BY id_knjige
)
SELECT k.naziv,
       COALESCE(p.prodato_komada, 0) AS prodato_komada
FROM knjige AS k
LEFT JOIN prodaja_po_knjizi AS p ON p.id_knjige = k.id_knjige
ORDER BY prodato_komada DESC, k.naziv;

-- UNION ALL keeps every row from both groups / UNION ALL čuva svaki red iz obe grupe.
SELECT naziv, 'povoljna' AS grupa
FROM knjige
WHERE cena < 900
UNION ALL
SELECT naziv, 'premium' AS grupa
FROM knjige
WHERE cena >= 1300
ORDER BY grupa, naziv;
