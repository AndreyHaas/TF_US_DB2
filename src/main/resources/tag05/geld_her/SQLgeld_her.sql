#Musterlösung zu A_02_03_02

CREATE DATABASE Geld_her;
USE Geld_her;


CREATE TABLE Kunde 
(
  Kunde_ID INT(11) AUTO_INCREMENT,
  Vorname VARCHAR(255),
  Nachname VARCHAR(255) NOT NULL,
  Email VARCHAR(255) NOT NULL,
  PRIMARY KEY (Kunde_ID)
);
INSERT INTO Kunde(Kunde_ID, Vorname, Nachname, Email) VALUES
(1, "Elli", "Rot", "rot@xyz.de"),
(2, "Vera", "Deise", "deise@xyz.de"),
(3, "Witali", "Myrnow", "myr@xyz.de"),
(4, "Rita", "Myrnow", "myr@xyz.de"),
(5, "Eva", "Hahn", "ehahn@xyz.de"),
(6, "Gala", "Nieda", "gala@xyz.de"),    # Hat nie die Website von "Geld_her" besucht => KEINE Abrechnung_ID
(7, "Peter", "Kaufnix", "nix@xyz.de");  # Einmal die Website besucht (=> 1 Abrechnung_ID) aber nichts gekauft  


CREATE TABLE Abrechnung 
(
  Abrechnung_ID INT(11) AUTO_INCREMENT,
  Kunde_ID INT(11) NOT NULL,
  Datum DATE NOT NULL,
  PRIMARY KEY (Abrechnung_ID),
  FOREIGN KEY(Kunde_ID) REFERENCES Kunde(Kunde_ID)
);
INSERT INTO Abrechnung(Abrechnung_ID, Kunde_ID, Datum) VALUES
(1, 1, '2021-05-05'),
(2, 3, '2021-10-07'),
(3, 2, '2021-10-11'),
(4, 3, '2021-10-16'),
(5, 5, '2021-10-25'),
(6, 4, '2021-11-03'),
(7, 3, '2021-11-05'),
(8, 2, '2021-11-09'),
(9, 1, '2021-11-17'),
(10,7, '2022-02-14');


CREATE TABLE Spedition 
(
  Spedition_ID INT(11) AUTO_INCREMENT,
  Spedition_Name VARCHAR(255) NOT NULL,
  PRIMARY KEY (Spedition_ID)
);
INSERT INTO Spedition(Spedition_ID, Spedition_Name) VALUES
(1, "Speedvan GmbH"),
(2, "RocketLogistic AG"),
(3, "Turbo Transport"),
(4, "Parktnur"),    # arbeitet mit Hersteller "Ladenhut AG" zusammen, von dem aber noch nie etwas bestellt wurde
(5, "Kriegtnix"),   # arbeitet mit Hersteller "Hatnix 1992" zusammen, von dem "Geld_her" aber nichts anbietet
(6, "Ganzal Lein"); # arbeitet mit keinem Hersteller zusammen


CREATE TABLE Hersteller
(
  Hersteller_ID INT(11) AUTO_INCREMENT,
  Spedition_ID INT(11) NOT NULL,
  Hersteller_Name VARCHAR(255) NOT NULL,
  PRIMARY KEY (Hersteller_ID),
  FOREIGN KEY(Spedition_ID) REFERENCES Spedition(Spedition_ID)
);
INSERT INTO Hersteller(Hersteller_ID, Spedition_ID, Hersteller_Name) VALUES
(1, 2, "Contrabit"),
(2, 1, "AntiByte"),
(3, 3, "UltraBug"),
(4, 5, "Hatnix 1992"),
(5, 4, "Ladenhut AG");


CREATE TABLE Produkt 
(
  Produkt_ID INT(11) AUTO_INCREMENT,
  Hersteller_ID INT(11) NOT NULL,
  Produkt_Name VARCHAR(255) NOT NULL,
  Euro_Preis FLOAT(11,2) NOT NULL,
  PRIMARY KEY (Produkt_ID),
  FOREIGN KEY(Hersteller_ID) REFERENCES Hersteller(Hersteller_ID)
);
INSERT INTO Produkt (Produkt_ID, Hersteller_ID, Produkt_Name, EURO_preis) VALUES
(1, 2, "tool 2.0", 15.98),
(2, 2, "tool 3.1", 22.75),
(3, 1, "solver 1000", 31.69),
(4, 1, "solver premium", 45.05),
(5, 3, "Do IT edition 1", 98.00),
(6, 5, "TroppoCaro", 1000.00);


CREATE TABLE Abrechnung_Produkt
(
  Abrechnung_ID INT(11) NOT NULL,
  Produkt_ID INT(11) NOT NULL,
  FOREIGN KEY (Abrechnung_ID) REFERENCES Abrechnung(Abrechnung_ID),
  FOREIGN KEY (Produkt_ID) REFERENCES Produkt(Produkt_ID)
);
INSERT INTO Abrechnung_Produkt (Abrechnung_ID, Produkt_ID) VALUES
(1, 2),
(1, 4),
(1, 4),
(1, 5),
(2, 3),
(2, 5),
(3, 1),
(3, 1),
(3, 1),
(3, 5),
(4, 2),
(4, 3),
(5, 1),
(5, 2),
(6, 3),
(6, 2),
(6, 5),
(7, 2),
(8, 3),
(9, 1);


