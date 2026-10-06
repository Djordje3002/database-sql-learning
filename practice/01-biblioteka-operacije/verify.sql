-- Project 01: non-destructive control queries.
-- These checks are based on the base database from sql/00-priprema-baze.sql.

-- Base model control counts.
SELECT
  (SELECT COUNT(*) FROM knjige) AS expected_catalog_rows,
  (SELECT COUNT(*) FROM izdavaci) AS expected_publisher_rows,
  (SELECT COUNT(*) FROM kupci) AS expected_customer_rows;

-- The publisher report should retain this zero-book publisher.
SELECT
  i.naziv AS expected_zero_book_publisher,
  COUNT(k.id_knjige) AS expected_book_count
FROM izdavaci AS i
LEFT JOIN knjige AS k ON k.id_izdavaca = i.id
WHERE i.naziv = 'Mali princ'
GROUP BY i.id, i.naziv;

-- The author-completeness report should expose this title.
SELECT
  k.naziv AS expected_book_without_author
FROM knjige AS k
LEFT JOIN knjige_autori AS ka ON ka.id_knjige = k.id_knjige
WHERE ka.id_autora IS NULL;

-- Recognized revenue in the initial data. A correct answer is 4995.0.
SELECT
  SUM(sn.kolicina * sn.cena_u_trenutku) AS expected_recognized_revenue
FROM narudzbine AS n
JOIN stavke_narudzbine AS sn ON sn.id_narudzbine = n.id
WHERE n.status IN ('placena', 'poslata');

-- Inspect the grain of order lines before joining more tables.
SELECT
  n.id AS order_id,
  n.status,
  COUNT(sn.id_knjige) AS line_count,
  SUM(sn.kolicina * sn.cena_u_trenutku) AS order_value
FROM narudzbine AS n
JOIN stavke_narudzbine AS sn ON sn.id_narudzbine = n.id
GROUP BY n.id, n.status
ORDER BY n.id;
