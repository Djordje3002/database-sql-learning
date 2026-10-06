# 02 — Transakcije i izolacija: ili je sve uspelo, ili ništa nije promenjeno

> **Srpski** · [English](../en/docs/02-transactions-and-isolation.md)

Transakcija je granica jedne poslovne operacije. Kreiranje porudžbine nije samo `INSERT` u jednu tabelu: nastaju zaglavlje, stavke, eventualna naplata i promena zalihe. Ako korak tri ne uspe, baza ne sme ostati u stanju "porudžbina postoji, ali nema stavke".

![Apstraktan tok upita i rezultata](../../assets/advanced-query-optimization.png)

## ACID bez magle

| Svojstvo | Praktično značenje |
| --- | --- |
| **Atomicity** | sve izmene transakcije prolaze zajedno ili se sve poništavaju |
| **Consistency** | posle uspeha važe ograničenja, strani ključevi i poslovna pravila |
| **Isolation** | paralelne operacije ne smeju da vide nedovršeno ili kontradiktorno stanje |
| **Durability** | posle potvrde (`COMMIT`) podatak preživljava pad procesa, prema garancijama sistema i podešavanja |

`COMMIT` potvrđuje, `ROLLBACK` vraća izmene od početka transakcije, a `SAVEPOINT` daje lokalnu tačku povratka unutar nje.

```sql
BEGIN;
  -- više provera i izmena
COMMIT;

-- ili, ako bilo koji korak ne može da se dovrši:
ROLLBACK;
```

## Anomalije paralelnog rada

| Problem | Primer | Tipična odbrana |
| --- | --- | --- |
| Prljavo čitanje | transakcija B vidi izmenu koju A kasnije poništi | odgovarajući isolation level; ne oslanjati se na necommitovane podatke |
| Neponovljivo čitanje | isti red ima novu vrednost pri drugom čitanju | ponovljivo čitanje, zaključavanje ili optimistička provera verzije |
| Fantomski redovi | ponovljeni upit vrati nove redove koji ranije nisu postojali | serijalizacija, pravilno zaključavanje ili preoblikovanje operacije |
| Izgubljena izmena | dve sesije pročitaju isto stanje i poslednja pregazi prvu | atomski `UPDATE`, zaključavanje ili `version` kolona |

Izolacija nije isto što i trajnost. Čak i u dobro izolovanoj transakciji aplikacija mora pravilno obraditi prekid mreže, timeout i ponavljanje zahteva.

## SQLite: šta je posebno

SQLite je datoteka, ne klasičan serverski sistem. Podržava atomske transakcije i čitanje tokom rada, ali za jednu bazu postoji samo jedan aktivni writer u trenutku. To je odličan izbor za lokalne alate, mobilne aplikacije i male do srednje radne tokove; za mnogo paralelnih upisa često je bolji serverski DBMS.

- `BEGIN` počinje odloženu transakciju.
- `BEGIN IMMEDIATE` odmah rezerviše nameru za pisanje i brže otkriva sukob writer-a.
- `BEGIN EXCLUSIVE` dodatno ograničava pristup; koristi samo kada zaista znaš zašto.
- `PRAGMA journal_mode = WAL` često poboljšava odnos čitanja i pisanja, ali nije zamena za dizajn konkurentnosti.

Nemoj držati transakciju otvorenom dok čekaš unos korisnika ili HTTP poziv. U transakciji ostaju samo provera podataka i izmene baze.

## Bezbedan obrazac za promenu statusa

```sql
BEGIN IMMEDIATE;

UPDATE narudzbine
SET status = 'placena'
WHERE id = :id_narudzbine
  AND status = 'nova';

-- Aplikacija mora proveriti da li je promenjen baš jedan red.
COMMIT;
```

Uslov nad starim stanjem sprečava da dva zahteva oba "uspešno" plate istu porudžbinu. Ovo je jednostavan primer optimističke kontrole konkurentnosti. U PostgreSQL-u možeš koristiti i `RETURNING`; MySQL i SQLite imaju svoje varijante zavisno od verzije.

## `SAVEPOINT` nije zamena za granicu posla

Koristi ga kada deo već započete operacije može bezbedno da se vrati, a ostatak da ostane:

```sql
BEGIN;
  INSERT INTO narudzbine (...);
  SAVEPOINT dodavanje_poklona;
    -- pokušaj opcionalne stavke
  ROLLBACK TO dodavanje_poklona;
  RELEASE dodavanje_poklona;
COMMIT;
```

Ne koristi `SAVEPOINT` da prikriješ greške koje bi trebalo prijaviti korisniku ili operateru.

## Kontrolna lista za produkciju

- Granica transakcije prati poslovni događaj, ne ekran ili API kontroler.
- Svaki `UPDATE` kritičnog stanja proverava broj promenjenih redova.
- Zahtev za plaćanje, slanje mejla ili poruku u queue ne ostavlja bazu napola izmenjenu; projektuj idempotentnost ili outbox obrazac.
- Greške se vraćaju korisniku razumljivo, dok se tehnički detalji beleže bez tajni.
- Testiraj uspeh, `ROLLBACK`, dupli zahtev i prekid u sred operacije.

Pokreni [SQL vežbu](../sql/02-transactions-isolation.sql) i posmatraj stanje pre potvrde, posle `ROLLBACK` i posle `COMMIT`.
