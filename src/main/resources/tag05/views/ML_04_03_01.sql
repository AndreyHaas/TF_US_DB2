# Musterlösung zu A_04_03_01


#a)
CREATE VIEW View_1 AS
SELECT Produkt_Name, Euro_Preis,Spedition_Name
FROM Produkt INNER JOIN Hersteller ON Produkt.Hersteller_ID=Hersteller.Hersteller_ID
     INNER JOIN Spedition ON Hersteller.Spedition_ID=Spedition.Spedition_ID;

SELECT Produkt_Name, Spedition_Name
FROM View_1
ORDER BY Euro_Preis DESC LIMIT 1;


#b)
CREATE VIEW View_2 AS
SELECT Produkt_Name,Euro_Preis,Hersteller_Name
FROM Produkt INNER JOIN Hersteller ON Produkt.Hersteller_ID=Hersteller.Hersteller_ID;

SELECT * FROM View_2
ORDER BY Euro_Preis DESC LIMIT 3;


#c)

####################################
# User anlegen und Rechte vergeben #
####################################
# als root einloggen
mysql -u root -p 

# Bei Password einfach "ENTER" drücken

# Den User "Admin" anlegen (er kann sich im localhost mit dem Passwort "1234abcd" einloggen)
CREATE USER "Admin"@"localhost" IDENTIFIED BY "1234abcd";

Rechtevergabe (Abfrage-Erlaubnis) für Admin (sofern er sich in localhost anmeldet)
GRANT SELECT ON *.* TO "Admin"@"localhost";


####################################
#      User-Rechte testen          #
####################################
# als Admin einloggen
mysql -u Admin -p

# Das Password 1234abcd eingeben

# Datenbank auswählen
USE geld_her; 

# Test, ob (für Admin auf dem localhost) das Recht besteht, in DB geld_her eine Abfrage zur Tabelle Kunde vorzunehmen:
SELECT * FROM Kunde;

/*

Es klappte:
+----------+---------+----------+--------------+
| Kunde_ID | Vorname | Nachname | Email        |
+----------+---------+----------+--------------+
|        1 | Elli    | Rot      | rot@xyz.de   |
|        2 | Vera    | Deise    | deise@xyz.de |
|        3 | Witali  | Myrnow   | myr@xyz.de   |
|        4 | Rita    | Myrnow   | myr@xyz.de   |
|        5 | Eva     | Hahn     | ehahn@xyz.de |
|        6 | Gala    | Nieda    | gala@xyz.de  |
|        7 | Peter   | Kaufnix  | nix@xyz.de   |
+----------+---------+----------+--------------+

*/                                      