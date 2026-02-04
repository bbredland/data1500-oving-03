# Besvarelse av refleksjonsspørsmål - DATA1500 Oppgavesett 1.3

Skriv dine svar på refleksjonsspørsmålene fra hver oppgave her.

---

## Oppgave 1: Docker-oppsett og PostgreSQL-tilkobling

### Spørsmål 1: Hva er fordelen med å bruke Docker i stedet for å installere PostgreSQL direkte på maskinen?

**Ditt svar:**

I Docker kan man kjøre programmet uten å være redd for å påvirke resten av systemet. Da har man også bedre kontroll av hvordan systemet fungerer.

---

### Spørsmål 2: Hva betyr "persistent volum" i docker-compose.yml? Hvorfor er det viktig?

**Ditt svar:**

Det er en lagringsplass utenfor Dockeren. Det gjør at man ikke mister den dataen når man stopper eller fjerner dockeren. Man vil beholde dataen selv om man restarter den.

---

### Spørsmål 3: Hva skjer når du kjører `docker-compose down`? Mister du dataene?

**Ditt svar:**

Dataen er lagret på maskinen ved bruk av "persistent volum". Men man vil vanligvis miste data hvis man ikke har en slik løsning.

---

### Spørsmål 4: Forklar hva som skjer når du kjører `docker-compose up -d` første gang vs. andre gang.

**Ditt svar:**

Første gang må docker bygge opp en ny container og laste ned alle bilder. Den andre gangen trenger docker bare å laste opp fra persistent volum istedenfor å lage helt nytt.

---

### Spørsmål 5: Hvordan ville du delt docker-compose.yml-filen med en annen student? Hvilke sikkerhetshensyn må du ta?

**Ditt svar:**

Jeg ville delt gjennom Github eller Mail eller en annen sikker måte. Også ville jeg passet på at jeg ikke gir bort sensitiv data.

---

## Oppgave 2: SQL-spørringer og databaseskjema

### Spørsmål 1: Hva er forskjellen mellom INNER JOIN og LEFT JOIN? Når bruker du hver av dem?

**Ditt svar:**

INNER JOIN returnerer kun rader som har match i begge tabeller. og brukes når du kun vil ha rader som faktisk hører sammen.
LEFT JOIN returnerer alle rader fra venstre tabell selv om det ikke er en match. Manglende data fylles med "null". Det er fint å bruke når man vil beholde alle radene fra venstre tabell.

---

### Spørsmål 2: Hvorfor bruker vi fremmednøkler? Hva skjer hvis du prøver å slette et program som har studenter?

**Ditt svar:**

Fremmednøkler sørger for at data henger sammen på en gyldig måte. Databasen vil hindre slettingen og gi feil. 

---

### Spørsmål 3: Forklar hva `GROUP BY` gjør og hvorfor det er nødvendig når du bruker aggregatfunksjoner.

**Ditt svar:**

GROUP BY sorterer radene og er nødvendig for aggregatfunksjoner fordi databasen må vite hvordan radene skal grupperes før de kan summeres eller telles. 
Uten group by ville databasen kun gitt et samlet svar istedenfor blandet på radene

---

### Spørsmål 4: Hva er en indeks og hvorfor er den viktig for ytelse?

**Ditt svar:**

En indeks er en datastruktur. Det gjør at databasen kan søke direkte på indeksen istedenfor å søke gjennom hele rader.

---

### Spørsmål 5: Hvordan ville du optimalisert en spørring som er veldig treg?

**Ditt svar:**

Legge til indekser og passe på at jeg ikke henter opp for mye data på en gang.

---

## Oppgave 3: Brukeradministrasjon og GRANT

### Spørsmål 1: Hva er prinsippet om minste rettighet? Hvorfor er det viktig?

**Ditt svar:**

Det handler om at en bruker eller rolle ikke får tilgang til mer enn nødvendig. Det handler om sikkerhet og informasjonstilgang.

---

### Spørsmål 2: Hva er forskjellen mellom en bruker og en rolle i PostgreSQL?

**Ditt svar:**

Roller er rettigheter og regler for enkelte grupper. En bruker er en person som er tildelt rolle. 

---

### Spørsmål 3: Hvorfor er det bedre å bruke roller enn å gi rettigheter direkte til brukere?

**Ditt svar:**

Istedenfor å måtte administrere mange brukere kan man gi rettigheter til en rolle og brukerne kan arve rettighetene direkte fra rollen. Da har man mye bedre oversikt og.

---

### Spørsmål 4: Hva skjer hvis du gir en bruker `DROP` rettighet? Hvilke sikkerhetsproblemer kan det skape?

**Ditt svar:**

DROP kan slette tabeller, views, funksjoner eller hele databaser. Det kan skape masse sikkerhetsbrudd og massetap av viktig informasjon og data.

---

### Spørsmål 5: Hvordan ville du implementert at en student bare kan se sine egne karakterer, ikke andres?

**Ditt svar:**

Jeg ville laget en VIEW som sjekker at current_user = student_id; Derifra ville jeg vist informasjonen fra emneregistreringer. 

---

## Notater og observasjoner

Bruk denne delen til å dokumentere interessante funn, problemer du møtte, eller andre observasjoner:

Foreleser_role har ikke tilgang til DELETE.
Student_role har ikke tilgang til INSERT eller UPDATE.

Jeg så egentlig ikke denne delen før jeg var ferdig med alt.
Jeg trengte ikke skrive inn noe passord når jeg logget inn på noen roller. Jeg vet ikke helt hvorfor, men jeg ville tippet det var siden den ser jeg er host til docker og databasen.



## Oppgave 4: Brukeradministrasjon og GRANT

1. **Hva er Row-Level Security og hvorfor er det viktig?**
   - RLS er en mekanisme i PostgreSQL som gjør at man kan kontrollere hvilke rader brukere har tilgang til. Istedenfor at man har tilgang til hele tabeller. 
   - RLS beskytter data og implementerer sikkerhet i databasen. 

2. **Hva er forskjellen mellom RLS og kolonnebegrenset tilgang?**
   - RLS styrer hvilker rader man får lov til å se.
   - Kolonne.. bestemmer hvilke kolonner man får lov til å se. 

3. **Hvordan ville du implementert at en student bare kan se karakterer for sitt eget program?**
   - Da ville jeg laget en policy som sjekker at program_id matcher Current_user sitt program.

4. **Hva er sikkerhetsproblemene ved å bruke views i stedet for RLS?**
   - Views er et logisk filter, mens RLS er en sikkerhetsmekanisme.
   - Views beskytter kun mot SELECT. 

5. **Hvordan ville du testet at RLS-policyer fungerer korrekt?**
   - Sjekke at policyen står i pg_policies. 
   - Logge inn som forskjellige roller og kjøre noen tester.

---

## Referanser

- PostgreSQL dokumentasjon: https://www.postgresql.org/docs/
- Docker dokumentasjon: https://docs.docker.com/

