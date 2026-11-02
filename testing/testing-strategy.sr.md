# Strategija testiranja baze

> **Srpski** · [English](testing-strategy.md)

## Testiraj na granici gde bi greška bila skupa

| Sloj | Šta dokazuješ | Primer |
| --- | --- | --- |
| šema | nevalidno stanje je odbijeno | negativna cena krši `CHECK` |
| migracija | stari podaci bezbedno stižu do novog oblika | backfill se može nastaviti i brojevi se usaglašavaju |
| upit | zrno rezultata i zbirovi su tačni | jedna narudžbina se broji jednom iako ima više stavki |
| transakcija | delimičan rad ne ostaje | neuspešan checkout ne umanjuje zalihu |
| konkurentnost | paralelni zahtevi čuvaju pravila | dve rezervacije se ne preklapaju |
| pristup | rola/tenant vidi samo dozvoljene redove | RLS odbija nedostajući tenant kontekst |
| oporavak | podaci se vraćaju unutar cilja | periodična restore vežba prolazi |

## Dizajn fixture-a

Mali fixture namerno sadrži: nula povezanih redova, više povezanih redova, `NULL`, slične nazive sa različitim ID-jevima, izjednačene vrednosti sortiranja, odbijeni status i granično vreme. Fixture sa samo srećnim slučajevima ne otkriva loš join ili filter.

## Asercije naspram snapshot-a

Aserciju koristi za poslovno pravilo (`prihod = 4.995` nad poznatim podacima). Snapshot koristi pažljivo za veći oblik izveštaja. Snapshot može normalizovati pogrešan rezultat ako se prihvati bez review-a.

Za migracije testiraj i čistu instalaciju i upgrade sa reprezentativne ranije verzije. Kod visokorizične promene testiraj rollback ili put forward fix-a pre produkcije.
