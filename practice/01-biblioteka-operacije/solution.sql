-- Project 01: Library Operations — reference solution for SQLite
-- Prerequisite: sql/00-priprema-baze.sql is loaded into the current database.

-- Task 1: browseable catalog.
SELECT
  k.id_knjige AS book_id,
  k.naziv AS book_title,
  i.naziv AS publisher_name,
  k.godina_izdanja AS publication_year,
  k.cena AS current_price,
  k.broj_strana AS page_count
FROM knjige AS k
JOIN izdavaci AS i ON i.id = k.id_izdavaca
ORDER BY k.naziv;

-- Task 2: LEFT JOIN keeps a publisher even when it has no book.
SELECT
  i.id AS publisher_id,
  i.naziv AS publisher_name,
  COUNT(k.id_knjige) AS book_count
FROM izdavaci AS i
LEFT JOIN knjige AS k ON k.id_izdavaca = i.id
GROUP BY i.id, i.naziv
ORDER BY book_count DESC, publisher_name;

-- Task 3: books without a recorded author relationship.
SELECT
  k.id_knjige AS book_id,
  k.naziv AS book_title,
  i.naziv AS publisher_name
FROM knjige AS k
JOIN izdavaci AS i ON i.id = k.id_izdavaca
LEFT JOIN knjige_autori AS ka ON ka.id_knjige = k.id_knjige
WHERE ka.id_autora IS NULL
ORDER BY k.naziv;

-- Task 4: bibliography per author.
SELECT
  a.id AS author_id,
  a.ime || ' ' || a.prezime AS author_name,
  COUNT(ka.id_knjige) AS book_count,
  COALESCE(GROUP_CONCAT(k.naziv, ' | '), '—') AS book_titles
FROM autori AS a
LEFT JOIN knjige_autori AS ka ON ka.id_autora = a.id
LEFT JOIN knjige AS k ON k.id_knjige = ka.id_knjige
GROUP BY a.id, a.ime, a.prezime
ORDER BY a.prezime, a.ime;

-- Task 5: customer profile. The status condition lives inside the aggregate,
-- so a customer with no order would still be retained by the LEFT JOIN.
SELECT
  ku.id AS customer_id,
  ku.ime AS customer_name,
  COUNT(n.id) AS total_orders,
  SUM(CASE WHEN n.status IN ('placena', 'poslata') THEN 1 ELSE 0 END) AS finalized_orders,
  MAX(n.datum) AS latest_order_date
FROM kupci AS ku
LEFT JOIN narudzbine AS n ON n.id_kupca = ku.id
GROUP BY ku.id, ku.ime
ORDER BY ku.ime;

-- Task 6: first reduce order lines to a book-level sales measure. An order line
-- from a non-finalized order contributes zero rather than disappearing.
WITH sales_by_book AS (
  SELECT
    sn.id_knjige,
    SUM(CASE WHEN n.status IN ('placena', 'poslata') THEN sn.kolicina ELSE 0 END) AS units_sold,
    SUM(
      CASE
        WHEN n.status IN ('placena', 'poslata')
          THEN sn.kolicina * sn.cena_u_trenutku
        ELSE 0
      END
    ) AS recognized_revenue
  FROM stavke_narudzbine AS sn
  JOIN narudzbine AS n ON n.id = sn.id_narudzbine
  GROUP BY sn.id_knjige
)
SELECT
  k.id_knjige AS book_id,
  k.naziv AS book_title,
  COALESCE(s.units_sold, 0) AS units_sold,
  COALESCE(s.recognized_revenue, 0) AS recognized_revenue
FROM knjige AS k
LEFT JOIN sales_by_book AS s ON s.id_knjige = k.id_knjige
ORDER BY recognized_revenue DESC, book_title;

-- Task 7: a reusable catalog view. The author aggregation is isolated in a CTE,
-- which guarantees that the final view still has exactly one row per book.
DROP VIEW IF EXISTS vw_praksa_katalog;

CREATE VIEW vw_praksa_katalog AS
WITH authors_by_book AS (
  SELECT
    ka.id_knjige,
    GROUP_CONCAT(a.ime || ' ' || a.prezime, ' | ') AS author_names
  FROM knjige_autori AS ka
  JOIN autori AS a ON a.id = ka.id_autora
  GROUP BY ka.id_knjige
)
SELECT
  k.id_knjige AS book_id,
  k.naziv AS book_title,
  i.naziv AS publisher_name,
  k.godina_izdanja AS publication_year,
  k.cena AS current_price,
  COALESCE(ab.author_names, 'Unknown author') AS author_names
FROM knjige AS k
JOIN izdavaci AS i ON i.id = k.id_izdavaca
LEFT JOIN authors_by_book AS ab ON ab.id_knjige = k.id_knjige;

-- Example catalog search. Replace the term in one place only.
WITH search_input AS (
  SELECT 'orvel' AS term
)
SELECT
  book_id,
  book_title,
  publisher_name,
  author_names
FROM vw_praksa_katalog
CROSS JOIN search_input AS si
WHERE LOWER(book_title) LIKE '%' || LOWER(si.term) || '%'
   OR LOWER(publisher_name) LIKE '%' || LOWER(si.term) || '%'
   OR LOWER(author_names) LIKE '%' || LOWER(si.term) || '%'
ORDER BY book_title;

-- Task 8: one combined data-quality report.
SELECT
  'book_without_author' AS issue_type,
  CAST(k.id_knjige AS TEXT) AS subject_id,
  k.naziv AS subject_name
FROM knjige AS k
LEFT JOIN knjige_autori AS ka ON ka.id_knjige = k.id_knjige
WHERE ka.id_autora IS NULL

UNION ALL

SELECT
  'publisher_without_books' AS issue_type,
  CAST(i.id AS TEXT) AS subject_id,
  i.naziv AS subject_name
FROM izdavaci AS i
LEFT JOIN knjige AS k ON k.id_izdavaca = i.id
WHERE k.id_knjige IS NULL

ORDER BY issue_type, subject_name;
