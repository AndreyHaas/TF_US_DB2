# Musterlösung zu A_03_05_03


#a)	
SELECT * FROM Haeuser
WHERE standort=(SELECT wohnort FROM Hausbesitzer WHERE hausbesitzer_id=2);

#b)	
SELECT standort FROM Haeuser
WHERE wohnflaeche > (SELECT wohnflaeche FROM Haeuser WHERE haus_id=3);

#c)	
SELECT * FROM Geschaefte
WHERE haus_id IN (SELECT haus_id FROM Haeuser WHERE hausbesitzer_id=3);

#d)	
SELECT * FROM Haeuser
WHERE hausbesitzer_id IN 
(
    SELECT hausbesitzer_id FROM Haeuser NATURAL JOIN Hausbesitzer 
    WHERE standort=wohnort
);

#e)	
SELECT mieter_id,haus_id,nachname FROM Mieter NATURAL JOIN Haeuser
WHERE wohnflaeche = (SELECT max(wohnflaeche) FROM Haeuser);

#f)	
SELECT * FROM Mieter
WHERE haus_id IN(SELECT haus_id FROM Geschaefte);
