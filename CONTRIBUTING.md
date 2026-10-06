# Kako dodajemo novo gradivo

[Srpski](CONTRIBUTING.md) | [English](CONTRIBUTING.en.md)

Ovaj repozitorijum je dugoročna zbirka SQL znanja. Svaki dodatak treba da bude mali, izvršiv, povezan sa postojećim gradivom i lak za ponavljanje za šest meseci — ne samo koristan danas.

Za brzi pregled sintakse koristi [SQL Cheat Sheet](resources/cheat-sheet.md); za redosled tema koristi [plan učenja](docs/00-plan-ucenja.md).

## 1. Prvo pronađi pravo mesto

Pre nego što napraviš datoteku, prođi kroz trenutni [plan učenja](docs/00-plan-ucenja.md), `docs/` i `sql/`.

| Ako dodaješ… | Gde pripada |
| --- | --- |
| objašnjenje jednog koncepta i razloga za upotrebu | `docs/` |
| kratak niz izvršivih primera uz lekciju | `sql/` |
| brzi podsetnik koji važi kroz više lekcija | `resources/` |
| zadatak za samostalno rešavanje | postojeći `practice/` format, kada je prisutan |
| složeniju temu ili projekat | postojeći `advanced/` format, kada je prisutan |

Ne dodaj novu lekciju ako je ista tema već obrađena. Umesto toga:

1. dodaj novi primer uz postojeću SQL datoteku samo ako stvarno produbljuje temu;
2. dodaj zaseban zadatak ako je cilj vežba, a ne nova teorija;
3. napravi novu numerisanu lekciju samo kada uvodi novu veštinu iz plana.

Kada `advanced/` ili `practice/` imaju svoj `README` ili lokalna pravila, ona imaju prednost za sadržaj u tim folderima.

## 2. Konvencija za kursne lekcije

Osnovni kurs koristi par datoteka sa istim brojem i slugom:

```text
docs/NN-naziv-teme.md
sql/NN-naziv-teme.sql
```

Pravila imenovanja:

- `NN` je sledeći slobodan dvocifreni broj i isti je u obe datoteke;
- koristi mala slova, crtice i ASCII naziv (`prozor-funkcije`, ne razmake ili specijalne znakove);
- naziv opisuje veštinu, ne slučajni primer (`agregacije`, ne `knjige-3`);
- ne menjaj numeraciju postojećih lekcija, jer linkovi i redosled učenja treba da ostanu stabilni.

Jedna lekcija pokriva jednu jasnu ideju. Ako tema zahteva više nezavisnih ciljeva, podeli je na manje lekcije ili je premesti u napredni deo kursa.

## 3. Minimalni sadržaj nove lekcije

Datoteka u `docs/` treba kratko da odgovori na:

```markdown
# NN — Naziv teme

## Šta ćeš naučiti

## Kada se koristi

## Pravila i česte greške

## Sledeći korak
```

Prateća datoteka u `sql/` treba da ima:

```sql
-- NN — Naziv teme
-- Cilj: jedna rečenica o rezultatu koji učenik treba da dobije.

-- Primer 1: najjednostavniji ispravan slučaj.

-- Primer 2: realan slučaj ili česta greška.

-- Zadatak za samostalan pokušaj (bez rešenja odmah ispod).
```

Ne stavljaj celu teoriju u SQL komentare i ne prepisuj iste SQL primere iz starijih datoteka. Dokument objašnjava odluku; SQL datoteka je kratka, pokretljiva demonstracija te odluke.

## 4. Pravila za zadatke i rešenja

Dobro formulisani zadatak ima četiri dela:

1. **Kontekst** — koje tabele i kolone učenik sme da koristi.
2. **Cilj** — kakav podatak treba dobiti, bez davanja rešenja u formulaciji.
3. **Ograničenja** — na primer: „koristi `LEFT JOIN`“, „bez podupita“ ili „vrati samo izdavače sa najmanje tri knjige“.
4. **Očekivani oblik rezultata** — nazivi kolona, redosled i, po potrebi, mali primer rezultata.

Rešenje čuvaj odvojeno od teksta zadatka ili iza jasno označenog dela „Rešenje“, kako bi učenik mogao prvo sam da pokuša. Rešenje treba da sadrži kratko obrazloženje izbora (`JOIN`, `WHERE`, `HAVING`…), ne samo finalni SQL.

Ako zadatak menja podatke, mora navesti da li je bezbedan za ponavljanje i kako se stanje vraća. Za nepromenljive vežbe preferiraj `SELECT`; za DML koristi transakciju, posebne test-redove ili reset bazu.

## 5. Izvršivost i bezbednost

Pre nego što dodatak smatraš gotovim, proveri:

- koristi samo tabele i kolone koje postoje u [pripremi baze](sql/00-priprema-baze.sql), ili zajedno dodaj jasno dokumentovanu migraciju/pripremu;
- svaki primer može da se pokrene na čistoj radnoj bazi ili je jasno označeno od čega zavisi;
- svaki `UPDATE` i `DELETE` ima namerno ograničen `WHERE` i prethodni kontrolni `SELECT`;
- primeri ne zahtevaju tajne, lične podatke ni spoljne servise;
- dijalekatske razlike (SQLite / PostgreSQL / MySQL) su označene tamo gde menjaju sintaksu ili rezultat;
- SQL je formatiran u više redova kada ima više klauzula, sa smislenim aliasima tabela.

## 6. Kontrolna lista pre završetka

- [ ] Tema nije duplikat postojeće lekcije ili zadatka.
- [ ] Naziv, broj i mesto datoteke prate postojeću konvenciju.
- [ ] Svaki novi link vodi na postojeću datoteku i relativan je u odnosu na dokument.
- [ ] SQL je ručno pokrenut nad radnom bazom ili je jasno navedeno zašto ne može da se pokrene samostalno.
- [ ] Objašnjene su najmanje jedna česta greška ili granica koncepta.
- [ ] Zadatak ne otkriva rešenje pre pokušaja.
- [ ] Izmene podataka su ponovljive, izolovane ili reverzibilne.
- [ ] Novi sadržaj dodaje stvarnu vrednost, a ne samo još jedan oblik iste sintakse.

## 7. Šta poslati uz novi zadatak

Najbrži način da se novi zadatak dobro smesti u kurs je da pošalješ:

```text
Tema: JOIN / agregacije / indeksi / …
Nivo: osnove / srednji / napredni
Cilj: šta želim da naučim ili proverim
Ograničenja: šta mora ili ne sme da se koristi
```

Ako nemaš sve detalje, dovoljan je i običan SQL upit ili opis problema. Zajedno ćemo odrediti da li pripada postojećoj lekciji, novom zadatku ili novoj temi kursa.
