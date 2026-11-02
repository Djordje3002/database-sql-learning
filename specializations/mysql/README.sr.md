# MySQL 8 staza

> **Srpski** · [English](README.md)

Ova staza pokriva MySQL 8+ i InnoDB posle zajedničkih SQL osnova. Pristup je poređenje u praksi: MySQL deli većinu sintakse sa PostgreSQL-om i SQLite-om, ali se razlikuje u sintaksi procedura, JSON radu, generisanim kolonama, indeksima, transakcijama i alatima za plan upita.

## Pokretanje lokalno

Koristi zasebnu lokalnu MySQL bazu:

```bash
mysql -u root -p -e 'CREATE DATABASE sql_learning_mysql'
mysql -u root -p sql_learning_mysql < sql/00-mysql-schema.sql
mysql -u root -p sql_learning_mysql < sql/01-windows-json-and-cte.sql
mysql -u root -p sql_learning_mysql < sql/02-procedures-and-transactions.sql
mysql -u root -p sql_learning_mysql < sql/03-performance-and-indexes.sql
```

Priprema briše samo tabele sa prefiksom `learning_` u izabranoj bazi. Nikada je ne pokreći nad produkcionom bazom.

## Moduli

| # | Fokus | Bitna razlika | Vežba |
| --- | --- | --- | --- |
| 00 | InnoDB šema | `BIGINT` auto increment, `DECIMAL`, `DATETIME`, generisane kolone | [priprema](sql/00-mysql-schema.sql) |
| 01 | Savremeni upiti | CTE, window funkcije, `JSON_EXTRACT`, `JSON_TABLE` | [upiti](sql/01-windows-json-and-cte.sql) |
| 02 | Procedure i transakcije | `DELIMITER`, `SIGNAL`, eksplicitna granica transakcije | [procedure](sql/02-procedures-and-transactions.sql) |
| 03 | Performanse | složeni indeksi, `EXPLAIN ANALYZE`, nema ugrađenih parcijalnih indeksa | [performanse](sql/03-performance-and-indexes.sql) |

## MySQL navike za produkciju

- Koristi InnoDB zbog transakcija, stranih ključeva i row-level zaključavanja.
- Za novac koristi `DECIMAL(p,s)` ili celobrojne manje jedinice, nikada `FLOAT` ili `DOUBLE`.
- Indeksiraj strane ključeve i stvarne upite. U složenom indeksu jednakosti uglavnom idu pre raspona/sortiranja.
- Čitaj `EXPLAIN ANALYZE`, ne nagađaj. `EXPLAIN` procenjuje; `ANALYZE` izvršava i prikazuje stvarni rad.
- MySQL nema PostgreSQL-ov parcijalni indeks. Za selektivan pristup razmisli o generisanoj koloni i složenom indeksu, ali najpre izmeri.
- Transakcije drži kratkim; ne zaključavaj red dok aplikacija čeka drugi servis.

Pogledaj i [PostgreSQL stazu](../postgresql/README.sr.md) i [operativne vodiče](../../operations/README.sr.md).
