# Musterlösung zu A_04_03_03


#a(1)
CREATE VIEW Elli_Rot AS
SELECT Abrechnung.Abrechnung_ID, ifNULL(SUM(Euro_Preis),0) AS Summe
FROM Abrechnung LEFT JOIN Abrechnung_Produkt ON Abrechnung.Abrechnung_ID=Abrechnung_Produkt.Abrechnung_ID
     LEFT JOIN Produkt ON Abrechnung_Produkt.Produkt_ID=Produkt.Produkt_id
WHERE Kunde_ID=1
GROUP BY Abrechnung.Abrechnung_ID; 

# Antwort auf die Zusatzfrage:
# Es sollen auch Abrechnungs-IDs berücksichtigt werden, bei denen nur die Website von Geld_her besucht, aber nichts gekauft wurde.
# (ifNULL wird dann verwendet, weil man in solchen Fällen nicht die Summe "NULL", sondern den Zahlenwert "0" lesen möchte)

#a(2)
SELECT MAX(Summe) FROM Elli_Rot;


#b(1)
CREATE VIEW AVG_Preis AS
SELECT Abrechnung.Abrechnung_ID,Datum,AVG(Euro_Preis) AS Durchschnitt # Es soll kein Durchschnitt ermittelt werden, wenn nichts eingekauft wurde => KEIN ifNULL
FROM Abrechnung LEFT JOIN Abrechnung_Produkt ON Abrechnung.Abrechnung_ID=Abrechnung_Produkt.Abrechnung_ID
     LEFT JOIN Produkt ON Abrechnung_Produkt.Produkt_ID=Produkt.Produkt_id
GROUP BY Abrechnung.Abrechnung_ID,Datum;

#b(2)
SELECT MIN(Durchschnitt) FROM AVG_Preis;


#c)
mysql -u root -p
Passwort: Einfach mit ENTER fortfahren
CREATE USER "Elli Rot"@"localhost" IDENTIFIED BY "Captain Shira";
GRANT SELECT ON Geld_her.Elli_Rot TO "Elli Rot"@"localhost";

Konsole schließen, neu öffnen und sich (zu Testzwecken) als Elli Rot einloggen:

mysql -u Elli Rot -p
Passwort: Captain Shira
SELECT * FROM Geld_her.Elli_Rot; # Klappt, denn Elli Rot, hat das Recht, in der DB Geld_her bzgl. des VIEWs Elli_Rot Abfragen zu tätigen
SELECT * FROM Geld_her.Kunde; # Klappt korrekterweise nicht, da diese Rechte nicht vorliegen [SELECT command denied to user 'Elli Rot'@'localhost' for table 'kunde']