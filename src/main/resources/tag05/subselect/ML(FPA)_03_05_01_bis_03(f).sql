# Musterlösung zu FPA_03_05_01_bis_03 (f)

#(1)
SELECT Vorname,Nachname
FROM Pilot,Pilot_Flugzeugtyp,Flugzeugtyp
WHERE Pilot.Pilot_ID=Pilot_Flugzeugtyp.Pilot_ID
      AND Pilot_Flugzeugtyp.Flugzeugtyp_ID=Flugzeugtyp.Flugzeugtyp_ID 
      AND Reichweite_km=(SELECT MAX(Reichweite_km) FROM Flugzeugtyp);
	  
#(2)
SELECT Flughafen_Bezeichnung,
       Strassenname,
       Hausnummer,
       PLZ,
       Ort
FROM Pilot_Flugzeugtyp,Flugzeugtyp,Flugzeugtyp_Flughafen,Flughafen
WHERE Pilot_Flugzeugtyp.Flugzeugtyp_ID=Flugzeugtyp.Flugzeugtyp_ID
      AND Flugzeugtyp.Flugzeugtyp_ID=Flugzeugtyp_Flughafen.Flugzeugtyp_ID
      AND Flugzeugtyp_flughafen.Flughafen_ID=Flughafen.Flughafen_ID
      AND Pilot_ID=(SELECT MIN(Pilot_ID) FROM Pilot);
	  
#(3)
SELECT Pilot.Pilot_ID,Nachname
FROM Pilot,Pilot_Flugzeugtyp
WHERE Pilot.Pilot_ID=Pilot_Flugzeugtyp.Pilot_ID
      AND Flugzeugtyp_ID IN(
          					   SELECT Flugzeugtyp.Flugzeugtyp_ID
          					   FROM Flugzeugtyp,Flugzeugtyp_Flughafen,Flughafen
                               WHERE Flugzeugtyp.Flugzeugtyp_ID=Flugzeugtyp_Flughafen.Flugzeugtyp_ID 
                                     AND Flugzeugtyp_Flughafen.Flughafen_ID=Flughafen.Flughafen_ID
                                     AND PLZ=(SELECT MAX(PLZ) FROM Flughafen) #Doppelte Verschachtelung
                           );

#(4)
SELECT Flugzeugtyp_Bezeichnung,
       Anzahl_Sitzplaetze
FROM Pilot,Pilot_Flugzeugtyp,Flugzeugtyp,Flugzeugtyp_Flughafen,Flughafen
WHERE Pilot.Pilot_ID=Pilot_Flugzeugtyp.Pilot_ID
      AND Pilot_Flugzeugtyp.Flugzeugtyp_ID=Flugzeugtyp.Flugzeugtyp_ID
      AND Flugzeugtyp.Flugzeugtyp_ID=Flugzeugtyp_Flughafen.Flugzeugtyp_ID
      AND Flugzeugtyp_Flughafen.Flughafen_ID=Flughafen.Flughafen_ID
      AND ((Vorname="Quax" AND Nachname="Bruch")XOR(Flughafen_Bezeichnung="Essen Mitte"));