# 03 — Indeksi i `EXPLAIN`: ubrzavanje zasnovano na dokazu

> **Srpski** · [English](../en/docs/03-indexes-and-explain.md)

Indeks je dodatna struktura koja pomaže bazi da pronađe mali deo tabele bez čitanja svega. Najčešće je B-tree, organizovan za brzo nalaženje vrednosti i raspona. To nije "turbo dugme": svaki indeks zauzima prostor i dodaje posao pri `INSERT`, `UPDATE` i `DELETE`.

## Kada kandidat za indeks postoji

Potraži obrazac u stvarnom, čestom i sporom upitu:

```sql
SELECT id, datum, status
FROM narudzbine
WHERE id_kupca = ?
  AND datum >= ?
ORDER BY datum DESC;
```

Za taj obrazac smislen početak je:

```sql
CREATE INDEX idx_narudzbine_kupac_datum
ON narudzbine (id_kupca, datum DESC);
```

Prvo dolazi jednakost (`id_kupca`), zatim opseg ili redosled (`datum`). Redosled kolona je deo dizajna indeksa, ne estetska odluka.

## Složeni indeksi i levo prefiksno pravilo

Indeks `(a, b, c)` tipično dobro služi upitima koji počinju sa `a`, često i `a, b`. Obično ne rešava efikasno pretragu samo po `b` ili `c`. Pravila imaju izuzetke po optimizatoru, ali ovo je dobar mentalni model.

| Upit | Indeks `(id_kupca, datum)` | Zašto |
| --- | --- | --- |
| `WHERE id_kupca = ?` | dobar kandidat | koristi početak indeksa |
| `WHERE id_kupca = ? AND datum >= ?` | dobar kandidat | jednakost pa raspon |
| `WHERE datum >= ?` | uglavnom nije dovoljan | preskače prvu kolonu |
| `WHERE id_kupca = ? ORDER BY datum` | često pomaže | filtriranje i redosled se poklapaju |

## Čitaj plan, ne nagađaj

U SQLite-u koristi:

```sql
EXPLAIN QUERY PLAN
SELECT id, datum
FROM narudzbine
WHERE id_kupca = 2
  AND datum >= '2026-01-01';
```

Traži da li se pojavljuje `SEARCH ... USING INDEX`, ali nemoj sam tekst plana tumačiti kao apsolutnu presudu. Uporedi plan pre i posle promene, vreme na reprezentativnim podacima i broj vraćenih redova.

- **PostgreSQL:** `EXPLAIN (ANALYZE, BUFFERS)` izvršava upit i daje stvarne redove/vreme. Ne pokreći ga nad destruktivnim upitom bez transakcije.
- **MySQL 8+:** `EXPLAIN ANALYZE` daje stvarne metrike. `EXPLAIN` bez `ANALYZE` prikazuje procenu.
- **SQLite:** `EXPLAIN QUERY PLAN` je najčitljiviji početak; `ANALYZE` ažurira statistike optimizatora.

## Anti-obrasci

```sql
-- Funkcija nad indeksiranom kolonom često otežava korišćenje indeksa.
WHERE date(datum) = '2026-03-01'

-- Bolje: opseg koji zadržava kolonu "golom".
WHERE datum >= '2026-03-01'
  AND datum <  '2026-03-02'
```

- Ne indeksiraj svaku kolonu "za svaki slučaj".
- Indeks sa vrlo malo različitih vrednosti (`aktivna` samo 0/1) često nije dovoljan sam za sebe.
- `LIKE '%tekst'` uglavnom ne koristi običan B-tree indeks; razmisli o full-text pretrazi kada je to stvarna potreba.
- `SELECT *` može sprečiti jeftiniji "covering" pristup i povećava prenos podataka.
- Indeks nad stranim ključem je često koristan, ali i tu se meri učestalost i veličina podataka.

## Radni proces

1. Zabeleži spor upit i poslovni cilj (npr. ekran mora ispod 200 ms).
2. Sačuvaj plan i merenje na realističnoj količini podataka.
3. Dodaj najmanji indeks koji odgovara tom obrascu.
4. Poredi plan i merenje pre/posle.
5. Prati cenu pisanja i ukloni indekse koje niko ne koristi.

Pokreni [praktičan primer](../sql/03-indexes-and-explain.sql). On namerno prvo prikazuje plan bez indeksa, zatim sa složenim indeksom.
