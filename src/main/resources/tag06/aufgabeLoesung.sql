-- a1

-- Ein Subselect (Unterabfrage) kann an folgenden Stellen in einem SQL‑Statement
-- verwendet werden:

--1. In SELECT‑Klausel als Spalte im Ergebnis
SELECT kunde.Vorname, (
    SELECT COUNT(*)
    FROM abrechnung
    WHERE abrechnung.Kunde_ID = kunde.Kunde_ID) AS AnzahlBestellungen
FROM Kunde;

--2. In FROM‑Klausel als abgeleitete Tabelle (Derived Table)
SELECT AVG(Anzahl)
FROM (
    SELECT COUNT(*) AS Anzahl
    FROM abrechnung AS ar
    GROUP BY ar.Kunde_ID) AS t;

--3. In WHERE‑Klausel als Filterbedingung

SELECT *
FROM kunde AS k
WHERE k.Vorname = (
    SELECT DISTINCT Vorname
    FROM kunde
    WHERE Kunde_ID = 5
);

--4. In HAVING‑Klausel zum Filtern von Gruppen
SELECT p.Produkt_ID, SUM(p.Euro_Preis) AS Preise
FROM produkt AS p
GROUP BY p.Produkt_ID
HAVING SUM(p.Euro_Preis) > (
    SELECT AVG(SUM(p.Euro_Preis))
    FROM produkt
    GROUP BY p.Produkt_ID
);

--5. In JOIN‑Bedingung als Teil eines JOIN (z.B. mit IN / EXISTS)
SELECT *
FROM Kunde AS k
WHERE EXISTS (
    SELECT *
    FROM abrechnung AS ar
    WHERE ar.Kunde_ID = k.Kunde_ID
);

--6. In INSERT‑Anweisung als Datenquelle
INSERT INTO Archiv_Kunde
	SELECT * FROM Kunde
    WHERE Kunde_ID > 10 AND Kunde_ID < 300;

--7. In UPDATE‑Anweisung als Wertquelle (z.B. haben wir Att Gesamtumsatz in Tabelle Kunde)

UPDATE Kunde AS k
SET Gesamtumsatz =
	(SELECT SUM(Preis)
     FROM abrechnung AS ar
     WHERE ar.Kunde_ID = k.Kunde_ID
);

--8. In DELETE‑Anweisung als Filter (z.B. haben wir Att "Status" in Tabelle Kunde)
DELETE FROM abrechnung AS ar
WHERE ar.Kunde_ID IN (
    SELECT Kunde_ID
    FROM Kunde
    WHERE Status = 'inaktiv'
);

--a2
--2.1 Tabelle für Backups erstellen (falls nicht vorhanden)

CREATE TABLE Kunde_Backup (
    Backup_ID INT(11) AUTO_INCREMENT PRIMARY KEY,
    Backup_Zeitstempel DATETIME,
    Kunde_ID INT(11),
    Vorname VARCHAR(100),
    Nachname VARCHAR(100),
    Email VARCHAR(100)
);

--2.2 Stored Procedure erstellen

DELIMITER $$
CREATE PROCEDURE Backup_Kunde()
BEGIN
    INSERT INTO Kunde_Backup (Backup_Zeitstempel, Kunde_ID, Vorname, Nachname, Email)
    SELECT NOW(), Kunde_ID, Vorname, Nachname, Email
    FROM Kunde;
END$$
DELIMITER;

--2.3 Automatischen Aufruf jede Minute (Event Scheduler)
CREATE EVENT Backup_Kunde_Event
ON SCHEDULE EVERY 1 MINUTE
DO
CALL Backup_Kunde();
--2.3.1 Event Scheduler muss mann einschalten
SET GLOBAL event_scheduler = ON;

--a3
--3.1 Log‑Tabelle vorbereiten
CREATE TABLE Kunde_Log (
    Log_ID INT(11) AUTO_INCREMENT PRIMARY KEY,
    Log_Zeitstempel DATETIME,
    Aktion VARCHAR(50),
    Kunde_ID INT(11),
    Vorname VARCHAR(100),
    Nachname VARCHAR(100)
);

--3.2 Variante a) – Einfach: Log‑Tabelle füllen
DELIMITER $$

CREATE TRIGGER Kunde_After_Insert
AFTER INSERT ON Kunde
FOR EACH ROW
BEGIN
    INSERT INTO Kunde_Log (Log_Zeitstempel, Aktion, Kunde_ID, Vorname, Nachname)
    VALUES (NOW(), 'INSERT', NEW.Kunde_ID, NEW.Vorname, NEW.Nachname);
END$$

DELIMITER ;

--3.3 Variante b) – Schwer: Meldung ausgeben (nicht direkt in SQL möglich)
--In reinem SQL kann ein Trigger keine Meldung an den Client ausgeben
-- (wie ein PRINT oder SELECT). Das ist nur in Prozeduren möglich. Man kann aber über eine
-- Fehler‑Exception eine Meldung simulieren:

DELIMITER $$

CREATE TRIGGER Kunde_After_Insert_Meldung
AFTER INSERT ON Kunde
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Es wurde ein neuer Kunde eingefügt!';
END$$

DELIMITER;

--oder mit Stored Procedure
CREATE TABLE Kunde_Log (
    Log_ID INT(11) AUTO_INCREMENT PRIMARY KEY,
    Zeitstempel DATETIME,
    Meldung TEXT
);

DELIMITER $$

CREATE TRIGGER Kunde_After_Insert_Log
AFTER INSERT ON Kunde
FOR EACH ROW
BEGIN
    INSERT INTO Kunde_Log (Zeitstempel, Meldung)
    VALUES (NOW(), CONCAT('Neuer Kunde: ID=', NEW.Kunde_ID, ', Name=', NEW.Vorname, ' ', NEW.Nachname));
END$$

DELIMITER ;