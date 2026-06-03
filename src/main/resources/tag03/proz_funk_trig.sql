-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Erstellungszeit: 06. Aug 2023 um 14:14
-- Server-Version: 10.4.28-MariaDB
-- PHP-Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Datenbank: `proz_funk_trig`
--
CREATE DATABASE IF NOT EXISTS `proz_funk_trig` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `proz_funk_trig`;

DELIMITER $$
--
-- Prozeduren
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `Backup` ()   BEGIN
	DROP TABLE IF EXISTS bu;
    CREATE TABLE IF NOT EXISTS bu AS
    SELECT * FROM testdaten;

    -- SELECT * INTO testdaten_BU FROM testdaten;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Backup_DatumZeit` ()   BEGIN
	DECLARE statement VARCHAR(255);
	DECLARE tabName VARCHAR(255);
    DECLARE jahr VARCHAR(10);
    DECLARE monat VARCHAR(10);
    DECLARE tag VARCHAR(10);
    DECLARE stunde VARCHAR(10);
    DECLARE minute VARCHAR(10);
    DECLARE sekunde VARCHAR(10);

	SET jahr = (SELECT YEAR(CURRENT_DATE()));
	SET monat = LPAD((SELECT MONTH(CURRENT_DATE())),2,"0");
	SET tag = LPAD((SELECT DAY(CURRENT_DATE())),2,"0");

	SET stunde = LPAD((SELECT HOUR(CURRENT_TIME())),2,"0");
	SET minute = LPAD((SELECT MINUTE(CURRENT_TIME())),2,"0");
	SET sekunde = LPAD((SELECT SECOND(CURRENT_TIME())),2,"0");

	SET tabname = CONCAT("bu_", jahr, monat, tag, "_", stunde, minute, sekunde);
	SET @statement = CONCAT("CREATE TABLE ", tabname, " AS SELECT * FROM testdaten;");
    PREPARE bla FROM @statement;
    EXECUTE bla;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DatenErzeugen` ()   BEGIN
	DECLARE geld  float(10,2);
	DECLARE vor  VARCHAR(255);
	DECLARE nach  VARCHAR(255);
    DECLARE zaehler INT(11);
    DECLARE maxwert INT(11);
    DECLARE zufall INT(11);

	SET zaehler = 0;
	SET maxwert =  1000;

	DELETE FROM testdaten;

	while zaehler < maxwert do
    	SET geld = (SELECT FLOOR(RAND()*(80000-1+1)+1));
        SET zufall = (SELECT FLOOR(RAND()*(  100-1+1)+1));
        SET vor = (SELECT namen.Vorname1 FROM namen WHERE namen.ID = zufall);
        SET zufall = (SELECT FLOOR(RAND()*(  100-1+1)+1));
        SET nach = (SELECT namen.Nachname FROM namen WHERE namen.ID = zufall);
        INSERT INTO testdaten (Vorname, Nachname, Kontostand) VALUES(vor, nach, geld);
        SET zaehler = zaehler + 1;
    end while;
END$$

--
-- Funktionen
--
CREATE DEFINER=`root`@`localhost` FUNCTION `auswerten` (`wert` FLOAT(10,2)) RETURNS VARCHAR(20) CHARSET utf8 COLLATE utf8_general_ci  BEGIN
    DECLARE antwort VARCHAR(20);
    IF wert > 50000 THEN
		SET antwort = 'REICH';
    ELSEIF (wert <= 50000 AND wert >= 10000) THEN
        SET antwort = 'WOHLHABEND';
    ELSEIF wert < 10000 THEN
        SET antwort = 'KOMMT ZURECHT';
    END IF;
	RETURN (antwort);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `logtable`
