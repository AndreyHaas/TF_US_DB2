-- a)	Es sollen alle Kunden (ID, Vorname, Nachname) ausgegeben werden, die den gleichen Nachnamen wie Kunde 3 haben.

SELECT Kunde_ID, Vorname, Nachname
FROM Kunde
WHERE Nachname = (
    SELECT Nachname FROM Kunde WHERE Kunde_ID = 3
);

-- b)	Identische Ausgabe wie in a), nun aber mit Ausnahme von Kunde 3.

SELECT Kunde_ID, Vorname, Nachname
FROM Kunde
WHERE Nachname = (
    SELECT Nachname FROM Kunde WHERE Kunde_ID = 3
)
AND Kunde_ID <> 3;

-- c)	Es sollen alle „teuersten Produkte“ (ID, Produktname und Preis) ausgegeben werden.
-- Hinweise:
-- (1)	Bekanntlich kann es mehrere Produkte geben, die sich gemeinsam den Titel „teuerstes Produkt“ teilen,
-- da sie untereinander den identischen Preis haben, aber teurer als alle anderen Produkte sind.
-- (2)	Diese Aufgabe konnten wir bisher weder mittels GROUP BY lösen
-- (denn wir konnten dem maximalen Preis nicht „den“ entsprechenden Produktnamen zuordnen) ……
-- noch mittels ORDER BY Euro_Preis DESC LIMIT x (denn wir kannten x nicht).

SELECT Produkt_ID, Produkt_Name, Euro_Preis
FROM Produkt
WHERE Euro_Preis = (
    SELECT MAX(Euro_Preis)
    FROM Produkt
);

-- d)	Es sollen alle Kunden (Vorname, Nachname) ausgegeben werden, die bisher weniger Produkte bestellten,
-- als alleine auf der Abrechnung 3 bestellt worden sind.

SELECT Kunde.Vorname, Kunde.Nachname
FROM Kunde
JOIN Abrechnung ON Kunde.Kunde_ID = Abrechnung.Kunde_ID
GROUP BY Kunde.Kunde_ID, Kunde.Vorname, Kunde.Nachname
HAVING COUNT(Abrechnung_Produkt.Produkt_ID) < (
    SELECT COUNT(*)
    FROM Abrechnung_Produkt
    WHERE Abrechnung_ID = 3
);

-- e)	Es soll die Anzahl der Produkte ermittelt werden, die billiger sind als die Gesamtbestellsumme von Kunde 5.

SELECT COUNT(*) AS Anzahl_Billigere_Produkte
FROM Produkt
WHERE Euro_Preis < (
    SELECT SUM(p.Euro_Preis)
    FROM Abrechnung a
    JOIN Abrechnung_Produkt ap ON a.Abrechnung_ID = ap.Abrechnung_ID
    JOIN Produkt p ON ap.Produkt_ID = p.Produkt_ID
    WHERE a.Kunde_ID = 5
);