-- 1. DML: Füge einen neuen Mitarbeiter mit allen Pflichtfeldern hinzu.
INSERT INTO personal  (persnr,  nachname,     vorname,  geschlecht, abtlg, gehalt)
VALUES                (999,     'Mustarman',  'Jan',    2,          'MA',  '9999.99');

--2. DML: Erstelle einen neuen Kundendatensatz (Pflichtfelder beachten).
INSERT INTO kunden (kdnr,geschlecht, land,erfasst,               skonto, skontotage, ziel, lieferschein, gesperrt)
VALUES 				     (999, 2,          'D', '2010-10-22 00:00:00', 0.0,    0,          0,    -1,           0);

--3. DML: Ändere den Nachnamen des Kunden mit der ID 10 in 'Schmidt'.
UPDATE kunden
SET nachname='Schmidt'
WHERE kdnr = 10;

--4. DML: Lösche alle Einträge aus der Tabelle artikel_audit, die vor dem Jahr 2023 erstellt wurden.
DELETE FROM artikel_audit
WHERE erstel_datum < '2023-01-01 00:00:00';

--5. DDL: Füge der Tabelle wws.artikel eine Spalte eAN (Datentyp VARCHAR) hinzu.
ALTER TABLE artikel
ADD COLUMN eAN VARCHAR(255);

--6. DDL: Entferne die Spalte interessen aus der Tabelle wws.mitarbeiter.
ALTER TABLE mitarbeiter
DROP COLUMN interessen;

--7. DML: Setze den Einzelpreis in belegpositionen für alle Positionen des Belegs 5 auf 0.00.
UPDATE belegpositionen
SET einzelpreis = 0.00
WHERE beleg_id = 5;

--8. DML: Erfasse eine neue Warengruppe.
INSERT INTO warengruppen  (name,                beschreibung)
VALUES                    ('Neue Warengruppe',  'Beschreibung der neuen Warengruppe');

-- 9. DML: Ändere die Abteilung aller Mitarbeiter von 'Marketing' zu 'Content Strategy'.
UPDATE TABLE mitarbeiter
SET abteilung = 'Content Strategy'
WHERE abteilung = 'Marketing';

-- 10. DDL: Benenne die Tabelle wws.externe_daten in wws.rohdaten_import um.
ALTER TABLE externe_daten
RENAME TO rohdaten_import;

-- 11. DML: Erhöhe den Preis aller Artikel um 10%.
UPDATE artikel
SET preis = preis * 1.1;

--12. DML: Füge einen neuen Lieferanten hinzu.
INSERT INTO lieferanten (liefnr, firma1, aktiv, erfasst)
VALUES (9999, 'Musterfirma', 0, '2010-12-16 00:00:00');

-- 13. DDL: Ändere den Datentyp der Spalte telefon in wws.kunden auf VARCHAR(30).
ALTER TABLE kunden
MODIFY COLUMN telefon VARCHAR(30);

--14. DML: Setze das Austrittsdatum für Mitarbeiter ID 12 auf den 31.12.2025.
UPDATE personal
SET austrittsdatum = '2025-12-31 00:00:00'
WHERE mitarbeiter_ID = 12;

---15. DML: Lösche die Warengruppe mit der ID 99 (sofern keine Artikel zugeordnet sind).
DELETE FROM Warengruppe
WHERE wgruppe_ID = 99;

