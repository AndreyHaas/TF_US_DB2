-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Erstellungszeit: 05. Jun 2026 um 08:26
-- Server-Version: 10.4.32-MariaDB
-- PHP-Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Datenbank: `transaktion`
--
CREATE DATABASE IF NOT EXISTS `transaktion` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `transaktion`;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `leute`
--

CREATE TABLE `leute` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `kontostand` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Daten für Tabelle `leute`
--

INSERT INTO `leute` (`id`, `name`, `kontostand`) VALUES
(1, 'Alex Schmidt', 2000),
(2, 'Emma Müller', 500),
(3, 'Ben Weber', 500);

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `leute`
--
ALTER TABLE `leute`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT für exportierte Tabellen
--

--
-- AUTO_INCREMENT für Tabelle `leute`
--
ALTER TABLE `leute`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
