# Staza za testiranje i review baza

> **Srpski** · [English](README.md)

SQL koji izgleda ispravno nije dovoljan. Ova staza uči kako da dokažeš da šema, migracija, upit i proces oporavka zaslužuju poverenje.

| Materijal | Ishod |
| --- | --- |
| [Strategija testiranja](testing-strategy.sr.md) | biraš korisne testove šeme, podataka, upita, konkurentnosti i restore-a |
| [Kontrolna lista SQL review-a](sql-review-checklist.sr.md) | sistematski proveravaš tačnost, bezbednost, performanse i održavanje |
| [SQLite asercije](sql/sqlite-assertions.sql) | čitaš izvršive provere nad osnovnom bazom |
| [Test runner](run-sqlite-checks.sh) | lokalno pokrećeš asercije bez framework-a |

Lokalne provere pokrećeš ovako:

```bash
bash testing/run-sqlite-checks.sh
```

CI repozitorijuma pokreće iste provere. Za PostgreSQL/MySQL aplikacije dodaj integration testove nad izolovanom bazom ili branch-om; mock ne dokazuje plan, ograničenje, transakciju ili RLS policy specifičan za stvarni dijalekt.
