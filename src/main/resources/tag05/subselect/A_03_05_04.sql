CREATE DATABASE A_03_05_04;
USE A_03_05_04;

CREATE TABLE Hausbesitzer
(
    hausbesitzer_id int(9),
    nachname varchar(100),
    wohnort varchar(100),
    PRIMARY KEY(hausbesitzer_id)
);
INSERT INTO Hausbesitzer VALUES
(1,"Hausmann","Aachen"),
(2,"Hossmann","Berlin"),
(3,"Hissmann","Chemnitz");

CREATE TABLE Haeuser
(
    haus_id int(9),
    hausbesitzer_id int(9),
    wohnflaeche float(10,1),
    standort varchar(100),
    PRIMARY KEY(haus_id),
    FOREIGN KEY(hausbesitzer_id) REFERENCES Hausbesitzer(hausbesitzer_id)
);
INSERT INTO Haeuser VALUES
(1,2,100.11,"Aachen"),
(2,3,200.22,"Berlin"),
(3,3,300.33,"Chemnitz"),
(4,1,400.44,"Dresden"),
(5,2,500.55,"Essen");

CREATE TABLE Mieter
(
    mieter_id int(9),
    haus_id int(9),
    nachname varchar(100),
    PRIMARY KEY(mieter_id),
    FOREIGN KEY(haus_id) REFERENCES Haeuser(haus_id)
);
INSERT INTO Mieter VALUES
(1,3,"Mietow"),
(2,3,"Motow"),
(3,2,"Matow"),
(4,1,"Mutow"),
(5,4,"Mietowitsch"),
(6,5,"Motowitsch"),
(7,4,"Matowitsch"),
(8,1,"Mutowitsch");

CREATE TABLE Geschaefte
(
    geschaeft_id int(9),
    haus_id int(9),
    branche varchar(100),
    PRIMARY KEY(geschaeft_id),
    FOREIGN KEY(haus_id) REFERENCES Haeuser(haus_id)
);
INSERT INTO Geschaefte VALUES
(1,3,"Apotheke"),
(2,4,"Buchladen"),
(3,1,"Cafe");

