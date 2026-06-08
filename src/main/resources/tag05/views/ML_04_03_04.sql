# Musterlösung zu A_04_03_04


#a(1)
CREATE VIEW Geld_Termin AS
SELECT Datum, Euro_Preis
FROM Abrechnung,Abrechnung_Produkt,Produkt
WHERE Abrechnung.Abrechnung_ID=Abrechnung_Produkt.Abrechnung_ID
      AND Abrechnung_Produkt.Produkt_ID=Produkt.Produkt_id;
	  
#a(2)
SELECT SUM(Euro_Preis) FROM Geld_Termin
WHERE Datum>="2021-11-01" AND Datum<="2021-11-30";


#b(1)
CREATE VIEW Hersteller_Ranking AS
SELECT Hersteller.Hersteller_ID,Hersteller_Name,COUNT(Abrechnung_ID) AS Anzahl
FROM Abrechnung_Produkt RIGHT JOIN Produkt ON Abrechnung_Produkt.Produkt_ID=Produkt.Produkt_id
     RIGHT JOIN Hersteller ON Produkt.Hersteller_ID=Hersteller.Hersteller_ID 
GROUP BY Hersteller.Hersteller_ID,Hersteller_Name;

#b(2)
SELECT * FROM Hersteller_Ranking
ORDER BY Anzahl DESC;


#c)
mysql -u root -p
Passwort: keines
CREATE USER "Finanzamt"@"localhost" IDENTIFIED BY "Steuerfahnder";
GRANT SELECT ON Geld_her.Geld_Termin TO "Finanzamt"@"localhost";

Konsole schließen, neu öffnen und sich (zu Testzwecken) als Finanzamt einloggen:

mysql -u Finanzamt -p	  
Passwort: Steuerfahnder
SHOW GRANTS;

Konsole schließen, neu öffnen und sich (um User Finanzamt zu löschen) als root einloggen:

mysql -u root -p
Passwort: keines
DROP USER "Finanzamt"@"localhost";
SELECT user FROM mysql.user; # Die Kontrolle zeigt, dass der User "Finanzamt"@"localhost" nun nicht mehr existiert