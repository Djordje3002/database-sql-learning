# 05 — Pogledi i okidači: jasna apstrakcija, oprezna automatizacija

> **Srpski** · [English](../en/docs/05-views-and-triggers.md)

`VIEW` je sačuvani upit koji se prema čitaocu ponaša kao virtuelna tabela. `TRIGGER` je kod u bazi koji se izvršava kada se dogodi promena. Oboje mogu ukloniti ponavljanje, ali oboje mogu i sakriti složenost ako se koriste bez discipline.

## Pogled: ime za često korišćenu istinu

```sql
CREATE VIEW v_prodaja_po_knjizi AS
SELECT
  k.id_knjige,
  k.naziv,
  COUNT(s.id_narudzbine) AS broj_stavki,
  COALESCE(SUM(s.kolicina), 0) AS prodato_komada,
  COALESCE(SUM(s.kolicina * s.cena_u_trenutku), 0) AS prihod
FROM knjige AS k
LEFT JOIN stavke_narudzbine AS s ON s.id_knjige = k.id_knjige
GROUP BY k.id_knjige, k.naziv;
```

Pogled je dobar kada:

- isti čitljiv upit koristi više ekrana ili izveštaja;
- želiš sakriti neosetljive detalje i pokazati manji skup kolona;
- poslovni pojam (`prodaja po knjizi`) zaslužuje jedno, provereno značenje.

Pogled nije automatski brži. Običan `VIEW` uglavnom ponovo izvršava svoj upit. PostgreSQL ima materijalizovane poglede; SQLite nema ugrađeni `MATERIALIZED VIEW`, pa se za keširani rezultat projektuje posebna tabela i proces osvežavanja.

## Okidač: poslednja linija odbrane, ne skrivena aplikacija

Primeri opravdane upotrebe:

- audit zapis promene statusa;
- pravilo koje mora važiti za svakog klijenta baze;
- održavanje pažljivo definisane izvedene vrednosti kada je model već tako izabran.

Izbegni okidač kada poslovni tok može jasnije živeti u aplikacionom servisu ili eksplicitnoj transakciji. Skriveni lanac od pet okidača otežava debugovanje, testiranje i migracije.

## Bezbedan audit primer

```sql
CREATE TRIGGER trg_narudzbine_audit_status
AFTER UPDATE OF status ON narudzbine
FOR EACH ROW
WHEN OLD.status IS NOT NEW.status
BEGIN
  INSERT INTO audit_status_narudzbine (
    id_narudzbine, stari_status, novi_status, promenjeno_u
  ) VALUES (
    NEW.id, OLD.status, NEW.status, datetime('now')
  );
END;
```

`OLD` i `NEW` predstavljaju red pre i posle promene. Audit red pripada istoj transakciji: ako se spoljašnja izmena poništi, poništava se i audit koji je ona napravila. To je obično željeno.

## Pravila za održivost

1. Naziv govori tačno šta pogled ili okidač radi.
2. Svaki okidač ima test uspeha i test odbijanja.
3. Efekat okidača je mali i predvidljiv; ne šalje mrežne zahteve.
4. Ne krije ključne poslovne prelaze koje aplikacija mora prikazati korisniku.
5. Migracija prvo uklanja ili menja zavisnosti u pravilnom redosledu.

## Dijalekti

| Tema | SQLite | PostgreSQL | MySQL |
| --- | --- | --- | --- |
| `INSTEAD OF` okidač nad pogledom | podržan | podržan | ograničeno / zavisi od upotrebe |
| Okidač po iskazu | ne | da | da |
| Materijalizovani pogled | ne | da | ne ugrađeno |
| `RAISE(...)` iz okidača | da | koristi `RAISE EXCEPTION` u funkciji | koristi `SIGNAL` |

Pokreni [praktične primere](../sql/05-views-and-triggers.sql), pa promeni status porudžbine u transakciji i proveri da li je audit red ispravno poništen ili sačuvan.
