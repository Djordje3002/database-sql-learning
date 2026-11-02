# Migracije i bezbedan deployment

> **Srpski** · [English](migrations-and-deployment.md)

## Obrazac expand → migrate → contract

Izbegni izdanje koje istovremeno promeni kod aplikacije i pokvari staru šemu.

1. **Expand:** dodaj nullable kolonu, novu tabelu ili indeks kroz kompatibilnu migraciju.
2. **Migrate:** isporuči kod koji upisuje obe reprezentacije; radi backfill u malim, merljivim grupama.
3. **Verify:** uporedi zbirove, greške i planove upita; prebaci čitanja na novu reprezentaciju.
4. **Contract:** ukloni staru kolonu/put tek kada nijedna aktivna verzija aplikacije ili job više ne zavisi od nje.

Primer: `customers.full_name` prelazi u `first_name` i `last_name`. Ne radi rename i deployment kao jednu nepovratnu radnju. Dodaj nove kolone, uradi backfill, dual-write, prebaci čitanja i tek kasnije ukloni staru kolonu.

## PostgreSQL pravila za migracije

- Jedan uređen direktorijum migracija je u verzionoj kontroli; produkcija svaku primeni jednom i pamti verziju.
- `CREATE INDEX CONCURRENTLY` manje blokira, ali ne radi unutar transakcije; treba mu zasebna migracija i retry plan.
- Veliko ograničenje dodaj oprezno. Postojeće redove po potrebi validiraj odvojeno:

```sql
ALTER TABLE public.orders
  ADD CONSTRAINT orders_total_nonnegative CHECK (total_cents >= 0) NOT VALID;
ALTER TABLE public.orders
  VALIDATE CONSTRAINT orders_total_nonnegative;
```

- PostgreSQL nema `ADD CONSTRAINT IF NOT EXISTS`. Za idempotentnu migraciju proveri `pg_constraint` u `DO` bloku; još bolje, verzionu migraciju pokreni tačno jednom.
- Za migracionu sesiju svesno postavi `lock_timeout` i `statement_timeout` da problem bude vidljiv, umesto da deployment tiho blokira produkciju.

## Kontrolna lista deploymenta

- [ ] Migracija je proverena nad backupom ili branch-om sličnim produkciji.
- [ ] Dokumentovan je period kompatibilnosti: stara aplikacija ↔ nova šema i nova aplikacija ↔ stara šema.
- [ ] Backup/restore je zelen pre promene šeme.
- [ ] Proveren je uticaj plana upita i indeksa na kritične putanje.
- [ ] Provereni su limiti poolera i prava role.
- [ ] Postoji feature flag ili rollback plan za promenu ponašanja.
- [ ] Alerti pokrivaju greške, latenciju, zasićenje, zdravlje replike/backupa i trajanje migracije.

Rollback nije uvek „pokreni obrnuti SQL”: destruktivna transformacija podataka može biti nepovratna. Daj prednost forward fix-u, sačuvaj izvorne podatke do provere i uvežbaj odluku pre incidenta.
