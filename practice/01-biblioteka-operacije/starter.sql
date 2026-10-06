-- Project 01: Library Operations
-- Prerequisite: load sql/00-priprema-baze.sql into the current SQLite database.
--
-- Each statement below is deliberately incomplete but valid SQL. Replace or extend
-- it while keeping the requested output grain in mind.

-- Task 1: start from the book table and build a browseable catalog.
-- TODO: join the publisher and include year, price, and page count.
SELECT
  k.id_knjige AS book_id,
  k.naziv AS book_title
FROM knjige AS k
ORDER BY k.naziv;

-- Task 2: count books per publisher, including publishers with zero books.
-- TODO: make sure the aggregate counts a nullable book-side column, not every row.
SELECT
  i.id AS publisher_id,
  i.naziv AS publisher_name
FROM izdavaci AS i
ORDER BY i.naziv;

-- Task 3: find books that do not have a row in knjige_autori.
-- TODO: choose the join and NULL check that preserve unmatched books.
SELECT
  k.id_knjige AS book_id,
  k.naziv AS book_title
FROM knjige AS k
ORDER BY k.naziv;

-- Task 4: one row per author with book count and a combined list of titles.
-- TODO: start from authors, preserve authors without books, and add aggregation.
SELECT
  a.id AS author_id,
  a.ime || ' ' || a.prezime AS author_name
FROM autori AS a
ORDER BY a.prezime, a.ime;

-- Task 5: one row per customer with all-order count, finalized-order count,
-- and latest order date. Finalized means placena or poslata.
-- TODO: use conditional aggregation so customers without orders remain visible.
SELECT
  ku.id AS customer_id,
  ku.ime AS customer_name
FROM kupci AS ku
ORDER BY ku.ime;

-- Task 6: one row per book with units sold and recognized revenue.
-- TODO: only placena and poslata orders count; return zero instead of NULL.
SELECT
  k.id_knjige AS book_id,
  k.naziv AS book_title
FROM knjige AS k
ORDER BY k.naziv;

-- Task 7: create vw_praksa_katalog, then search it by a term such as 'orvel'.
-- TODO: one row per book; do not accidentally create one row per author.
-- DROP VIEW IF EXISTS vw_praksa_katalog;
-- CREATE VIEW vw_praksa_katalog AS ...;

-- Task 8 (stretch): union books without authors with publishers without books.
-- TODO: expose a clear issue_type and a useful subject_name.
