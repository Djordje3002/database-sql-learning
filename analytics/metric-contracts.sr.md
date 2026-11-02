# Ugovori metrika

> **Srpski** · [English](metric-contracts.md)

Ugovor metrike čini broj sa dashboarda ponovljivim. Čuvaj ga uz upit, semantički sloj ili definiciju modela.

| Polje | Primer: priznati prihod |
| --- | --- |
| Vlasnik | Finance analytics |
| Zrno | jedna narudžbina |
| Formula | `SUM(revenue_cents)` |
| Uključivanje | statusi `paid` i `shipped` |
| Isključivanje | `new`, `cancelled`, refund osim ako je eksplicitno modelovan |
| Vreme | datum završetka narudžbine, UTC reporting zona |
| Svežina | podaci kompletni do poslednjeg uspešnog pipeline-a |
| Validacija | poređenje dnevnog zbira sa payment settlement-om i alarm na odstupanje |

Izbegni oznake kao „sales” ili „active users” bez definicije. Dva sintaksno ispravna SQL upita mogu dati različite brojeve jer kodiraju različita poslovna značenja.
