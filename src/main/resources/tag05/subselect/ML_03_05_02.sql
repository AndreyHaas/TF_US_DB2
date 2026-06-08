# Musterlösung zu A_03_05_02

				   
#a)
SELECT Produkt_ID,
       Produkt_Name, 
	   Euro_Preis 
FROM Produkt
WHERE NOT Produkt_ID=(SELECT MAX(Produkt_ID) FROM Produkt)
ORDER BY Produkt_ID;


#b)
SELECT DISTINCT Kunde.Kunde_ID,
                Vorname,
				Nachname
FROM Kunde,Abrechnung
WHERE Kunde.Kunde_ID=Abrechnung.Kunde_id
	  AND Datum > (
          			SELECT MAX(Datum) 
          			FROM Abrechnung
          			WHERE Kunde_ID=4
      			   );
				   
#c)
SELECT DISTINCT Vorname,Nachname
FROM Kunde,Abrechnung,Abrechnung_Produkt
WHERE Kunde.Kunde_ID=Abrechnung.Kunde_id
      AND Abrechnung.Abrechnung_ID=Abrechnung_Produkt.Abrechnung_ID
      AND Datum<"2021-11-01"
      AND Produkt_ID IN(
                          SELECT Produkt_ID
          				  FROM Abrechnung,Abrechnung_Produkt
                          WHERE Abrechnung.Abrechnung_ID=Abrechnung_Produkt.Abrechnung_ID
                                AND Datum>="2021-11-01" AND Datum<="2021-11-30"
                       );

#d)
SELECT Produkt_ID,Produkt_Name
FROM Produkt
WHERE Hersteller_ID IN(
          					SELECT Hersteller_ID
          					FROM Abrechnung_Produkt,Produkt
                            WHERE Abrechnung_Produkt.Produkt_ID=Produkt.Produkt_id
                                  AND Abrechnung_ID=1
                       );


#e)
SELECT Abrechnung.Abrechnung_ID, 
       Datum, 
	   COUNT(Produkt_ID)
FROM Abrechnung,Abrechnung_Produkt
WHERE Abrechnung.Abrechnung_ID=Abrechnung_Produkt.Abrechnung_ID
GROUP BY Abrechnung.Abrechnung_ID, Datum 
HAVING COUNT(Produkt_ID)>(
                            SELECT COUNT(Produkt_ID)
                            FROM Produkt,Hersteller
    						WHERE Produkt.Hersteller_ID=Hersteller.Hersteller_ID
                                  AND Hersteller_Name="Contrabit" 
                         );


#f)
SELECT Spedition.Spedition_ID,
       Spedition_Name,
	   COUNT(Abrechnung_Produkt.Produkt_ID)
FROM Abrechnung_Produkt,Produkt,Hersteller,Spedition
WHERE Abrechnung_Produkt.Produkt_ID=Produkt.Produkt_id
      AND Produkt.Hersteller_ID=Hersteller.Hersteller_ID
      AND Hersteller.Spedition_ID=Spedition.Spedition_ID
GROUP BY Spedition.Spedition_ID,Spedition_Name 
HAVING COUNT(Abrechnung_Produkt.Produkt_ID)>(
                                               SELECT COUNT(Produkt_id)
                                               FROM Abrechnung,Abrechnung_Produkt
                                               WHERE Abrechnung.Abrechnung_ID=Abrechnung_Produkt.Abrechnung_ID
                                                     AND Kunde_ID=3 
                                             )
ORDER BY Spedition_Name;
