# Musterlösung zu FPA_03_05_01_bis_03 (d)


INSERT INTO Pilot(Vorname,Nachname)
VALUES
("Quax","Bruch"),
("Mathias","Rust"),
("Peter","Pan");

INSERT INTO Flugzeugtyp(Flugzeugtyp_Bezeichnung,Anzahl_Sitzplaetze,Reichweite_km)
VALUES
("Bingo",100,10000),
("Chessnarr",10,800),
("Fönbus",200,20000),
("Sunloser",2,3000);

INSERT INTO Pilot_Flugzeugtyp
VALUES
(1,1),
(1,3),
(2,3),
(2,4),
(3,2);

INSERT INTO Flughafen(Flughafen_Bezeichnung,Strassenname,Hausnummer,PLZ,Ort)
VALUES
("Aachen Süd","Alm","22-35","12345","Aachen"),
("Berlin Ost","Bahn","15-44","23456","Berlin"),
("Chemnitz Nord","Cluse","25-32","34567","Chemnitz"),
("Düsseldorf West","Damm","88-101","45678","Düsseldorf"),
("Essen Mitte","Elle","35-41","56789","Essen"),
("Fürth 2","Furt","2b","67890","Fürth");

INSERT INTO Flugzeugtyp_Flughafen
VALUES
(2,1),
(3,1),
(4,1),
(1,2),
(2,2),
(2,3),
(2,4),
(2,5),
(2,6),
(4,6);