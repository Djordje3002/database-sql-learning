# Projekat 01 — Operacije biblioteke

> Od sirovih tabela do kataloga koji bibliotekar može stvarno da koristi.

[Engleska verzija →](../en/01-library-operations/README.md) · [Nazad na praksu](../README.md)

## Scenario

Preuzimaš internu bazu male biblioteke. Bibliotekar ne želi „sve tabele”, već odgovore na konkretna pitanja: koje knjige imamo, ko ih je napisao, kod kog su izdavača, šta se prodaje i gde fale podaci. Tvoj zadatak je da napraviš pouzdane upite za taj svakodnevni rad.

Radiš nad početnom šemom iz `sql/00-priprema-baze.sql`; za ovaj projekat nema dodatnih podataka. Nemoj menjati postojeće redove.

## Poslovna pravila

- Jedna knjiga pripada jednom izdavaču, a može imati više autora.
- Veza knjiga–autora je preko tabele `knjige_autori`.
- Knjiga bez zapisanog autora nije isto što i knjiga koja ne postoji: mora ostati vidljiva u katalogu.
- Prihod se računa samo za narudžbine sa statusom `placena` ili `poslata`.
- Za istorijsku prodaju koristi se `stavke_narudzbine.cena_u_trenutku`, nikada aktuelna `knjige.cena`.

## Model koji koristiš

```text
izdavaci 1 ───< knjige >───< knjige_autori >─── 1 autori
                         \
                          \
kupci 1 ───< narudzbine 1 ───< stavke_narudzbine >─── 1 knjige
```

## Zadaci

### Obavezni deo

| # | Zahtev | Šta treba da vratiš |
| --- | --- | --- |
| 1 | Katalog za pregled | ID, naziv knjige, izdavača, godinu izdanja, cenu i broj strana; sortiraj po nazivu knjige. |
| 2 | Pregled izdavača | Svakog izdavača i broj njegovih knjiga, uključujući izdavača bez ijedne knjige. |
| 3 | Kontrola autora | Knjige za koje ne postoji red u `knjige_autori`; nemoj sakriti takvu knjigu unutrašnjim `JOIN`-om. |
| 4 | Bibliografija | Jedan red po autoru: puno ime, broj knjiga i naslovi njegovih knjiga. Autor bez knjige treba da ostane u izveštaju. |
| 5 | Profil kupca | Za svakog kupca pokaži ukupan broj narudžbina, broj finalizovanih narudžbina i datum poslednje narudžbine. |
| 6 | Prodaja po knjizi | Sve knjige, broj prodatih primeraka i prepoznat prihod; knjiga bez prodaje mora imati nulu, ne `NULL`. |

### Završni zadatak

7. Napravi pogled `vw_praksa_katalog` koji za svaku knjigu izlaže: ID, naziv, izdavača, godinu, cenu i objedinjena imena autora. Zatim napiši upit koji pretražuje naslov, izdavača **ili** autora bez obzira na veličinu slova.

Pogled je dozvoljeno ponovo napraviti kroz `DROP VIEW IF EXISTS vw_praksa_katalog`; ne menjaj tabele početne baze.

### Dodatni izazov

8. Napiši jedan „data-quality” upit koji vraća knjige bez autora i izdavače bez knjiga, sa kolonom koja jasno govori o vrsti problema. Koristi `UNION ALL` samo ako zaista želiš da sačuvaš svaku pronađenu stavku.

## Kriterijumi uspeha

- U katalogu imaš svih 7 knjiga iz početne baze.
- U pregledu izdavača pojavljuje se i `Mali princ`, sa brojem `0`.
- Kontrola autora vraća `Uvod u baze podataka`.
- Prodaja po knjizi ne prikazuje `NULL` za količinu ili prihod.
- Prihod ne sadrži narudžbinu statusa `nova`; kontrolni zbir početne baze je **4.995,00**.
- Svako grupisanje koristi stabilan identifikator (`id`) uz tekst koji prikazuješ, kada je to potrebno.

## Tok rada

```bash
sqlite3 practice.db < sql/00-priprema-baze.sql
sqlite3 practice.db
```

U konzoli:

```sql
.read practice/01-biblioteka-operacije/starter.sql
-- svoje pokušaje možeš pisati ispod svakog zadatka ili u posebnom .sql fajlu
.read practice/01-biblioteka-operacije/verify.sql
```

Kada završiš, otvori [rešenje](solution.sql) i uporedi **logiku**: da li je tvoje zrno podataka isto, da li čuva redove bez povezanih podataka i da li filter statusa stoji na pravom mestu?

## Pitanja za proveru razmišljanja

- Zašto `COUNT(k.id_knjige)` daje dobar rezultat sa `LEFT JOIN`, a `COUNT(*)` ne bi dao nulu za izdavača bez knjige?
- Zašto se `WHERE n.status IN (...)` ne stavlja nepromišljeno posle `LEFT JOIN` kada želiš da sačuvaš kupce bez narudžbine?
- Šta bi se promenilo ako bi jedna knjiga imala tri autora i ti direktno sabereš prodaju posle spajanja sa `knjige_autori`?

Ovi detalji su važniji od pamćenja sintakse: oni sprečavaju tihe greške u izveštajima.
