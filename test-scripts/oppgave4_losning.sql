--1.Implementer RLS på studenter-tabellen slik at studenter bare ser sitt eget data 
--Hint: Bruk samme pattern som emneregistreringer
ALTER TABLE studenter ENABLE ROW LEVEL SECURITY;
--ALTER TABLE
CREATE POLICY student_see_own_data ON studenter
FOR SELECT 
TO student_role
    USING (
        student_id = (
            SELECT student_id FROM bruker_student_mapping
            WHERE brukernavn = current_user
            )
    );
--CREATE POLICY

--2.Opprett en policy som tillater foreleser å se alle karakterer
--Hint: Opprett en policy for foreleser_role uten USING-betingelse
CREATE POLICY foreleser_see_all_grades
ON emneregistreringer
FOR SELECT karakter
TO foreleser_role;
--CREATE POLICY

--3.Lag en view foreleser_karakteroversikt som viser studentnavn, emnenavn og karakterer
--Hint: JOIN studenter, emner og emneregistreringer
CREATE VIEW foreleser_karakteroversikt AS
SELECT s.studentnavn, e.emnenavn, er.karakter
FROM studenter s
JOIN emneregistreringer er ON s.student_id = er.student_id
JOIN emner e ON er.emne_id = e.emne_id;

--4.Implementer en policy som forhindrer at noen sletter karakterer (bare admin kan gjøre det)
--Hint: Bruk FOR DELETE i policyen
CREATE POLICY forhindre_karakter_sletting
ON emneregistreringer
FOR DELETE TO admin
USING (true);

--5Lag en audit-tabell som logger alle endringer av karakterer
--Hint: Bruk triggers (se Bonus-seksjonen under)
-- ============================================================
-- 1. Opprett audit_log-tabell
-- ============================================================
CREATE TABLE audit_log (
    log_id SERIAL PRIMARY KEY,
    tabell_navn VARCHAR(50),
    operasjon VARCHAR(10),
    bruker VARCHAR(50),
    endret_data JSONB,
    endret_tid TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 2. Opprett trigger-funksjon
-- ============================================================
CREATE OR REPLACE FUNCTION log_changes()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO audit_log (tabell_navn, operasjon, bruker, endret_data)
    VALUES (TG_TABLE_NAME, TG_OP, current_user, to_jsonb(NEW));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- 3. Aktiver triggeren på emneregistreringer
-- ============================================================
CREATE TRIGGER emneregistreringer_audit
AFTER INSERT OR UPDATE OR DELETE ON emneregistreringer
FOR EACH ROW EXECUTE FUNCTION log_changes();

-- ============================================================
-- 4. Test audit-logging
-- ============================================================
-- Oppdater en karakter som foreleser
UPDATE emneregistreringer SET karakter = 'A+' WHERE registrering_id = 1;

-- Se audit-loggen
SELECT * FROM audit_log;