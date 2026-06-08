# Musterlösung zu FPA_03_05_01_bis_03 (c)


CREATE DATABASE FPA_03_05_01_bis_03_c;
USE FPA_03_05_01_bis_03_c;

CREATE TABLE Pilot
(
    Pilot_ID INT(11) AUTO_INCREMENT,
    Vorname VARCHAR(255) NOT NULL,
    Nachname VARCHAR(255) NOT NULL,
    PRIMARY KEY(Pilot_ID)
);

CREATE TABLE Flugzeugtyp
(
    Flugzeugtyp_ID INT(11) AUTO_INCREMENT,
    Flugzeugtyp_Bezeichnung VARCHAR(255) NOT NULL,
    Anzahl_Sitzplaetze INT(11) NOT NULL,
	Reichweite_km INT(11) NOT NULL,
    PRIMARY KEY(Flugzeugtyp_ID)
);

CREATE TABLE Pilot_Flugzeugtyp
(
    Pilot_ID INT(11)NOT NULL,
    Flugzeugtyp_ID INT(11)NOT NULL,
	FOREIGN KEY(Pilot_ID) REFERENCES Pilot(Pilot_ID),
	FOREIGN KEY(Flugzeugtyp_ID) REFERENCES Flugzeugtyp(Flugzeugtyp_ID)
);

CREATE TABLE Flughafen
(
    Flughafen_ID INT(11) AUTO_INCREMENT,
    Flughafen_Bezeichnung VARCHAR(255) NOT NULL,
    Strassenname VARCHAR(255) NOT NULL,
    Hausnummer VARCHAR(255) NOT NULL,
    PLZ VARCHAR(255) NOT NULL,
    Ort VARCHAR(255) NOT NULL,
    PRIMARY KEY(Flughafen_ID)
);

CREATE TABLE Flugzeugtyp_Flughafen
(
    Flugzeugtyp_ID INT(11)NOT NULL,
    Flughafen_ID INT(11)NOT NULL,
	FOREIGN KEY(Flugzeugtyp_ID) REFERENCES Flugzeugtyp(Flugzeugtyp_ID),
	FOREIGN KEY(Flughafen_ID) REFERENCES Flughafen(Flughafen_ID)
);