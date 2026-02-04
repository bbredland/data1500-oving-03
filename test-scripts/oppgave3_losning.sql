--1.Opprett en rolle program_ansvarlig som kan lese og oppdatere programmer-tabellen, men ikke slette
CREATE ROLE program_ansvarlig LOGIN PASSWORD 'program';
GRANT SELECT, UPDATE ON programmer TO program_ansvarlig;
SELECT * FROM information_schema.role_table_grants
WHERE grantee = 'program_ansvarlig';
-- grantor |      grantee      | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy
---------+-------------------+---------------+--------------+------------+----------------+--------------+----------------
-- admin   | program_ansvarlig | data1500_db   | public       | programmer | SELECT         | NO           | YES
-- admin   | program_ansvarlig | data1500_db   | public       | programmer | UPDATE         | NO           | NO
--(2 rows)


--2.Opprett en rolle student_self_view som bare kan se sitt eget studentdata (hint: bruk en VIEW)
CREATE ROLE student_self_view LOGIN PASSWORD 'student_self';

CREATE VIEW student_self_data AS
SELECT student_id, fornavn, etternavn, epost, program_id, opprettet
FROM studenter
WHERE epost = current_user;

GRANT SELECT ON student_self_data TO student_self_view;

--3.Gi foreleser_role tilgang til å lese fra student_view (som allerede er opprettet)
GRANT SELECT ON student_view TO foreleser_role;

--4.Opprett en rolle backup_bruker som bare har SELECT-rettighet på alle tabeller
CREATE ROLE backup_bruker LOGIN PASSWORD 'backup';

GRANT SELECT ON ALL TABLES IN SCHEMA public TO backup_bruker;

--5.Lag en oversikt over alle roller og deres rettigheter
SELECT rolname FROM pg_roles WHERE rolname NOT LIKE 'pg_%';
/*       rolname
---------------------
 admin
 admin_role
 foreleser_role
 student_role
 emne_leser
 karakter_oppdaterer
 program_ansvarlig
 student_self_view
 backup_bruker
(9 rows)
*/
SELECT grantee, table_name, privilege_type
FROM information_schema.role_table_grants WHERE grantee NOT LIKE 'PUBLIC' AND grantee NOT LIKE 'admin' AND grantee NOT LIKE 'pg_%'
ORDER BY grantee, table_name;
/*
       grantee       |         table_name         | privilege_type
---------------------+----------------------------+----------------
 admin_role          | emner                      | TRUNCATE
 admin_role          | emner                      | DELETE
 admin_role          | emner                      | UPDATE
 admin_role          | emner                      | REFERENCES
 admin_role          | emner                      | TRIGGER
 admin_role          | emner                      | SELECT
 admin_role          | emner                      | INSERT
 admin_role          | emneregistreringer         | UPDATE
 admin_role          | emneregistreringer         | TRUNCATE
 admin_role          | emneregistreringer         | REFERENCES
 admin_role          | emneregistreringer         | TRIGGER
 admin_role          | emneregistreringer         | INSERT
 admin_role          | emneregistreringer         | SELECT
 admin_role          | emneregistreringer         | DELETE
 admin_role          | programmer                 | SELECT
 admin_role          | programmer                 | INSERT
 admin_role          | programmer                 | UPDATE
 admin_role          | programmer                 | DELETE
 admin_role          | programmer                 | TRUNCATE
 admin_role          | programmer                 | REFERENCES
 admin_role          | programmer                 | TRIGGER
 admin_role          | studenter                  | REFERENCES
 admin_role          | studenter                  | TRIGGER
 admin_role          | studenter                  | TRUNCATE
 admin_role          | studenter                  | DELETE
 admin_role          | studenter                  | UPDATE
 admin_role          | studenter                  | SELECT
 admin_role          | studenter                  | INSERT
 backup_bruker       | emner                      | SELECT
 backup_bruker       | emneregistreringer         | SELECT
 backup_bruker       | foreleser_view             | SELECT
 backup_bruker       | programmer                 | SELECT
 backup_bruker       | student_self_view          | SELECT
 backup_bruker       | student_view               | SELECT
 backup_bruker       | studenter                  | SELECT
 emne_leser          | emner                      | SELECT
 foreleser_role      | emner                      | INSERT
 foreleser_role      | emner                      | SELECT
 foreleser_role      | emner                      | UPDATE
 foreleser_role      | emneregistreringer         | SELECT
 foreleser_role      | emneregistreringer         | INSERT
 foreleser_role      | foreleser_view             | UPDATE
 foreleser_role      | foreleser_view             | INSERT
 foreleser_role      | foreleser_view             | SELECT
 foreleser_role      | programmer                 | SELECT
 foreleser_role      | programmer                 | INSERT
 foreleser_role      | programmer                 | UPDATE
 foreleser_role      | student_view               | SELECT
 foreleser_role      | studenter                  | UPDATE
 foreleser_role      | studenter                  | SELECT
 foreleser_role      | studenter                  | INSERT
 karakter_oppdaterer | emner                      | SELECT
 karakter_oppdaterer | emneregistreringer         | UPDATE
 karakter_oppdaterer | emneregistreringer         | SELECT
 karakter_oppdaterer | studenter                  | SELECT
 program_ansvarlig   | programmer                 | UPDATE
 program_ansvarlig   | programmer                 | SELECT
 student_role        | emner                      | SELECT
 student_role        | emneregistreringer         | SELECT
 student_role        | programmer                 | SELECT
 student_role        | student_view               | SELECT
 student_role        | studenter                  | SELECT
 student_self_view   | student_self_view          | SELECT
(63 rows)*/

