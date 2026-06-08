-- a)	Erstellen Sie bitte zunächst einen VIEW (namens „Geld_Termin“),
-- der für alle verkauften Waren das Verkaufsdatum und den Preis ermittelt.
-- Nutzen Sie diesen VIEW bitte anschließend, um die folgende Abfrage zu formulieren:
-- Gesamteinnahme von „Geld_her“ im November 2021.


CREATE VIEW Geld_Termin AS
SELECT
    a.Datum AS Verkaufsdatum,
    p.Euro_Preis AS Preis
FROM Abrechnung a
JOIN Abrechnung_Produkt ap ON a.Abrechnung_ID = ap.Abrechnung_ID
JOIN Produkt p ON ap.Produkt_ID = p.Produkt_ID;

SELECT SUM(Preis) AS Gesamteinnahme_Nov2021
FROM Geld_Termin
WHERE YEAR(Verkaufsdatum) = 2021 AND MONTH(Verkaufsdatum) = 11;

-- b)	Erstellen Sie bitte zunächst einen VIEW „Hersteller_Ranking“,
-- der für alle Hersteller dessen ID, Namen und die Anzahl der von ihm bei „Geld_her“ verkauften Waren ermittelt.
-- Nutzen Sie diesen VIEW bitte anschließend, um die folgende Abfrage zu formulieren:
-- Gesamte Ausgabe des VIEWs „Hersteller_Ranking“, Ausgabe allerdings sortiert nach Anzahl abfallend.

CREATE VIEW Hersteller_Ranking AS
SELECT
    h.Hersteller_ID,
    h.Hersteller_Name,
    COUNT(ap.Produkt_ID) AS Anzahl_verkaufte_Waren
FROM Hersteller h
JOIN Produkt p ON h.Hersteller_ID = p.Hersteller_ID
JOIN Abrechnung_Produkt ap ON p.Produkt_ID = ap.Produkt_ID
GROUP BY h.Hersteller_ID, h.Hersteller_Name;

SELECT * FROM Hersteller_Ranking
ORDER BY Anzahl_verkaufte_Waren DESC;

-- c)	Erstellen Sie bitte den neuen User „Finanzamt“ (localhost, Passwort: „Steuerfahnder“).
-- Er soll die Rechte erhalten, SELECT–Anweisungen zu verwenden. Dies allerdings nur für den VIEW „Geld_Termin“.
-- Überprüfen Sie bitte zunächst, ob diese Rechte korrekt vergeben wurden.
-- Ziehen Sie anschließend bitte in ein Steuerparadies und löschen diesen User ;-) …
-- Kontrollieren Sie abschließend bitte, ob diese Löschung tatsächlich erfolgreich war.

CREATE USER 'Finanzamt'@'localhost' IDENTIFIED BY 'Steuerfahnder';
GRANT SELECT ON Geld_her.Geld_Termin TO 'Finanzamt'@'localhost';
FLUSH PRIVILEGES;

-- Test (nach Anmeldung als Finanzamt)
-- USE Geld_her;
-- SELECT * FROM Geld_Termin;          -- OK
-- SELECT * FROM Hersteller_Ranking;   -- Access denied

DROP USER 'Finanzamt'@'localhost'; -- User löschen

SELECT User, Host FROM mysql.user WHERE User = 'Finanzamt'; -- Löschung prüfen