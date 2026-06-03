-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Erstellungszeit: 06. Aug 2023 um 14:12
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
-- Datenbank: `demo_geld_her`
--
CREATE DATABASE IF NOT EXISTS `demo_geld_her` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `demo_geld_her`;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `abrechnung`
--

CREATE TABLE `abrechnung` (
  `Abrechnung_ID` int(11) NOT NULL,
  `Kunde_ID` int(11) NOT NULL,
  `Datum` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Daten für Tabelle `abrechnung`
--

INSERT INTO `abrechnung` (`Abrechnung_ID`, `Kunde_ID`, `Datum`) VALUES
(1, 1, '2021-05-05'),
(2, 3, '2021-10-07'),
(3, 2, '2021-10-11'),
(4, 3, '2021-10-16'),
(5, 5, '2021-10-25'),
(6, 4, '2021-11-03'),
(7, 3, '2021-11-05'),
(8, 2, '2021-11-09'),
(9, 1, '2021-11-17'),
(10, 7, '2022-02-14'),
(12, 11, '2023-04-25'),
(13, 10, '2023-04-25');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `abrechnung_produkt`
--

CREATE TABLE `abrechnung_produkt` (
  `Abrechnung_ID` int(11) NOT NULL,
  `Produkt_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Daten für Tabelle `abrechnung_produkt`
--

INSERT INTO `abrechnung_produkt` (`Abrechnung_ID`, `Produkt_ID`) VALUES
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
(9, 1),
(12, 1),
(12, 2),
(12, 4),
(12, 7),
(12, 7),
(12, 8),
(12, 9),
(13, 1),
(13, 2),
(13, 3),
(13, 6);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `hersteller`
--

CREATE TABLE `hersteller` (
  `Hersteller_ID` int(11) NOT NULL,
  `Spedition_ID` int(11) NOT NULL,
  `Hersteller_Name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Daten für Tabelle `hersteller`
--

INSERT INTO `hersteller` (`Hersteller_ID`, `Spedition_ID`, `Hersteller_Name`) VALUES
(1, 2, 'Contrabit'),
(2, 1, 'AntiByte'),
(3, 3, 'UltraBug'),
(4, 5, 'Hatnix 1992'),
(5, 4, 'Ladenhut AG'),
(8, 7, 'Who\'s your daddy?'),
(9, 1, 'Let\'s Do This'),
(10, 3, 'DOLLE SACHEN');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `kunde`
--

CREATE TABLE `kunde` (
  `Kunde_ID` int(11) NOT NULL,
  `Vorname` varchar(255) DEFAULT NULL,
  `Nachname` varchar(255) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Passwort` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Daten für Tabelle `kunde`
--

INSERT INTO `kunde` (`Kunde_ID`, `Vorname`, `Nachname`, `Email`, `Passwort`) VALUES
(1, 'Elli', 'Rot', 'rot@xyz.de', 'd1bf93299de1b68e6d382c893bf1215f'),
(2, 'Vera', 'Deise', 'deise@xyz.de', '642042e7bb028edd8287765a980cc41a'),
(3, 'Witali', 'Myrnow', 'myr@xyz.de', 'd1bf93299de1b68e6d382c893bf1215f'),
(4, 'Rita', 'Myrnow', 'myr@xyz.de', '642042e7bb028edd8287765a980cc41a'),
(5, 'Eva', 'Hahn', 'ehahn@xyz.de', 'd1bf93299de1b68e6d382c893bf1215f'),
(6, 'Gala', 'Nieda', 'gala@xyz.de', '642042e7bb028edd8287765a980cc41a'),
(7, 'Peter', 'Kaufnix', 'nix@xyz.de', 'd1bf93299de1b68e6d382c893bf1215f'),
(8, 'Hugo', 'Habicht', 'Hugo.Habicht@bla.de', '642042e7bb028edd8287765a980cc41a'),
(9, 'Walter', 'Watt', 'wa.wa@whatever.com', 'd1bf93299de1b68e6d382c893bf1215f'),
(10, 'Susi', 'Sorglos', 'su.si@sorg.los', 'ab56b4d92b40713acc5af89985d4b786'),
(11, 'Paula', 'Prada', 'p.p@p.de', 'e8636ea013e682faf61f56ce1cb1ab5c');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `produkt`
--

CREATE TABLE `produkt` (
  `Produkt_ID` int(11) NOT NULL,
  `Hersteller_ID` int(11) NOT NULL,
  `Produkt_Name` varchar(255) NOT NULL,
  `Euro_Preis` float(11,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Daten für Tabelle `produkt`
--

INSERT INTO `produkt` (`Produkt_ID`, `Hersteller_ID`, `Produkt_Name`, `Euro_Preis`) VALUES
(1, 2, 'tool 2.0', 15.98),
(2, 2, 'tool 3.1', 22.75),
(3, 1, 'solver 1000', 31.69),
(4, 1, 'solver premium', 45.05),
(5, 3, 'Do IT edition 1', 98.00),
(6, 5, 'TroppoCaro', 1000.00),
(7, 3, 'Must Have', 123.45),
(8, 5, 'Nice To Have', 1000.00),
(9, 8, 'Spitzen-Gadget 22.4', 12.45);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `spedition`
--

CREATE TABLE `spedition` (
  `Spedition_ID` int(11) NOT NULL,
  `Spedition_Name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Daten für Tabelle `spedition`
--

INSERT INTO `spedition` (`Spedition_ID`, `Spedition_Name`) VALUES
(1, 'Speedvan GmbH'),
(2, 'RocketLogistic AG'),
(3, 'Turbo Transport'),
(4, 'Parktnur'),
(5, 'Kriegtnix'),
(6, 'Ganzal Lein'),
(7, 'Fahr mich heim'),
(8, 'UPS');

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `abrechnung`
--
ALTER TABLE `abrechnung`
  ADD PRIMARY KEY (`Abrechnung_ID`),
  ADD KEY `Kunde_ID` (`Kunde_ID`);

--
-- Indizes für die Tabelle `abrechnung_produkt`
--
ALTER TABLE `abrechnung_produkt`
  ADD KEY `Abrechnung_ID` (`Abrechnung_ID`),
  ADD KEY `Produkt_ID` (`Produkt_ID`);

--
-- Indizes für die Tabelle `hersteller`
--
ALTER TABLE `hersteller`
  ADD PRIMARY KEY (`Hersteller_ID`),
  ADD KEY `Spedition_ID` (`Spedition_ID`);

--
-- Indizes für die Tabelle `kunde`
--
ALTER TABLE `kunde`
  ADD PRIMARY KEY (`Kunde_ID`);

--
-- Indizes für die Tabelle `produkt`
--
ALTER TABLE `produkt`
  ADD PRIMARY KEY (`Produkt_ID`),
  ADD KEY `Hersteller_ID` (`Hersteller_ID`);

--
-- Indizes für die Tabelle `spedition`
--
ALTER TABLE `spedition`
  ADD PRIMARY KEY (`Spedition_ID`);

--
-- AUTO_INCREMENT für exportierte Tabellen
--

--
-- AUTO_INCREMENT für Tabelle `abrechnung`
--
ALTER TABLE `abrechnung`
  MODIFY `Abrechnung_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT für Tabelle `hersteller`
--
ALTER TABLE `hersteller`
  MODIFY `Hersteller_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT für Tabelle `kunde`
--
ALTER TABLE `kunde`
  MODIFY `Kunde_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT für Tabelle `produkt`
--
ALTER TABLE `produkt`
  MODIFY `Produkt_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT für Tabelle `spedition`
--
ALTER TABLE `spedition`
  MODIFY `Spedition_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Constraints der exportierten Tabellen
--

--
-- Constraints der Tabelle `abrechnung`
--
ALTER TABLE `abrechnung`
  ADD CONSTRAINT `abrechnung_ibfk_1` FOREIGN KEY (`Kunde_ID`) REFERENCES `kunde` (`Kunde_ID`);

--
-- Constraints der Tabelle `abrechnung_produkt`
--
ALTER TABLE `abrechnung_produkt`
  ADD CONSTRAINT `abrechnung_produkt_ibfk_1` FOREIGN KEY (`Abrechnung_ID`) REFERENCES `abrechnung` (`Abrechnung_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `abrechnung_produkt_ibfk_2` FOREIGN KEY (`Produkt_ID`) REFERENCES `produkt` (`Produkt_ID`);

--
-- Constraints der Tabelle `hersteller`
--
ALTER TABLE `hersteller`
  ADD CONSTRAINT `hersteller_ibfk_1` FOREIGN KEY (`Spedition_ID`) REFERENCES `spedition` (`Spedition_ID`);

--
-- Constraints der Tabelle `produkt`
--
ALTER TABLE `produkt`
  ADD CONSTRAINT `produkt_ibfk_1` FOREIGN KEY (`Hersteller_ID`) REFERENCES `hersteller` (`Hersteller_ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