--
CREATE TABLE `logtable` (
  `Log_ID` int(11) NOT NULL,
  `Testdaten_ID` int(11) NOT NULL,
  `Alt` varchar(255) NOT NULL,
  `Neu` varchar(255) NOT NULL,
  `Datum` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Tabellenstruktur für Tabelle `namen`
--
CREATE TABLE `namen` (
  `ID` int(3) NOT NULL,
  `Vorname1` varchar(10) DEFAULT NULL,
  `Vorname2` varchar(13) DEFAULT NULL,
  `Nachname` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Daten für Tabelle `namen`
--
INSERT INTO `namen` (`ID`, `Vorname1`, `Vorname2`, `Nachname`) VALUES
(1, 'Adler', 'Adalin', 'Albert'),
(2, 'Adolf', 'Adalind', 'Barnhart'),
(3, 'Adolph', 'Adelaide', 'Barrett'),
(4, 'Adolphus', 'Adelyne', 'Bauer'),
(5, 'Alaric', 'Adler', 'Becker'),
(6, 'Albert', 'Alese', 'Brandt'),
(7, 'Alois', 'Alissia', 'Braun'),
(8, 'Alphonse', 'Analise', 'Bruno'),
(9, 'Ansel', 'Angelika', 'Bush'),
(10, 'Arne', 'Annalena', 'Coffman'),
(11, 'Arnulfo', 'Anneliese', 'Conrad'),
(12, 'August', 'August', 'Diehl'),
(13, 'Barrett', 'Bayley', 'Dietz'),
(14, 'Bastian', 'Bergen', 'Emerson'),
(15, 'Berlin', 'Berlin', 'Emery'),
(16, 'Bernhard', 'Berlynn', 'Engel'),
(17, 'Brandt', 'Carolanne', 'Engle'),
(18, 'Brenner', 'Carolin', 'Fink'),
(19, 'Bruno', 'Cecil', 'Fischer'),
(20, 'Buell', 'Delmy', 'Frey'),
(21, 'Cecil', 'Derika', 'Fritz'),
(22, 'Conrad', 'Doretta', 'Frye'),
(23, 'Dietrich', 'Elke', 'Funk'),
(24, 'Dominik', 'Elta', 'Geiger'),
(25, 'Dresden', 'Emerson', 'Grimm'),
(26, 'Egbert', 'Emery', 'Gunter'),
(27, 'Emerson', 'Emma', 'Haas'),
(28, 'Emery', 'Emme', 'Hahn'),
(29, 'Erich', 'Erna', 'Hammer'),
(30, 'Ernst', 'Esly', 'Hartman'),
(31, 'Ewald', 'Franziska', 'Hedrick'),
(32, 'Ferdinand', 'Frieda', 'Helms'),
(33, 'Fischer', 'Gerda', 'Herbert'),
(34, 'Florian', 'Gertrude', 'Herman'),
(35, 'Franz', 'Gisel', 'Hinkle'),
(36, 'Fritz', 'Gissela', 'Hoffman'),
(37, 'Garin', 'Greta', 'Hoover'),
(38, 'Gehrig', 'Gretchen', 'Houser'),
(39, 'Gerhard', 'Gretta', 'Huber'),
(40, 'Gunther', 'Hannelore', 'Kaiser'),
(41, 'Hans', 'Hedwig', 'Kern'),
(42, 'Hansel', 'Hedy', 'Klein'),
(43, 'Harald', 'Heide', 'Koch'),
(44, 'Heinz', 'Heidi', 'Koehler'),
(45, 'Herb', 'Heidy', 'Koenig'),
(46, 'Herbert', 'Helga', 'Krause'),
(47, 'Herman', 'Hilda', 'Krueger'),
(48, 'Hermann', 'Ilse', 'Kruse'),
(49, 'Hilbert', 'Irma', 'Kuhn'),
(50, 'Hoover', 'Jannis', 'Kurtz'),
(51, 'Jaeger', 'Jisela', 'Lange'),
(52, 'Johann', 'Johann', 'Lowe'),
(53, 'Josef', 'Johanna', 'Ludwig'),
(54, 'Jule', 'Jule', 'Lutz'),
(55, 'Kaiser', 'Kalyssa', 'Mann'),
(56, 'Karey', 'Karey', 'Messer'),
(57, 'Karl', 'Karlie', 'Metzger'),
(58, 'Kemper', 'Karly', 'Meyer'),
(59, 'Kern', 'Katharina', 'Miller'),
(60, 'Klaus', 'Katrin', 'Moser'),
(61, 'Kohl', 'Katrina', 'Moyer'),
(62, 'Kolbe', 'Klara', 'Mueller'),
(63, 'Kole', 'Leidy', 'Muller'),
(64, 'Konrad', 'Lena', 'Ott'),
(65, 'Kurt', 'Leyna', 'Otto'),
(66, 'Kyzer', 'Liesel', 'Peters'),
(67, 'Leopold', 'Liesl', 'Reeder'),
(68, 'Loy', 'Lorelei', 'Richter'),
(69, 'Loyce', 'Loreli', 'Ritter'),
(70, 'Ludwig', 'Lorilei', 'Roth'),
(71, 'Lukas', 'Loy', 'Rucker'),
(72, 'Manfred', 'Loyce', 'Schaefer'),
(73, 'Markus', 'Luann', 'Schmidt'),
(74, 'Maximilian', 'Ludy', 'Schmitt'),
(75, 'Merle', 'Magdalen', 'Schneider'),
(76, 'Meyer', 'Marchell', 'Schroeder'),
(77, 'Miller', 'Marykatherine', 'Schultz'),
(78, 'Norbert', 'Mathilde', 'Schulz'),
(79, 'Oswald', 'Merle', 'Schumacher'),
(80, 'Otto', 'Miller', 'Schwartz'),
(81, 'Rodrick', 'Morgen', 'Shoemaker'),
(82, 'Rommel', 'Nixie', 'Stahl'),
(83, 'Rudolf', 'Odilia', 'Stark'),
(84, 'Ruger', 'Renate', 'Stover'),
(85, 'Ryken', 'Rilla', 'Tolbert'),
(86, 'Ryker', 'Robyn', 'Trotter'),
(87, 'Severin', 'Romy', 'Vogel'),
(88, 'Steffen', 'Rosellen', 'Wagner'),
(89, 'Stephan', 'Sharlyn', 'Walter'),
(90, 'Timm', 'Tilly', 'Weber'),
(91, 'Tolbert', 'Tosha', 'Weiss'),
(92, 'Volney', 'Trudi', 'Werner'),
(93, 'Walter', 'Vada', 'Wilhelm'),
(94, 'Waylon', 'Valda', 'Willard'),
(95, 'Werner', 'Vanda', 'Wolf'),
(96, 'Wilhelm', 'Vayda', 'Yeager'),
(97, 'Willard', 'Verena', 'Yoder'),
(98, 'Witten', 'Vondell', 'Yost'),
(99, 'Wolf', 'Zell', 'Ziegler'),
(100, 'Wolfgang', 'Zoelle', 'Zimmerman');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `testdaten`
--

CREATE TABLE `testdaten` (
  `Eine_ID` int(11) NOT NULL,
  `Vorname` varchar(250) NOT NULL,
  `Nachname` varchar(250) NOT NULL,
  `Kontostand` float(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Trigger `testdaten`
--
DELIMITER $$
CREATE TRIGGER `NachUpdate` AFTER UPDATE ON `testdaten` FOR EACH ROW BEGIN
    IF OLD.Vorname <> NEW.Vorname THEN
        INSERT INTO logtable(Testdaten_ID, Alt, Neu, Datum)
        VALUES(OLD.Eine_ID, OLD.Vorname, NEW.Vorname, CURDATE());
    END IF;
    IF OLD.Nachname <> NEW.Nachname THEN
        INSERT INTO logtable(Testdaten_ID, Alt, Neu, Datum)
        VALUES(OLD.Eine_ID, OLD.Nachname, NEW.Nachname, CURDATE());
    END IF;
    IF OLD.Kontostand <> NEW.Kontostand THEN
        INSERT INTO logtable(Testdaten_ID, Alt, Neu, Datum)
        VALUES(OLD.Eine_ID, ROUND(OLD.Kontostand, 2), ROUND(NEW.Kontostand, 2), CURDATE());
    END IF;
END
$$
DELIMITER ;

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `logtable`
--
ALTER TABLE `logtable`
  ADD PRIMARY KEY (`Log_ID`);

--
-- Indizes für die Tabelle `namen`
--
ALTER TABLE `namen`
  ADD PRIMARY KEY (`ID`);

--
-- Indizes für die Tabelle `testdaten`
--
ALTER TABLE `testdaten`
  ADD PRIMARY KEY (`Eine_ID`);

--
-- AUTO_INCREMENT für exportierte Tabellen
--

--
-- AUTO_INCREMENT für Tabelle `logtable`
--
ALTER TABLE `logtable`
  MODIFY `Log_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT für Tabelle `namen`
--
ALTER TABLE `namen`
  MODIFY `ID` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=101;

--
-- AUTO_INCREMENT für Tabelle `testdaten`
--
ALTER TABLE `testdaten`
  MODIFY `Eine_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1001;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
