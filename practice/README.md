# Praktični SQL kurs

> Uči SQL tako što rešavaš zahteve koji liče na stvarni posao: katalog biblioteke, prodajni izveštaji i analitika ponašanja kupaca.

[English practice guide →](en/README.md)

Ovaj direktorijum je laboratorija kursa. Teorija iz `docs/` objašnjava *zašto*, a ovde svaku temu pretvaraš u mali, proverljiv projekat. Projekti su poređani po težini i oslanjaju se na SQLite bazu iz glavnog kursa.

## Kako radiš projekte

1. Napravi odvojenu radnu bazu — tako su pokušaji bezbedni i ponovljivi.
2. Učitaj osnovnu šemu iz `sql/00-priprema-baze.sql`.
3. Pročitaj `README.md` projekta, pa rešavaj redom iz `starter.sql`.
4. Pokreni `verify.sql` tek kada misliš da si završio/la.
5. Uporedi pristup sa `solution.sql`, ne samo konačan rezultat.

```bash
# iz korena repozitorijuma
sqlite3 practice.db < sql/00-priprema-baze.sql
sqlite3 practice.db
```

U SQLite konzoli učitavaš datoteke ovako:

```sql
.read practice/01-biblioteka-operacije/starter.sql
```

Za drugi i treći projekat prvo se učitava i njihov `seed.sql`. Svaki seed koristi `INSERT OR IGNORE`, pa ga možeš bezbedno pokrenuti više puta nad istom radnom bazom.

## Putanja kroz praksu

| Projekat | Scenario | Glavne veštine | Težina |
| --- | --- | --- | --- |
| [01 — Operacije biblioteke](01-biblioteka-operacije/README.md) | Katalog i zahtevi bibliotekara | `SELECT`, `JOIN`, `LEFT JOIN`, `GROUP BY`, pogled (`VIEW`) | Početna → srednja |
| [02 — Prodajni izveštaji](02-prodaja-izvestavanje/README.md) | Dashboard internet knjižare | CTE, uslovna agregacija, vremenske serije, window funkcije | Srednja |
| [03 — Analitika i kvalitet podataka](03-analitika-kvalitet/README.md) | Funnel, kohorte i provera podataka | višeslojni CTE, funnel, segmentacija, data-quality pravila | Napredna |

## Pravila rada kao u timu

- **Ne menjaj istorijsku cenu stavke.** Izveštaji koriste `stavke_narudzbine.cena_u_trenutku`, ne trenutnu cenu iz `knjige`.
- **U prihod računaj samo finalizovane narudžbine.** U ovom modelu to su statusi `placena` i `poslata`; `nova` i `otkazana` nisu prihod.
- **Pazi na zrno podataka.** Pre sabiranja napiši sebi: „Da li ovaj red predstavlja narudžbinu, stavku ili sesiju?” Pogrešan `JOIN` lako duplira iznos.
- **`LEFT JOIN` je nameran izbor.** Njime čuvaš izdavače bez knjiga, kupce bez kupovine i knjige bez prodaje.
- **Dok radiš izmene, koristi transakciju.** Pre `UPDATE` ili `DELETE` prvo proveri isti `WHERE` uslov kroz `SELECT`.
- **Rešenje nije prvi korak.** Probaj samostalno najmanje 20–30 minuta, zapiši pretpostavke, pa tek onda otvori rešenje.

## Šta se proverava

Svaki projekat ima tri nivoa završetka:

1. **Tačnost** — vraćaš tražene redove i kolone.
2. **Otpornost** — upit radi i kada postoji nula knjiga, nula prodaja ili `NULL` vrednost.
3. **Čitljivost** — koristiš alias-e, jasne CTE nazive i logičan redosled kolona.

`verify.sql` ne ocenjuje tvoj fajl automatski; daje kontrolne brojeve i liste koje upoređuješ sa svojim rezultatom. To je namerno: u stvarnom poslu SQL se proverava poslovnim pravilima, a ne samo time da li se upit izvršio.

## Predlog ritma

- Prvi prolazak: reši zadatke bez gledanja rešenja.
- Drugi prolazak: napiši isto rešenje drugačijim pristupom, na primer podupit umesto CTE-a.
- Treći prolazak: objasni naglas zašto svaki `JOIN`, filter i `GROUP BY` postoji.
- Kada dodaš novi zadatak, stavi ga u odgovarajući projekat ili otvori sledeći numerisani projekat sa istom strukturom: `README.md`, `seed.sql` po potrebi, `starter.sql`, `solution.sql`, `verify.sql`.

---

Počni sa [projektom 01](01-biblioteka-operacije/README.md), a zatim nastavi redom. Cilj nije da zapamtiš sintaksu, nego da naučiš da od nejasnog poslovnog pitanja napraviš pouzdan upit.
