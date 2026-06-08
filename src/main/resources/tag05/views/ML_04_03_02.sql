# Musterlösung zu A_04_03_02


#a(1)
CREATE VIEW View_1 AS 
SELECT Produkt_Name, COUNT(Abrechnung_ID) # COUNT(*) oder COUNT(Produkt.Produkt_ID) würde beim Produkt "TroppoCaro" fälschlich den Wert 1 ausgeben
                                          # COUNT(Abrechnung_ID) hingegen zählt die Verknüpfung von TroppoCaro mit NULL nicht mit
										  # Wer unbedingt Produkt-IDs zählen möchte, der kann aber auch COUNT(Abrechnung_Produkt.Produkt_ID) notieren
FROM Abrechnung_Produkt RIGHT JOIN Produkt ON Abrechnung_Produkt.Produkt_ID=Produkt.Produkt_ID
GROUP BY Produkt_Name;

#a(2)
SELECT * FROM View_1; # Wegen"*" ist der ALIAS für den Aggregatwert nicht zwingend erforderlich, sollte aber dennoch eingeführt werden
                      # (siehe Bemerkung zu Aufgabenstellung b)   


#b(1)
CREATE VIEW View_2 AS 
SELECT Vorname, Nachname, MAX(Datum) AS Letztes_Datum
FROM Kunde,Abrechnung
WHERE Kunde.Kunde_ID=Abrechnung.Kunde_id
GROUP BY Vorname, Nachname;

#b(2)
SELECT Vorname, Letztes_Datum FROM View_2 # würde man hier von 'MAX(Datum)' sprechen (anstelle von 'Letztes_Datum'), so würde das System versuchen 
                                          # den Maximalwert aus aus allen Werten des Attributs 'Datum' zu ermitteln ...
										  # ... aber dieses Attribut existiert in View_2 nicht!
WHERE Nachname="Myrnow";


#c)
mysql -u root -p
Password: ENTER
CREATE USER "Kundenbetreuer"@"localhost" IDENTIFIED BY "";
GRANT SELECT,INSERT ON Geld_her.Kunde TO "Kundenbetreuer"@"localhost";

 ### Nun einfach Konsole schließen, um sich anschließend als Kundenbetreuer anzumelden: ###

mysql -u Kundenbetreuer -p
Password: ENTER
SELECT * FROM Geld_her.Kunde; # Kundentabelle wird ausgegeben, da Kundenbetreuer das Recht hat, bei der Tabelle "Kunde" den SELECT zu verwenden
INSERT INTO Geld_her.Kunde(Vorname,Nachname,Email) VALUES("Timo","Test","abc"); # Auch der INSERT funktioniert, da er dieses Recht hat

# Für folgende Statements fehlt hingegen die Berechtigung:
SELECT * FROM Geld_her.Abrechnung; # => SELECT command denied to user 'kundenbetreuer'@'localhost' for table 'abrechnung'
DELETE FROM Geld_her.Kunde; # => DELETE command denied to user 'kundenbetreuer'@'localhost' for table 'kunde'

