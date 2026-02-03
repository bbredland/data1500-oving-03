# data1500-oving-03
Oppgavesett 1.3 i DATA1500 våren 2026. Docker installasjon og introduksjon i databasehåndteringssystemer med fokus på databaseadministrasjon. I denne filen finnes det en del løsninger for situasjoner man kan komme opp i. Oppgaveteksten finnes i 4 filer:
- OPPGAVE1.md
- OPPGAVE2.md
- OPPGAVE3.md
- OPPGAVE4.md


## Spesialtegn verdt å huske på

OBS! I filstiene på Windows blir det brukt "slash" eller solidus U+002F og ikke "backslash" eller revers solidus U+005C, som blir brukt i macOS/Linux/Unix*
*Whitespace er U+0020. Kan bruke trim() metoden i Java for å fjerne whitespace.*

## Docker: nyttige kommandoer (muligens flytte ut til egen fil DOCKER-TIPS.md)

### dangling images

Med mye starting og stopping av containere, kan det oppstå situasjoner hvor systemet ikke klarer å være helt ferdig med noen prosesser, før nye prosesser blir startet. Da kan systemet (din datamaskin + Docker Desktop applikasjon) komme i utakt. En vanlig ting (kan også være andre ting) som oppstår er såkalte "dangling images", som får navn `<none>`. Vanligvis tar de ikke mye plass, men det kan hende at noen av disse kan blir store. Du kan bruke kommandoer på kommandolinje for å slette "dangling images", hvis du finner ut at det er mange av dem. Du kan se alle images som er lastet ned på din lokale maskin med kommandoen 

```bash
	$ docker image ls
```	

For å se om du har "dangling images" bruk kommandoen (ja, Docker har ikke vært konsekvent med flertall og entall for ordet `image`)
```bash
	$ docker images -f "dangling=true"
```

For å slette alle "dangling images" bruk kommandoen:
```bash
	$ docker image prune -f 
```

## kjøring av test-oppgave01.sh 

### MS Windows

POSIX-funksjonerer ikke "ut av hyllen" i Powershell, selv om Powershell prøver å starte GitBash for å utføre skriptet.

**Windows (PowerShell):**
```powershell
> Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
> .\test-local.ps1
```

**Problemer med UTF-8 i Windows Powershell**
Kan fikses når man lager skriptet på Linux/Unix. Den blir opprinneling UTF-8, men for Powershell trenges det UTF-8 med BOM (https://en.wikipedia.org/wiki/Byte_order_mark). Vanligvis trenger ikke studentene å tenke på det, hvis man i oppgave-repositorien har konvertert filen til UTF-8 med BOM format.
```bash
	$ iconv -f UTF-8 -t UTF-8 test-oppgave1.ps1 | sed '1s/^/\xef\xbb\xbf/' > test-oppgave1.ps1.tmp
	$ mv test-oppgave1.ps1.tmp test-oppgave1.ps1 
```

**Hvis man oppdaterer Powershell skript-fil**
Basert på ett eksperiment, ser det ut at hvis man gjør endringer i Powershell skript-filen, som er allerede konventert til BOM, forblir headeren i filen inntakt. Hvis man derimot overskriver filen 
Må også bruke .gitattributter for å styre linjeendingene for forskjellige plattformer.

## kjøring av sql-tester (i .sql filer)
### MS Windows og macOS
Lager en mappe som gir containeren tilgang til filer på vertsmaskinen. 

# Referanser
[1] https://en.wikipedia.org/wiki/Byte_order_mark
[2] https://en.wikipedia.org/wiki/Secure_Shell 

