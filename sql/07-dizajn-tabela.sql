-- 07: Samostalna mini-tabela sa pravilima kvaliteta podataka.

CREATE TABLE IF NOT EXISTS kategorije (
  id INTEGER PRIMARY KEY,
  naziv TEXT NOT NULL UNIQUE,
  aktivna INTEGER NOT NULL DEFAULT 1 CHECK (aktivna IN (0, 1))
);

-- Indeks ima smisla jer često spajamo knjige po izdavaču.
CREATE INDEX IF NOT EXISTS idx_knjige_id_izdavaca
ON knjige(id_izdavaca);

-- SQLite: vidi plan koji bira optimizator.
EXPLAIN QUERY PLAN
SELECT naziv
FROM knjige
WHERE id_izdavaca = 1;
