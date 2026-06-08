# Musterlösung zu A_03_05_03


#a)	
SELECT Abrechnung_ID 
FROM Abrechnung
WHERE Datum>
(
    SELECT Datum
    FROM Abrechnung
    WHERE Abrechnung_ID=3
);

#b)	
SELECT COUNT(Produkt_ID)
FROM Produkt
WHERE Euro_preis>
(
    SELECT Euro_preis
    FROM Produkt
    WHERE Produkt_ID=1
);

#c)	
SELECT Vorname,Nachname
FROM Kunde
WHERE Kunde_ID>
(
    SELECT Kunde_ID
    FROM Kunde
    WHERE Vorname="Vera" AND Nachname="Deise"
); #ACHTUNG: klappt nur, falls NICHT mehrere Kunden „Vera Deise“ heißen

#d)	
SELECT Vorname,Nachname,SUM(Euro_preis) 
FROM Produkt 
NATURAL JOIN Abrechnung_Produkt
NATURAL JOIN Abrechnung
NATURAL JOIN Kunde
GROUP BY Kunde_ID HAVING SUM(Euro_Preis) >
(
   SELECT 0.2 * SUM( Euro_Preis )
   FROM Produkt INNER JOIN Abrechnung_Produkt ON Produkt.Produkt_ID=Abrechnung_Produkt.Produkt_ID
);


#e)	
SELECT vorname,nachname, COUNT(abrechnung_id)
FROM Kunden
NATURAL JOIN Abrechnungen
GROUP BY kunde_id
HAVING COUNT(abrechnung_id) >
(
   SELECT COUNT(*)
   FROM Abrechnungen 
   WHERE kunde_id = 2
);

#f)	
SELECT hersteller_name, count( abrechnung_produkt.produkt_id )
FROM Hersteller
NATURAL JOIN Produkt
NATURAL JOIN Abrechnung_Produkt
GROUP BY hersteller_id
HAVING count( abrechnung_produkt.produkt_id) > 
(
   ( SELECT count( * ) FROM Abrechnung_Produkt) 
   / 
   (SELECT count( * )FROM Hersteller )
);
