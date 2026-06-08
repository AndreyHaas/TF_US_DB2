# Musterlösung zu FPA_03_05_01_bis_03 (e)

#(1)
UPDATE Pilot SET Nachname="Flöte"
WHERE Vorname="Peter" AND Nachname="Pan";

#(2)
UPDATE Flugzeugtyp SET Reichweite_km=Reichweite_km-1000
WHERE Flugzeugtyp_Bezeichnung="Fönbus";

#(3)
ALTER TABLE Pilot CHANGE Vorname Vorname VARCHAR(255);