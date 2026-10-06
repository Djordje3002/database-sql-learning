-- Project 02: extra sales data for the SQLite practice database.
-- Prerequisite: sql/00-priprema-baze.sql has already been loaded.
-- This script is idempotent: rerunning it does not duplicate the sample rows.

PRAGMA foreign_keys = ON;

BEGIN;

INSERT OR IGNORE INTO kupci (id, ime, email, grad) VALUES
  (4, 'Petar Petrović', 'petar@example.com', 'Kragujevac'),
  (5, 'Mina Milić', 'mina@example.com', 'Beograd'),
  (6, 'Luka Lukić', 'luka@example.com', 'Novi Sad'),
  (7, 'Sara Savić', 'sara@example.com', 'Subotica');

INSERT OR IGNORE INTO narudzbine (id, id_kupca, datum, status) VALUES
  (101, 3, '2026-03-15', 'placena'),
  (102, 4, '2026-03-20', 'poslata'),
  (103, 5, '2026-04-04', 'placena'),
  (104, 1, '2026-04-17', 'otkazana'),
  (105, 4, '2026-05-01', 'nova'),
  (106, 5, '2026-05-09', 'poslata'),
  (107, 6, '2026-05-20', 'placena'),
  (108, 2, '2026-06-03', 'poslata'),
  (109, 3, '2026-06-15', 'placena');

INSERT OR IGNORE INTO stavke_narudzbine
  (id_narudzbine, id_knjige, kolicina, cena_u_trenutku)
VALUES
  (101, 2, 2, 999.00),
  (101, 5, 1, 1099.00),
  (102, 4, 1, 899.00),
  (102, 6, 3, 699.00),
  (103, 3, 2, 1299.00),
  (103, 7, 1, 1599.00),
  (104, 1, 1, 1199.00),
  (105, 5, 1, 1099.00),
  (105, 6, 1, 699.00),
  (106, 2, 1, 999.00),
  (106, 4, 1, 899.00),
  (107, 7, 2, 1599.00),
  (108, 1, 1, 1199.00),
  (108, 3, 1, 1299.00),
  (109, 6, 2, 699.00),
  (109, 7, 1, 1599.00);

COMMIT;
