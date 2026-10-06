# 04 — Normalizacija i dizajn: podaci sa jednim izvorom istine

> **Srpski** · [English](../en/docs/04-normalization-and-design.md)

Normalizacija je način da se činjenica čuva na jednom logičnom mestu. Kada se ime izdavača upiše u svakom redu porudžbine, ispravka naziva zahteva mnogo izmena i lako ostavlja kontradiktorne vrednosti. Kada je izdavač zaseban entitet, promena postoji jednom.

## Počni od poslovnih činjenica

Pre `CREATE TABLE` napiši odgovore na sledeće:

- Koje stvari postoje nezavisno? (`kupac`, `knjiga`, `izdavač`, `porudžbina`)
- Šta jedinstveno identifikuje svaku stvar?
- Koja činjenica pripada kom entitetu?
- Kakav je odnos: jedan-prema-više ili više-prema-više?
- Koje pravilo mora važiti čak i ako aplikacija ima grešku?

Primer: izdavač objavljuje više knjiga, dok svaka knjiga u ovom modelu ima jednog izdavača. Porudžbina sadrži više stavki, a ista knjiga može biti u više porudžbina — to je veza više-prema-više rešena tabelom `stavke_narudzbine`.

## Normalne forme u praktičnom jeziku

| Nivo | Pitanje | Primer lošeg dizajna | Popravka |
| --- | --- | --- | --- |
| 1NF | Da li je svaka vrednost atomska? | `autori = 'Ivo, Meša'` u jednoj koloni | posebna tabela za vezu knjiga–autor |
| 2NF | Da li atribut zavisi od celog složenog ključa? | ime kupca u tabeli `(id_narudzbine, id_knjige)` | ime pripada `kupci`, ne stavci |
| 3NF | Da li atribut zavisi od drugog neključnog atributa? | grad izdavača uz svaku knjigu | grad pripada `izdavaci` |

Normalizacija nije religija. Cilj je pouzdan model koji se lako menja. Ponekad je namerno dupliranje opravdano — na primer `cena_u_trenutku` u stavci porudžbine čuva istorijski iznos, čak i ako se današnja cena knjige promeni.

## Ključevi i ograničenja su deo modela

```sql
CREATE TABLE stavke_narudzbine (
  id_narudzbine INTEGER NOT NULL,
  id_knjige      INTEGER NOT NULL,
  kolicina       INTEGER NOT NULL CHECK (kolicina > 0),
  cena_u_trenutku NUMERIC NOT NULL CHECK (cena_u_trenutku >= 0),
  PRIMARY KEY (id_narudzbine, id_knjige),
  FOREIGN KEY (id_narudzbine) REFERENCES narudzbine(id),
  FOREIGN KEY (id_knjige) REFERENCES knjige(id_knjige)
);
```

- `PRIMARY KEY` garantuje identitet reda.
- `FOREIGN KEY` štiti vezu od nepostojećeg roditelja.
- `NOT NULL`, `CHECK`, `UNIQUE` i `DEFAULT` pretvaraju poslovna pravila u proverljive granice.
- U SQLite-u uključi `PRAGMA foreign_keys = ON` na svakoj konekciji; bez toga se strani ključevi istorijski ne proveravaju podrazumevano.

## Šta ne treba raditi

```sql
-- Loše: lista vrednosti u tekstu nije veza koju baza može proveriti.
autori TEXT  -- npr. 'Ivo Andrić, Meša Selimović'

-- Loše: novac u binarnom realnom broju može dati neprijatna zaokruživanja.
cena REAL
```

Za novac često koristi najmanju jedinicu kao ceo broj (`cena_u_parama INTEGER`) ili tačan decimalni tip koji baza stvarno podržava. SQLite ima fleksibilan sistem tipova, pa kod novca posebno testiraj pravila aplikacije i konverzije.

## Odnos nije kolona sa listom

Veza više-prema-više dobija posredničku tabelu. Ona je pravo mesto i za podatke o samoj vezi: redosled autora, uloga autora, količina ili cena u trenutku kupovine.

```text
knjige  1 ───< knjige_autori >─── 1  autori

narudzbine  1 ───< stavke_narudzbine >─── 1  knjige
```

## Kada svesno denormalizovati

Tek kada imaš dokaz o uskom grlu, možeš čuvati izvedenu vrednost ili agregat za čitanje. Tada obavezno definiši:

1. izvor istine;
2. ko i kada osvežava kopiju;
3. kako se prati zastarelost;
4. kako se proverava konzistentnost;
5. kako se vraćaš na normalizovan izvor pri grešci.

Bez tog plana denormalizacija je samo buduća greška u podacima.

## Kontrolna lista za pregled šeme

- Svaka tabela opisuje jednu jasnu stvar ili vezu.
- Svaka činjenica ima vlasnika i ne kopira se bez razloga.
- Kodovi statusa imaju ograničen dozvoljeni skup ili referentnu tabelu.
- Vreme se čuva sa jasno definisanom vremenskom zonom/formatom.
- Brisanje roditelja ima namerno ponašanje (`RESTRICT`, `CASCADE`, `SET NULL`), ne podrazumevanje.
- Migracija ima plan za postojeće redove i povratak unazad.

Pokreni [primer normalizacije](../sql/04-normalization-and-design.sql). Prvo ćeš videti problematičnu "sirovu" tabelu, zatim mali model koji ga razdvaja.
