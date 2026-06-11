/*
	DDL >> data definition language >> Bearbeiten der STRUKTUR einer Datenbank mit ihren Tabellen
		CREATE database
        DROP database
        CREATE table
        DROP table
        ALTER database
        ALTER table

	DML >> data manipulation language >> Bearbeiten des INHALTS der Datenbank bzw. der Tabellen
		INSERT >> NEUE Datensätze in eine vorhandene Tabelle einfügen
        UPDATE >> VORHANDENE Datensätze verändern
		DELETE >> Datensätze löschen
        TRUNCATE >> kompletten Inhalt einer Tabelle löschen

	DQL >> data query language
		SELECT >> VORHANDENE Daten aus Tabellen abfragen

	DCL >> data control language
		GRANT >> Berechtigungen bearbeiten
*/

-- DDL
CREATE DATABASE hochbau_v02;
USE hochbau_v02;

CREATE TABLE abteilungen(
	abteilungsnummer INT(11) PRIMARY KEY,	-- primary key beinhaltet NOT NULL und UNIQUE
	abteilungsname CHAR(50)
);

create table mitarbeiter(
	mitarbeiterID int primary key,
  mitarbeitername char(50),
  maschinenberechtigung int,
  plz char(5),
  abtlg_nr int,						-- das wird die Fremdschlüsselbeziehung auf abteilungen
  foreign key (abtlg_nr) references abteilungen(abteilungsnummer),
  datum_einstellung date
-- die folgende Variante funktioniert in MySQL NICHT sauber, kann aber in Prfg verwendet werden
-- abtlg_nr int references abteilungen(abteilungsnummer)
);

CREATE TABLE baustellen(
	baustellennummer INT(11) PRIMARY KEY,
	baustellenname CHAR(100)
);

CREATE TABLE mitarbeiter_auf_baustelle(
	mitarbeiterID INT(11),
	baustellennummer INT,
	FOREIGN KEY (mitarbeiterID) REFERENCES mitarbeiter(mitarbeiterID),
	FOREIGN KEY (baustellennummer) REFERENCES baustellen(baustellennummer),
	PRIMARY KEY (mitarbeiterID, baustellennummer)
);