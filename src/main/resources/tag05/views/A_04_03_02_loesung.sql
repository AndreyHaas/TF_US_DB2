-- a)	Erstellen Sie bitte zunächst einen VIEW (namens „View_1“), der für alle Produkte dessen Namen
-- und die Anzahl der von ihm verkauften Exemplare ermittelt. Nutzen Sie diesen VIEW bitte anschließend,
-- um die folgende Abfrage zu formulieren:
-- Ausgabe aller vom VIEW ermittelten Werte

CREATE VIEW View_1 AS
SELECT
    p.Produkt_Name AS Produktname,
    COUNT(ap.Abrechnung_ID) AS Anzahl
FROM Produkt p
JOIN Abrechnung_Produkt ap ON ap.Produkt_ID = p.Produkt_ID
GROUP BY p.Produkt_Name;

SELECT *
FROM View_1;

-- b)	Erstellen Sie bitte zunächst einen VIEW (namens „View_2“), der für alle Kunden Vor-, Nachname
-- und das Datum ihrer (aktuell) letzten Abrechnung ermittelt. (Wichtig: Das Attribut für MAX(Datum)
-- muss mittels eines ALIAS (AS) eine eigenständige Bezeichnung erhalten (z.B. „Letztes_Datum“) erhalten,
-- um auf dieses Attribut später bei der Verwendung des VIEWs zugreifen zu können).
-- Nutzen Sie diesen VIEW bitte anschließend, um die folgende Abfrage zu formulieren:
-- Ausgabe von Vorname und letztem Abrechnungs-Datum aller Kunden, die mit Nachnamen „Myrnow“ heißen.

CREATE VIEW View_2 AS
SELECT
    k.Vorname AS Vorname,
    k.Nachname AS Nachname,
    MAX(ar.Datum) AS Letztes_Datum
FROM kunde AS k
JOIN abrechnung AS ar ON ar.Kunde_ID = k.Kunde_ID
GROUP BY k.Vorname, k.Nachname;

SELECT Vorname, Letztes_Datum
FROM View_2
WHERE Nachname = 'Myrnow';

-- c)	Erstellen Sie bitte den neuen User „Kundenbetreuer“ (localhost, kein Passwort [man notiert dann
-- einfach zwei Anführungszeichen ohne Leerzeichen dazwischen]). Er soll die Rechte erhalten,
-- SELECT und INSERT zu verwenden. Dies allerdings nur für die Tabelle „Kunde“ in der Datenbank „Geld_her“.
-- (Hinweis: Sie können mit GRANT SELECT, INSERT … arbeiten, oder alternativ 2 einzelne GRANT-Statements absenden)
-- Testen Sie die Rechte-Vergabe bitte durch geeignete Beispiele.

-- User erstellen
CREATE USER 'Kundenbetreuer'@'localhost' IDENTIFIED BY '';

-- Rechte erteilen (beide Varianten möglich)
GRANT SELECT, INSERT ON Geld_her.Kunde TO 'Kundenbetreuer'@'localhost';

-- Rechte aktivieren
FLUSH PRIVILEGES;

-- Test der Rechtevergabe
mysql -u Kundenbetreuer -p -- Als User anmelden in Konsole

USE Geld_her;
SELECT * FROM Kunde;
INSERT INTO Kunde (Vorname, Nachname) VALUES ('Max', 'Mustermann');

-- Sollte Fehler geben weil nur Rechte für SELECT, INSERT ausgegeben wurde
DELETE FROM Kunde WHERE Nachname = 'Mustermann';