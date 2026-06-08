-- a)	Es sollen (fast) alle Produkte (ID, Produktname und Preis) ausgegeben werden.
-- Ausnahme soll jedoch das Produkt mit der größten ID sein. Ausgabe numerisch sortiert nach Produkt-ID.

SELECT Produkt_ID, Produkt_Name, Euro_Preis
FROM Produkt
WHERE Produkt_ID <> (
    SELECT MAX(Produkt_ID) FROM Produkt
)
ORDER BY Produkt_ID ASC;

-- b)	Es sollen alle Kunden (ID, Vorname, Nachname) ausgegeben werden, die nach der letzten
-- Abrechnung von Kunden 4 noch die Seite von „Geld_her“ besucht (*) haben.

SELECT DISTINCT k.Kunde_ID, k.Vorname, k.Nachname
FROM Kunde k
JOIN Abrechnung a ON k.Kunde_ID = a.Kunde_ID
WHERE a.Datum > (
    SELECT MAX(Datum)
    FROM Abrechnung
    WHERE Kunde_ID = 4
);

-- c)	Es sollen alle Kunden (Vorname, Nachname) ausgegeben werden, die vor dem November 2021
-- mindestens eines jener Produkte gekauft haben, die dann auch während des Novembers gekauft worden sind.

SELECT DISTINCT k.Vorname, k.Nachname
FROM Kunde k
JOIN Abrechnung a ON k.Kunde_ID = a.Kunde_ID
JOIN Abrechnung_Produkt ap ON a.Abrechnung_ID = ap.Abrechnung_ID
JOIN Produkt p ON ap.Produkt_ID = p.Produkt_ID
WHERE a.Datum < '2021-11-01'
  AND p.Produkt_ID IN (
      SELECT DISTINCT p2.Produkt_ID
      FROM Abrechnung a2
      JOIN Abrechnung_Produkt ap2 ON a2.Abrechnung_ID = ap2.Abrechnung_ID
      JOIN Produkt p2 ON ap2.Produkt_ID = p2.Produkt_ID
      WHERE a2.Datum BETWEEN '2021-11-01' AND '2021-11-30'
  );

-- d)	Es sollen alle Produkte (ID und Name) jener Hersteller ausgegeben werden, von denen mindestens
-- ein Produkt stammt, das auf der Abrechnung 1 bestellt wurde.

SELECT DISTINCT p.Produkt_ID, p.Produkt_Name
FROM Produkt p
WHERE p.Hersteller_ID IN (
    SELECT DISTINCT p2.Hersteller_ID
    FROM Produkt p2
    JOIN Abrechnung_Produkt ap ON p2.Produkt_ID = ap.Produkt_ID
    WHERE ap.Abrechnung_ID = 1
);

-- e)	Es sollen alle Abrechnungen (ID, Datum, Anzahl der bestellten Produkte) ausgegeben werden,
-- bei denen mehr Produkte bestellt wurden, als Contrabit bei „Geld_her“ Produkte im Sortiment hat.

SELECT a.Abrechnung_ID, a.Datum, COUNT(ap.Produkt_ID) AS Anzahl_Produkte
FROM Abrechnung a
JOIN Abrechnung_Produkt ap ON a.Abrechnung_ID = ap.Abrechnung_ID
GROUP BY a.Abrechnung_ID, a.Datum
HAVING COUNT(ap.Produkt_ID) > (
    SELECT COUNT(*)
    FROM Produkt p
    JOIN Hersteller h ON p.Hersteller_ID = h.Hersteller_ID
    WHERE h.Hersteller_Name = 'Contrabit'
);

-- f)	Es sollen all jene Speditionen (ID, Name und Anzahl der transportierten Produkte) ausgegeben werden,
-- die jeweils mehr Produkte transportierten als Kunde 3 bisher bestellte. Ausgabe alphabetisch nach Speditionsname sortiert.

-- (*) Zur Erinnerung (siehe auch: V_02_01, Folie 10)
-- Ein Kunde kann die Seite von „Geld_her“ besuchen, OHNE etwas zu bestellen. Dennoch wird ihm bei
-- jedem Besuch bereits eine Abrechnungs-ID zugewiesen.
-- Beispiel:
 -- Peter Kaufnix (7) besuchte die Seite von „Geld_her“ und erhielt hierbei die Abrechnungs-ID 10.
 -- In der Hilfstabelle findet sich aber kein einziger Datensatz mit dieser Abrechnungs-ID,
 -- denn Peter Kaufnix besuchte die Seite zwar, bestellte aber nichts.

SELECT s.Spedition_ID, s.Spedition_Name, COUNT(ap.Produkt_ID) AS Anzahl_transportiert
FROM Spedition s
JOIN Hersteller h ON s.Spedition_ID = h.Spedition_ID
JOIN Produkt p ON h.Hersteller_ID = p.Hersteller_ID
JOIN Abrechnung_Produkt ap ON p.Produkt_ID = ap.Produkt_ID
GROUP BY s.Spedition_ID, s.Spedition_Name
HAVING COUNT(ap.Produkt_ID) > (
    SELECT COUNT(ap2.Produkt_ID)
    FROM Abrechnung_Produkt ap2
    JOIN Abrechnung a ON ap2.Abrechnung_ID = a.Abrechnung_ID
    WHERE a.Kunde_ID = 3
)
ORDER BY s.Spedition_Name ASC;