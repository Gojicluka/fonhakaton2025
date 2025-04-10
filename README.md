# fonhakaton2025

Bloquest to-do 10/4/25:

## newTaskScreen
- napraviti da se otvara sa parametrom javno/grupa
- napraviti API za predetermined tasks koji koristi ^^ parametar

## profilePage
- ucitati user_ach, ach, i skill poene prilikom loadovanja
- napraviti dobar displej ^

## myTasksPage
- [x] videti zasto evaluacija zadataka (accept/deny) ne radivideti zasto evaluacija zadataka (accept/deny) ne radi
- implementirati "confirm outcome" zadatka => prenosi zadatak u pending_delete status + dodeljuje XP ako je zadatak uspesno uradjen => i sve druge provere (OPISANE U SISTEM LVL-ACH VVV)
- redizajnirati da podrzi lukin meni kao za filtere
- napraviti da koristi boje taska (+ ikonice?)

## sistem lvl-ach
- implementirati tabele
- implementirati funkcije koje izvrsavaju logiku: azuriranje xp => provera i azuriranje lvl-up + provera i azuriranje user_ach

## task sistem
- promisliti o cemu vodimo evidenciju (ppl needed / ppl doing / ppl submitted) i sta prikazujemo korisniku.

## user sistem
- promeniti PK u INT/UUID umesto NICKNAME, i azurirati sve tabele.

## leaderboard
- nek bude po XP kriterijumu => implementirati fju koja sortira i vraca korisnike po broju XP-a.

## registracija + verifikacija
- sign-in forma
- verifikacija uzivo na faksu => interfejs verifikatorima

## report sistem
- prijavi zadatak / prijavi korisnika (koji je uradio zadatak) / prijavi igraca koji je rangirao izvrsenost zadatka