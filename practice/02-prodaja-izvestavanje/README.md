# Projekat 02 — Prodajni izveštaji knjižare

> Napravi izveštaje kojima tim može da veruje: prihod, kupci, proizvodi, statusi i trendovi po mesecima.

[Engleska verzija →](../en/02-sales-reporting/README.md) · [Nazad na praksu](../README.md)

## Scenario

Internet knjižara je porasla dovoljno da ručno gledanje narudžbina više nije dovoljno. Vlasnik traži mesečni pregled prihoda, najprodavanije naslove, vrednost kupaca i stopu otkazivanja. Finansijski broj mora biti tačan čak i ako se cena knjige u katalogu kasnije promeni.

Ovaj projekat dodaje realističan skup narudžbina na početnu bazu. Pre rada obavezno pokreni `seed.sql`.

## Poslovne definicije

| Pojam | Pravilo u ovom projektu |
| --- | --- |
| Prepoznat prihod | Zbir `kolicina × cena_u_trenutku` samo za statuse `placena` i `poslata`. |
| Finalizovana narudžbina | Narudžbina sa statusom `placena` ili `poslata`. |
| Vrednost narudžbine | Zbir njenih stavki; ne prepisuje se iz `knjige.cena`. |
| Kupac bez prihoda | Kupac bez finalizovane narudžbine; mora ostati vidljiv tamo gde je zahtev „svi kupci”. |
| Mesec narudžbine | Prvih sedam znakova ISO datuma: `YYYY-MM`. |

## Zadaci

### Obavezni deo

| # | Zahtev | Ograničenje koje proverava znanje |
| --- | --- | --- |
| 1 | Napravi pogled `vw_praksa_prodaja_redovi`. | Jedan red mora predstavljati **jednu stavku narudžbine**, ne knjigu i ne celu narudžbinu. |
| 2 | Napravi mesečni prihod i broj finalizovanih narudžbina. | Najpre izračunaj iznos po narudžbini, pa tek onda grupiši po mesecu; time sprečavaš pogrešan broj narudžbina. |
| 3 | Napravi prihod po gradu kupca. | Prikaži i grad sa kupcima koji nisu doneli prihod. |
| 4 | Prikaži tri najbolje knjige po prihodu i prodatim primercima. | Knjige bez prodaje treba da mogu da se pojave u punom izveštaju sa nulama, čak i ako ih kasnije ograničiš na prva tri reda. |
| 5 | Rangiraj kupce po prepoznatom prihodu. | Koristi `DENSE_RANK()` i sačuvaj kupca bez prihoda u rezultatu. |
| 6 | Izračunaj mesečnu stopu otkazivanja. | Brojilac su samo `otkazana`, imenilac su sve narudžbine tog meseca; izbegni deljenje nulom. |

### Završni zadatak

7. Napravi pregled za vlasnika sa po jednim redom po mesecu: ukupan broj narudžbina, finalizovane narudžbine, prepoznat prihod, prosečna vrednost finalizovane narudžbine i kumulativni prihod. Koristi najmanje dva CTE-a i window funkciju za kumulativni zbir.

### Dodatni izazovi

8. Pokaži kupce koji su imali prvu finalizovanu kupovinu u datom mesecu, bez obzira na broj kasnijih kupovina.

9. Napiši upit koji proverava da li je neka stavka narudžbine skuplja ili jeftinija od **trenutne** kataloške cene. Ne označavaj takav red automatski kao grešku: istorijska cena može biti posledica akcije.

## Kriterijumi uspeha

- Posle učitavanja seeda imaš 7 kupaca i 12 narudžbina.
- Ukupan prepoznat prihod je **25.876,00**.
- U prihod nisu uključene narudžbine `nova` i `otkazana`.
- Izveštaj kupaca uključuje `Sara Savić` sa prihodom `0`.
- Mesečni prihod ima redove od `2026-01` do `2026-06`; za mart je kontrolni iznos **6.093,00**.
- Broj finalizovanih narudžbina ne sme biti uvećan brojem stavki u narudžbini.

## Tok rada

Iz korena repozitorijuma napravi čistu bazu i učitaj podatke:

```bash
sqlite3 practice.db < sql/00-priprema-baze.sql
sqlite3 practice.db < practice/02-prodaja-izvestavanje/seed.sql
sqlite3 practice.db
```

U SQLite konzoli:

```sql
.read practice/02-prodaja-izvestavanje/starter.sql
-- radi svoje upite
.read practice/02-prodaja-izvestavanje/verify.sql
```

Kada budeš zadovoljan/na svojim rešenjem, pogledaj [referentno rešenje](solution.sql). Ono je jedan čitljiv pristup, ne jedini ispravan pristup.

## Na šta posebno paziš

1. **Zrno upita.** `stavke_narudzbine` daje više redova po narudžbini. Ako odmah `COUNT(n.id)`, ista narudžbina može biti prebrojana više puta.
2. **Vreme filtera.** `WHERE n.status IN (...)` u CTE-u za finalizovane narudžbine je čistiji od filtriranja tek posle velikog spajanja.
3. **Nule naspram praznih vrednosti.** Poslovni izveštaj najčešće želi `0`, dok `NULL` znači „nepoznato” ili „ne postoji”.
4. **Status nije prihod.** Statusi se menjaju kroz životni ciklus narudžbine; definiciju prihoda uvek jasno napiši u upitu ili dokumentaciji.

Ako umeš da objasniš zašto se iznos po narudžbini računa pre mesečnog grupisanja, savladao/la si važan obrazac za gotovo svaki prodajni izveštaj.
