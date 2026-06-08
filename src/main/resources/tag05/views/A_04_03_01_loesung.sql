-- a)	Erstellen Sie bitte zunächst einen VIEW (namens „View_1“), der für alle Produkte den Produktnamen,
-- den Preis und den zugehörigen Speditionsnamen ermittelt. Nutzen Sie diesen VIEW bitte anschließend,
-- um die folgende Abfrage zu formulieren:
-- Ausgabe von Produktname und zugehörigem Speditionsnamen des Produkts mit dem größten Preis.

CREATE VIEW View_1 AS
SELECT
    pr.Produkt_Name AS Produktname,
    pr.Euro_Preis AS Preis,
    sp.Spedition_Name AS Speditionsname
FROM produkt pr
JOIN hersteller hs ON pr.Hersteller_ID = hs.Hersteller_ID
JOIN spedition sp ON hs.Spedition_ID = sp.Spedition_ID;

SELECT Produktname, Speditionsname
FROM View_1
ORDER BY Preis DESC
LIMIT 1;

--> SELECT Produkt_Name, Spedition_Name
--> FROM View_1
--> WHERE Euro_Preis = (SELECT MAX(Euro_Preis) FROM View_1);


-- b)	Erstellen Sie bitte zunächst einen VIEW (namens „View_2“), der für alle Produkte den Produktnamen,
-- den Preis und zugehörigen Herstellernamen ermittelt. Nutzen Sie diesen VIEW bitte anschließend,
-- um die folgende Abfrage zu formulieren:
-- Ausgabe der drei teuersten Produkte (Produktname, Preis und zugehöriger Herstellername)
-- View erstellen

CREATE VIEW View_2 AS
SELECT
    p.Produkt_Name Produktname,
    p.Euro_Preis Preis,
    h.Hersteller_Name Herstellername
FROM produkt p
JOIN hersteller h ON p.Hersteller_ID = h.Hersteller_ID;

SELECT *
FROM View_2
ORDER BY Preis DESC
LIMIT 3;

-- c)	Erstellen Sie bitte den neuen User „Admin“ (Passwort: „1234abcd“). Er soll für alle Datenbanken
-- und für alle Tabellen auf dem MySQL-Server das Recht haben, Abfragen zu stellen, sofern er sich vom „localhost“ anmeldet.
-- Testen Sie dies, indem Sie sich anschließend als Admin anmelden und sich die gesamte Tabelle „Kunde“ anzeigen lassen.

--0
mysql -u root -p -- als root einloggen
--1
CREATE USER 'Admin'@'localhost' IDENTIFIED BY '1234abcd'; -- User „Admin“ mit Passwort erstellen
--2
GRANT SELECT ON *.* TO 'Admin'@'localhost'; -- Rechte für alle Datenbanken und Tabellen vergeben (SELECT)
--3
FLUSH PRIVILEGES; -- Rechte aktivieren (flush)
--4
EXIT; -- Verlasse zuerst deine aktuelle Sitzung (falls nötig)
--5
mysql -u Admin -p -- neu anmelden als Admin (Passwort: 1234abcd eingeben).
--6
USE geld_her;
SELECT * FROM Kunde;

-- Vollständiger Code (alles in einem Block für phpMyAdmin / Admin‑Interface)
CREATE USER 'Admin'@'localhost' IDENTIFIED BY '1234abcd';
GRANT SELECT ON *.* TO 'Admin'@'localhost';
FLUSH PRIVILEGES;