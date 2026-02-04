
--1. Hent alle studenter som ikke har noen emneregistreringer
SELECT s.fornavn, s.etternavn
FROM studenter s
LEFT JOIN emneregistreringer er ON s.student_id = er.student_id
GROUP BY s.student_id, s.fornavn, s.etternavn 
HAVING COUNT(er.registrering_id) < 1;

--2. Hent alle emner som ingen studenter er registrert på
SELECT e.emne_kode, e.emne_navn
FROM emner e
LEFT JOIN emneregistreringer er ON e.emne_id = er.emne_id
GROUP BY e.emne_id, e.emne_kode, e.emne_navn
HAVING COUNT(er.registrering_id) < 1;

--3. Hent studentene med høyeste karakter per emne
SELECT s.fornavn, s.etternavn, e.emne_navn, er.karakter
FROM studenter s
JOIN emneregistreringer er ON s.student_id = er.student_id
JOIN emner e ON e.emne_id = er.emne_id
GROUP BY s.student_id, s.fornavn, s.etternavn, e.emne_navn, er.karakter
HAVING er.karakter = 'A';

--4. Lag en rapport som viser hver student, deres program, og antall emner de er registrert på
SELECT s.fornavn, s.etternavn, s.program_id, COUNT(er.registrering_id) as antall_emner
FROM studenter s
LEFT JOIN emneregistreringer er ON s.student_id = er.student_id
GROUP BY s.student_id, s.fornavn, s.etternavn, s.program_id
ORDER BY s.student_id ASC;

--5. Hent alle studenter som er registrert på både DATA1500 og DATA1100
SELECT s.fornavn, s.etternavn
FROM studenter s
JOIN emneregistreringer er ON s.student_id = er.student_id
WHERE er.emne_id = 1

INTERSECT

SELECT s.fornavn, s.etternavn
FROM studenter s
JOIN emneregistreringer er ON s.student_id = er.student_id
WHERE er.emne_id = 2;


