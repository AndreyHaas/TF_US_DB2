#Musterlösungen zu A_03_05_01

#a)
SELECT Kunde_ID,
       Vorname,
       Nachname
FROM Kunde 
WHERE Nachname=(
				 SELECT Nachname
				 FROM Kunde
				 WHERE Kunde_ID=3
               );

#b)
SELECT Kunde_ID,
       Vorname,
       Nachname
FROM Kunde 
WHERE Nachname=(
				 SELECT Nachname
				 FROM Kunde
				 WHERE Kunde_ID=3
               )
               AND NOT Kunde_ID=3;
               # alternative Schreibweisen:
               # Kunde_ID!=3
               # Kunde_ID<>3
			   
#c)
SELECT Produkt_ID,
       Produkt_Name,
       Euro_Preis
FROM Produkt  
WHERE Euro_Preis=(
    				SELECT MAX(Euro_Preis)
					FROM Produkt
                 );
				 
#d)
SELECT Vorname,Nachname
FROM Kunde LEFT JOIN Abrechnung ON Kunde.Kunde_ID=Abrechnung.Kunde_id
LEFT JOIN Abrechnung_Produkt ON Abrechnung.Abrechnung_ID=Abrechnung_Produkt.Abrechnung_ID
GROUP BY Vorname,Nachname #schöner wäre Kunde_ID 
HAVING COUNT(Produkt_ID)<(
    						SELECT COUNT(Produkt_ID)
							FROM Abrechnung_Produkt
							WHERE Abrechnung_ID=3
                         );
						 
#e)
SELECT COUNT(Produkt_ID)
FROM Produkt
WHERE Euro_Preis<(
    				SELECT ifNULL(SUM(Euro_Preis),0)
					FROM Abrechnung LEFT JOIN Abrechnung_Produkt ON Abrechnung.Abrechnung_ID=Abrechnung_Produkt.Abrechnung_ID
					LEFT JOIN Produkt ON Abrechnung_Produkt.Produkt_ID=Produkt.Produkt_id
					WHERE Kunde_ID=5
                 );

/* 1) wir verwenden ifNULL, weil der Rückgabewert NULL wäre, wenn
     der Kunde 5 nie etwas bestellt hätte, wir aber in diesem Fall
     die Summe "0" ausgeben lassen wollen.
   2)Wir verwenden den LEFT JOIN, weil wir (erneut für den Fall, dass
     Kunde 5 nie etwas bestellte) keine Abrechnung von ihm mit einem
     bestellten Produkt verknüpfen könnten
     
    => vergleiche Lösungen für Kunde_ID=6 oder 7    
*/