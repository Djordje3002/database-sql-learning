-- Run this file first / Pokreni ovu datoteku prvu. It targets SQLite / Namenjena je SQLite-u.
-- The model is portable, but automatic-ID syntax differs across databases / Model je prenosiv, ali se sintaksa za automatski ID razlikuje.

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS stavke_narudzbine;
DROP TABLE IF EXISTS narudzbine;
DROP TABLE IF EXISTS kupci;
DROP TABLE IF EXISTS knjige_autori;
DROP TABLE IF EXISTS knjige;
DROP TABLE IF EXISTS autori;
DROP TABLE IF EXISTS izdavaci;

CREATE TABLE izdavaci (
  id INTEGER PRIMARY KEY,
  naziv TEXT NOT NULL UNIQUE,
  grad TEXT,
  godina_osnivanja INTEGER CHECK (godina_osnivanja >= 1400)
);

CREATE TABLE autori (
  id INTEGER PRIMARY KEY,
  ime TEXT NOT NULL,
  prezime TEXT NOT NULL,
  godina_rodjenja INTEGER
);

CREATE TABLE knjige (
  id_knjige INTEGER PRIMARY KEY,
  naziv TEXT NOT NULL,
  godina_izdanja INTEGER NOT NULL,
  cena NUMERIC CHECK (cena >= 0),
  broj_strana INTEGER CHECK (broj_strana > 0),
  id_izdavaca INTEGER NOT NULL,
  FOREIGN KEY (id_izdavaca) REFERENCES izdavaci(id)
);

CREATE TABLE knjige_autori (
  id_knjige INTEGER NOT NULL,
  id_autora INTEGER NOT NULL,
  PRIMARY KEY (id_knjige, id_autora),
  FOREIGN KEY (id_knjige) REFERENCES knjige(id_knjige),
  FOREIGN KEY (id_autora) REFERENCES autori(id)
);

CREATE TABLE kupci (
  id INTEGER PRIMARY KEY,
  ime TEXT NOT NULL,
  email TEXT UNIQUE,
  grad TEXT
);

CREATE TABLE narudzbine (
  id INTEGER PRIMARY KEY,
  id_kupca INTEGER NOT NULL,
  datum TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'nova' CHECK (status IN ('nova', 'placena', 'poslata', 'otkazana')),
  FOREIGN KEY (id_kupca) REFERENCES kupci(id)
);

CREATE TABLE stavke_narudzbine (
  id_narudzbine INTEGER NOT NULL,
  id_knjige INTEGER NOT NULL,
  kolicina INTEGER NOT NULL CHECK (kolicina > 0),
  cena_u_trenutku NUMERIC NOT NULL CHECK (cena_u_trenutku >= 0),
  PRIMARY KEY (id_narudzbine, id_knjige),
  FOREIGN KEY (id_narudzbine) REFERENCES narudzbine(id),
  FOREIGN KEY (id_knjige) REFERENCES knjige(id_knjige)
);

INSERT INTO izdavaci (id, naziv, grad, godina_osnivanja) VALUES
  (1, 'Laguna', 'Beograd', 1998),
  (2, 'Vulkan', 'Beograd', 2010),
  (3, 'Dereta', 'Beograd', 1990),
  (4, 'Mali princ', 'Beograd', 2015);

INSERT INTO autori (id, ime, prezime, godina_rodjenja) VALUES
  (1, 'Meša', 'Selimović', 1910),
  (2, 'Ivo', 'Andrić', 1892),
  (3, 'J. K.', 'Rouling', 1965),
  (4, 'Džordž', 'Orvel', 1903),
  (5, 'Milorad', 'Pavić', 1929);

INSERT INTO knjige (id_knjige, naziv, godina_izdanja, cena, broj_strana, id_izdavaca) VALUES
  (1, 'Derviš i smrt', 2021, 1199.00, 352, 1),
  (2, 'Na Drini ćuprija', 2020, 999.00, 314, 3),
  (3, 'Hari Poter i kamen mudrosti', 2022, 1299.00, 288, 2),
  (4, '1984', 2023, 899.00, 328, 1),
  (5, 'Hazarski rečnik', 2019, 1099.00, 384, 3),
  (6, 'Životinjska farma', 2024, 699.00, 152, 1),
  (7, 'Uvod u baze podataka', 2024, 1599.00, 420, 2);

INSERT INTO knjige_autori (id_knjige, id_autora) VALUES
  (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 4);

INSERT INTO kupci (id, ime, email, grad) VALUES
  (1, 'Ana Anić', 'ana@example.com', 'Beograd'),
  (2, 'Marko Marković', 'marko@example.com', 'Novi Sad'),
  (3, 'Jelena Jovanović', NULL, 'Niš');

INSERT INTO narudzbine (id, id_kupca, datum, status) VALUES
  (1, 1, '2026-01-10', 'placena'),
  (2, 2, '2026-02-12', 'poslata'),
  (3, 1, '2026-03-01', 'nova');

INSERT INTO stavke_narudzbine (id_narudzbine, id_knjige, kolicina, cena_u_trenutku) VALUES
  (1, 1, 1, 1199.00), (1, 4, 2, 899.00),
  (2, 3, 1, 1299.00), (2, 6, 1, 699.00),
  (3, 7, 1, 1599.00);