--16.DDL: Erstelle eine neue Tabelle wws.hersteller mit id (Primary Key) und name (NOT NULL).
CREATE TABLE hersteller(
  id INT(11) PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

--17. DML: Füge einen Beleg hinzu (Pflichtfelder: ID, Belegnr, Belegart, Datum, Kunde, Mitarbeiter).
INSERT INTO beleg (id, belegnr, belegart, datum, kunde_id, mitarbeiter_id)
VALUES (1, 'R-2025-0001', 'Rechnung', '2025-01-15', 101, 5);

-- 18.DML: Füge eine Belegposition für den soeben erstellten Beleg hinzu (Bezug auf Artikel ID 10).
INSERT INTO wws.belegposition (beleg_id, position_nr, artikel_id, menge, einzelpreis)
VALUES (1, 1, 10, 2, 49.99);

--19. DDL: Füge der Tabelle wws.artikel einen Foreign Key hinzu, der auf die neue Tabelle hersteller verweist.
ALTER TABLE artikel
ADD CONSTRAINT fk_artikel_hersteller
FOREIGN KEY (hersteller_id) REFERENCES hersteller(id);

--20. DML: Setze bei allen Kunden die PLZ auf '00000', deren PLZ aktuell NULL ist.
UPDATE kunde
SET plz='00000'
WHERE plz IS NULL;

--21.D DL:Setze die Spalte bezeichnung in der Tabelle artikel auf NOT NULL.
ALTER TABLE artikel
MODIFY COLUMN bezeichnung VARCHAR(100) NOT NULL;

--22.DML: Übertrage einen Mitarbeiter in eine andere Abteilung und erhöhe gleichzeitig seinen Stundenlohn um 2 Euro.
UPDATE mitarbeiter
SET abteilung = 4 AND stundenlohn = stundenlohn + 2
WHERE id = 17;

--23.DDL: Erstelle einen Unique-Constraint für die Kombination aus firma und ort in der Lieferantentabelle.
ALTER TABLE lieferanten
ADD CONSTRAINT unique_firma_ort UNIQUE (firma, ort);

--24.DML: Lösche alle Belegpositionen, die zum Artikel 'A-102' gehören (Subquery auf Artikel-Tabelle).
DELETE FROM belegposition
WHERE artikel_id IN (SELECT id FROM artikel WHERE artikel_nr = 'A-102');

--25.DML: Füge einen Datensatz in artikel_audit ein, um eine Preisänderung zu dokumentieren.
INSERT INTO artikel_audit (artikel_id, alter_preis, neuer_preis, datum, geaendert_von)
VALUES (10, 19.99, 24.99, NOW(), 'USER001');

--26.DDL: Erstelle eine Tabelle wws.lager (id, artikel_id, bestand) mit Foreign Key auf Artikel.
CREATE TABLE lager (
    id INT PRIMARY KEY AUTO_INCREMENT,
    artikel_id INT NOT NULL,
    bestand INT DEFAULT 0,
    FOREIGN KEY (artikel_id) REFERENCES artikel(id)
);

--27. DML: Setze den Vorgesetzten für alle Mitarbeiter der Abteilung 'Vertrieb' auf die Mitarbeiter-ID 1.
UPDATE mitarbeiter
SET vorgesetzter_id = 1
WHERE abteilung = 'Vertrieb';

--28.DDL: Füge einen Check-Constraint hinzu, dass das gehalt eines Mitarbeiters nicht negativ sein darf.
ALTER TABLE mitarbeiter
ADD CONSTRAINT check_gehalt_positiv CHECK (gehalt >= 0);

--29.DML: Korrigiere alle E-Mail-Adressen der Kunden: Wandle sie in Kleinbuchstaben um.
UPDATE kunde
SET email = LOWER(email);

--30.DML: Leere die Tabelle externe_daten komplett, ohne die Struktur zu löschen.
TRUNCATE TABLE externe_daten;

--31.DML: Setze die Wochenstunden aller Mitarbeiter ohne Angabe auf den Standardwert 40.
UPDATE mitarbeiter
SET wochenstunden = 40
WHERE wochenstunden IS NULL;
----
UPDATE mitarbeiter
SET wochenstunden = COALESCE(wochenstunden, 40);

--32.DDL: Benenne die Spalte belegart in typ um.
ALTER TABLE beleg
RENAME COLUMN belegart TO typ;

--33.DML: Dupliziere den Artikel mit ID 1 (Insert mit Subselect, neue ID vergeben).
INSERT INTO artikel (artikel_nr, bezeichnung, preis, hersteller_id)
SELECT 'DUPLIKAT-001', bezeichnung, preis, hersteller_id
FROM artikel
WHERE id = 1;

--34.DDL: Füge der Tabelle belegpositionen eine Default-Regel für menge = 1 hinzu.
ALTER TABLE belegpositionen
ALTER COLUMN menge SET DEFAULT 1;

--35.DDL: Erstelle die Tabelle belegpositionen neu (als Backup), inklusive aller Constraints (CTASAnsatz).
-- 1. Struktur + Daten kopieren (ohne AUTO_INCREMENT)
CREATE TABLE belegpositionen_backup LIKE belegpositionen;

-- 2. Daten kopieren
INSERT INTO belegpositionen_backup
SELECT * FROM belegpositionen;

-- Oder mit CTAS + nachträglichen Constraints:
CREATE TABLE belegpositionen_backup AS SELECT * FROM belegpositionen;

ALTER TABLE belegpositionen_backup
MODIFY COLUMN id INT NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST;

ALTER TABLE belegpositionen_backup
ADD FOREIGN KEY (beleg_id) REFERENCES beleg(id),
ADD FOREIGN KEY (artikel_id) REFERENCES artikel(id);

--36.DML: Lösche alle Kunden, die noch nie einen Beleg erhalten haben (Subquery).
DELETE FROM kunde AS k
WHERE NOT EXISTS (SELECT * FROM beleg AS bg WHERE bg.kunde_id = k.id);

--37.DML: Erhöhe den Preis um 15% für alle Artikel, die von Lieferanten aus 'Berlin' stammen.
UPDATE artikel
SET preis = preis * 1.15
WHERE hersteller_id IN (
    SELECT id
    FROM hersteller
    WHERE ort = 'Berlin');

--38.DDL: Erstelle einen Index für die Spalte nachname in der Mitarbeitertabelle.
CREATE INDEX idx_mitarbeiter_nachname
ON mitarbeiter (nachname);

--39.DML: Setze alle Mitarbeitergehälter auf das Durchschnittsgehalt ihrer jeweiligen Abteilung(Komplexes Update).
UPDATE mitarbeiter m
SET m.gehalt = (
    SELECT AVG(gehalt)
    FROM mitarbeiter
    WHERE abteilung = m.abteilung)
WHERE m.abteilung IS NOT NULL;

--40.DDL: Erstelle eine Tabelle wws.projekte und eine Verknüpfungstabelle wws.mitarbeiter_projekte(m:n Beziehung).
-- 1. Tabelle projekte
CREATE TABLE projekte (
    id INT(11) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    beschreibung TEXT VARCHAR(255),
    startdatum DATE,
    enddatum DATE
);
-- 2. Verknüpfungstabelle
CREATE TABLE mitarbeiter_projekte (
    mitarbeiter_id(11) INT NOT NULL,
    projekte_id INT(11) NOT NULL,
    rolle VARCHAR(100),
    zugewiesen_am TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (mitarbeiter_id, projekte_id),
    FOREIGN KEY (mitarbeiter_id) REFERENCES mitarbeiter(id),
    FOREIGN KEY (projekte_id) REFERENCES projekte(id)
);

-- 41.DML: Ändere den Lieferanten aller Artikel der Warengruppe 'Hardware' auf die Lieferanten-ID 50.
UPDATE artikel
SET lieferanten_id = 50
WHERE warengruppe_id IN (
    SELECT id
    FROM warengruppe
    WHERE name = 'Hardware');

--42.DML: Lösche alle Mitarbeiter, deren Austrittsdatum länger als 10 Jahre zurückliegt.
DELETE FROM mitarbeiter
WHERE austrittsdatum < DATE_SUB(CURDATE(), INTERVAL 10 YEAR);

--43.DDL: Füge eine Spalte umsatzsteuer_satz zur Tabelle artikel hinzu mit einem Check-Constraint (nur 7 oder 19 erlaubt).
ALTER TABLE artikel
ADD COLUMN umsatzsteuer_satz DECIMAL(3,1) CHECK (umsatzsteuer_satz IN (7, 19));

--44.DML: Fülle die Tabelle artikel_audit mit initialen Daten für alle vorhandenen Artikel (Snapshot).
INSERT INTO artikel_audit (artikel_id, preis, bezeichnung, erfassungsdatum)
SELECT id, preis, bezeichnung, NOW()
FROM artikel;

--45.DDL: Entferne den Foreign Key Constraint zwischen belege und kunden (Constraint Name: fk_beleg_kunde angenommen).
ALTER TABLE belege
DROP FOREIGN KEY fk_beleg_kunde;

--46.DML: Setze den Status "Inaktiv" in der Spalte interessen (falls noch vorhanden) für alle Mitarbeiter ohne Gehalt.
UPDATE mitarbeiter
SET interessen = 'Inaktiv'
WHERE gehalt IS NULL OR gehalt = 0;

--47.DDL: Erstelle eine neue Tabelle wws.archiv_belege mit der exakt gleichen Struktur wie belege.
CREATE TABLE archiv_belege LIKE belege;

--48.DML: Verschiebe alle Belege aus 2020 in die Archiv-Tabelle (Zweistufig: Insert + Delete).
--ins
INSERT INTO belege_archiv
SELECT * FROM belege
WHERE YEAR(datum) = 2020;
--del
DELETE FROM belege
WHERE YEAR(datum) = 2020;

--49.DML: Reduziere die Wochenstunden um 20% für alle Mitarbeiter, die einen Untergebenen haben (Manager-Bonus an Zeit).
UPDATE mitarbeiter
SET wochenstunden = wochenstunden * 0.8
WHERE id IN (
    SELECT DISTINCT vorgesetzter_id
    FROM mitarbeiter
    WHERE vorgesetzter_id IS NOT NULL);

--50.DDL: Erstelle einen Constraint, der verhindert, dass das austrittsdatum vor dem eintrittsdatum liegt.
ALTER TABLE mitarbeiter
ADD CONSTRAINT check_datum_ordnung CHECK (austrittsdatum >= eintrittsdatum);
-- noch
ALTER TABLE mitarbeiter
ADD CONSTRAINT check_datum_ordnung CHECK (austrittsdatum IS NULL OR austrittsdatum >= eintrittsdatum);