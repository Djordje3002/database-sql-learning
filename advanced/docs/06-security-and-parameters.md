# 06 — Bezbednost baze: parametri, najmanje privilegije i zdrave granice

> **Srpski** · [English](../en/docs/06-security-and-parameters.md)

Bezbednost SQL-a nije jedna komanda. Ona je lanac odluka: kako aplikacija šalje upit, kojim nalogom se povezuje, šta loguje, ko čita kopije podataka i šta se dešava kada unos nije očekivan.

## Pravilo broj jedan: vrednost nikada nije deo SQL teksta

Loš obrazac spaja korisnički unos sa tekstom upita:

```text
"SELECT * FROM kupci WHERE email = '" + email + "'"
```

Ako `email` sadrži znak navoda i SQL izraz, promenio je značenje komande. Escaping je krhak i zavisi od dijalekta. Rešenje su **parametrizovani upiti**: SQL i vrednosti putuju odvojeno.

```python
# Python sqlite3 — ? je mesto za vrednost, ne ručno umetanje teksta.
db.execute(
    "SELECT id, ime, email FROM kupci WHERE email = ?",
    (email,),
)
```

```javascript
// PostgreSQL biblioteka pg — $1 je parametar vrednosti.
await client.query(
  'SELECT id, ime, email FROM kupci WHERE email = $1',
  [email],
);
```

Mesto za parametar radi za vrednosti, ne za identifikatore poput imena kolone, pravca sortiranja ili imena tabele. Kada je to dinamičko, koristi strogu dozvoljenu listu u kodu:

```text
dozvoljeno_sortiranje = {"datum": "datum", "iznos": "ukupan_iznos"}
izabrana_kolona = dozvoljeno_sortiranje[korisnicki_izbor]
```

Nakon toga se samo vrednosti i dalje šalju kao parametri. Nikada ne prosleđuj proizvoljan tekst kao SQL identifikator.

## Najmanje privilegije

Nalog aplikacije dobija samo ono što konkretan servis koristi:

- servis kataloga: čitanje javnih podataka;
- servis porudžbina: potrebne izmene porudžbina, bez administracije korisnika;
- migracioni proces: privremeno šira prava, odvojene tajne;
- analitika: po mogućstvu pogled sa maskiranim podacima, ne sirove lične podatke.

SQLite nema model korisnika i `GRANT` naredbe unutar datoteke baze. Kontrola pristupa se tada nalazi u operativnom sistemu, aplikaciji i načinu na koji se datoteka distribuira. PostgreSQL i MySQL imaju korisnike, role i privilegije — konfiguracija prava treba da bude deo infrastrukture kao koda.

## Podaci, tajne i evidencija

- Ne čuvaj lozinke kao običan tekst; koristi namenski adaptivni algoritam za heširanje lozinki.
- Ne upisuj lozinke, tokene, pune kartične podatke ili ceo SQL sa privatnim parametrima u logove.
- Šifruj saobraćaj do serverske baze i zaštiti backup kopije istim standardom kao primarne podatke.
- Rotiraj tajne, ograniči njihov pristup i odvoji razvojne od produkcionih vrednosti.
- Za lične podatke odredi rok čuvanja, minimizuj prikupljanje i dokumentuj ko sme da ih čita.

## Odbrana u slojevima

| Sloj | Pitanje | Primer kontrole |
| --- | --- | --- |
| Aplikacija | Da li je unos validan za poslovni tok? | dozvoljena dužina, format, stanje porudžbine |
| API | Da li korisnik sme baš ovu radnju? | autentikacija i autorizacija po objektu |
| SQL poziv | Da li vrednost može promeniti sintaksu? | pripremljen upit / bind parametar |
| Baza | Da li je nemoguće upisati nevalidno stanje? | `NOT NULL`, `CHECK`, strani ključ, prava |
| Operacije | Možemo li otkriti i oporaviti incident? | audit, monitoring, testiran restore bekapa |

## Bezbednosna kontrolna lista pre puštanja

- [ ] Svi spoljašnji ulazi kao vrednosti koriste bind parametre.
- [ ] Dinamički identifikatori prolaze kroz dozvoljenu listu.
- [ ] Aplikacioni nalog nema administratorska prava.
- [ ] Greške ka klijentu ne otkrivaju SQL, šemu ili tajne.
- [ ] Bekap se može stvarno vratiti u test okruženje.
- [ ] Zavisnosti baze i drajvera se redovno ažuriraju.

Pogledaj [praktične obrasce](../sql/06-security-and-parameters.sql). Namerno opasni primeri ostavljeni su zakomentarisani — nikada ih ne pokreći na stvarnoj bazi.
