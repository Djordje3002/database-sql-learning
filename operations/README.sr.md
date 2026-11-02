# Operacije nad bazom

> **Srpski** · [English](README.md)

Rad sa bazom nije završen kada se upit izvrši lokalno. Ova staza uči navike koje štite podatke kada se šema menja, deployment padne ili je potreban oporavak.

| Vodič | Kada se koristi |
| --- | --- |
| [Backup, restore i oporavak](backup-and-restore.sr.md) | planiranje kopija ili dokaz da oporavak radi |
| [Migracije i bezbedan deployment](migrations-and-deployment.sr.md) | promena šeme ili isporuka aplikacije |

## Pravila bez izuzetka

1. Backup nije backup dok restore nije uspeo u izolovanom okruženju.
2. Svaka destruktivna radnja ima potvrđenu metu, vlasnika i put oporavka.
3. Promene šeme su migracije pod verzionom kontrolom, nikada nedokumentovane ručne izmene produkcije.
4. Kompatibilne promene kroz expand → migrate → contract smanjuju rizik deploymenta.
5. Produkcioni kredencijali imaju minimalna prava, rotiraju se i ne ulaze u kod ili logove.

Počni od [backupa i restore-a](backup-and-restore.sr.md), pa pređi na [vodič za migracije](migrations-and-deployment.sr.md).
