# Backup, restore i oporavak

> **Srpski** · [English](backup-and-restore.md)

## Cilj oporavka

Pre izbora alata definiši dva broja:

- **RPO** (Recovery Point Objective): koliko najnovijih podataka sme da se izgubi.
- **RTO** (Recovery Time Objective): koliko dugo servis sme da bude nedostupan.

Tako „treba nam backup” postaje konkretan zahtev. Dnevni dump ne može ispuniti RPO od pet minuta, a restore koji traje šest sati ne ispunjava RTO od jednog sata.

## PostgreSQL: logički backup i vežba restore-a

```bash
pg_dump --format=custom --file=app-2026-11-02.dump --dbname="$DATABASE_URL"
createdb app_restore_test
pg_restore --dbname=app_restore_test --verbose app-2026-11-02.dump
psql -d app_restore_test -c '\dt'
psql -d app_restore_test -c 'SELECT COUNT(*) FROM public.orders;'
```

Restore pokreći samo u novoj, potrošnoj test bazi. `pg_restore --clean` briše objekte i ne sme se koristiti dok nije potvrđena tačna meta. Za veće sisteme kombinuj logičke kopije, backup provajdera i point-in-time recovery, pa redovno vežbaj oba puta.

## MySQL: konzistentan InnoDB dump i restore

```bash
mysqldump --single-transaction --routines --triggers --databases app_db > app-2026-11-02.sql
mysql -e 'CREATE DATABASE app_restore_test'
mysql app_restore_test < app-2026-11-02.sql
mysql app_restore_test -e 'SELECT COUNT(*) FROM orders;'
```

`--single-transaction` daje konzistentan snimak za InnoDB tabele, ali ne čini netransakcione tabele konzistentnim. Uvek proveri stvarni engine i ponašanje provajdera.

## Kontrolna lista oporavka

- Šifruj kopije pri prenosu i u skladištu; ograniči ko sme da ih čita.
- Drži kopiju u zasebnoj zoni kvara od primarne baze.
- Beleži uspeh, veličinu, trajanje i checksum; alarmiraj izostanak ili anomaliju.
- Periodično radi restore u izolovanom okruženju i proveri šemu i poslovne zbirne vrednosti.
- Za svaki hitni restore zapiši vlasnika, komandu, metu i vreme.
- Ne vežbaj produkcionim kredencijalima u istoriji komandi developerskog računara.
