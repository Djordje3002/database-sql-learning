# Osnovna pravila i sintaksa

> **Srpski** · [English](en/02-core-rules.md)

Najčešći oblik upita je:

```sql
SELECT kolone
FROM tabela
WHERE uslov
ORDER BY kolona ASC
LIMIT 10;
```

Pišemo ga tim redosledom, ali baza ga logički obrađuje ovako:

```text
FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT
```

Zato se alias iz `SELECT` uglavnom može koristiti u `ORDER BY`, ali ne i u `WHERE`.

## Pravila čitljivosti

- Jedna ideja po redu: svaka klauzula počinje u novom redu.
- Koristi alias tabele kod više tabela, npr. `knjige AS k`.
- Alias kolone daje čitljivo ime rezultatu: `COUNT(*) AS broj_knjiga`.
- Tekst piši u jednostrukim navodnicima: `'Derviš i smrt'`.
- Brojeve ne stavljaj pod navodnike osim kada kolona čuva tekst.

## `DISTINCT`, `ORDER BY` i `LIMIT`

- `DISTINCT` uklanja duplikate iz rezultata.
- `ORDER BY` sortira rezultat; `ASC` je rastuće, `DESC` opadajuće.
- `LIMIT` ograničava broj redova. U PostgreSQL i SQLite radi ovako; MySQL podržava isti oblik.

Ne pretpostavljaj podrazumevani redosled tabele. Ako je redosled bitan, uvek napiši `ORDER BY`.
