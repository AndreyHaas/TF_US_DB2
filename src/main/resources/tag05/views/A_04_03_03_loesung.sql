-- a)	Erstellen Sie bitte zunächst einen VIEW (namens „Elli_Rot“), der für alle Abrechnungen von
-- Elli Rot (sie hat die Kunde-ID: 1) die Abrechnungs-ID und Bestellsumme (in Euro) ermittelt.
-- [Achten Sie bitte darauf, dass Sie der Aggregatfunktions-Spalte eines ALIAS-Namen vergeben müssen, z.B. „Summe“!]
-- Zusatzfrage: Warum sollte hier nicht mit einem INNER JOIN gearbeitet werden? Begründen Sie Ihre Antwort bitte schriftlich.
-- Nutzen Sie diesen VIEW bitte anschließend, um die folgende Abfrage zu formulieren:
-- Ausgabe der höchsten Bestellsumme aller Abrechnungen von Elli Rot.

CREATE VIEW Elli_Rot AS
SELECT
    ar.Abrechnung_ID,
    IFNULL(SUM(pr.Euro_Preis), 0) AS Summe
FROM Abrechnung AS ar
LEFT JOIN Abrechnung_Produkt ap ON ar.Abrechnung_ID = ap.Abrechnung_ID
LEFT JOIN Produkt pr ON ap.Produkt_ID = pr.Produkt_ID
WHERE ar.Kunde_ID = 1
GROUP BY ar.Abrechnung_ID;

SELECT MAX(Summe) AS Höchste_Bestellsumme
FROM Elli_Rot;

-- b)	Erstellen Sie bitte zunächst einen VIEW (namens „AVG_Preis“), der für alle Abrechnungen die ID,
-- das Datum und den durchschnittlichen Preis der auf dieser Abrechnung bestellten Waren ermittelt.
-- Nutzen Sie diesen VIEW bitte anschließend, um die folgende Abfrage zu formulieren:
-- Ausgabe des kleinsten Durchschnittswertes aller Abrechnungen.

-- View erstellen
CREATE VIEW AVG_Preis AS
SELECT
    a.Abrechnung_ID,
    a.Datum,
    ROUND(AVG(p.Euro_Preis), 2) AS Durchschnittspreis
FROM Abrechnung a
JOIN Abrechnung_Produkt ap ON a.Abrechnung_ID = ap.Abrechnung_ID
JOIN Produkt p ON ap.Produkt_ID = p.Produkt_ID
GROUP BY a.Abrechnung_ID, a.Datum;

SELECT MIN(Durchschnittspreis) AS Kleinster_Durchschnitt
FROM AVG_Preis;

-- c)	Erstellen Sie bitte den neuen User „Elli Rot“ (localhost, Passwort: „Captain Shira“).
-- Sie soll die Rechte erhalten, SELECT–Anweisungen zu verwenden. Dies allerdings nur für den VIEW
-- „Elli_Rot“ in der Datenbank „Geld_her“.
-- Testen Sie die Rechte-Vergabe bitte durch geeignete Beispiele.

CREATE USER 'Elli Rot'@'localhost' IDENTIFIED BY 'Captain Shira'; -- User erstellen

GRANT SELECT ON Geld_her.Elli_Rot TO 'Elli Rot'@'localhost'; -- Rechte auf VIEW erteilen

mysql -u 'Elli Rot'@'localhost' -p -- Passwort: Captain Shira eingeben.

FLUSH PRIVILEGES; -- Rechte aktivieren

USE Geld_her;
SELECT * FROM Elli_Rot; -- Soll funktionieren
SELECT * FROM Kunde; -- Soll Fehler geben (kein Recht auf Tabelle)