-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server-Version:               11.8.6-MariaDB - MariaDB Server
-- Server-Betriebssystem:        Win64
-- HeidiSQL Version:             12.16.0.7229
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Exportiere Struktur von Tabelle ddl_db.mitarbeiter
CREATE TABLE IF NOT EXISTS `mitarbeiter` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mitarbeiter_nummer` varchar(20) NOT NULL,
  `vorname` varchar(50) NOT NULL,
  `nachname` varchar(50) NOT NULL,
  `abteilung` varchar(50) NOT NULL,
  `vorgesetzter_id` int(11) DEFAULT NULL,
  `eintritts_datum` date NOT NULL,
  `austritts_datum` date DEFAULT NULL,
  `gehalt` decimal(12,2) DEFAULT NULL,
  `stundenlohn` decimal(10,2) DEFAULT NULL,
  `wochenstunden` int(11) DEFAULT NULL,
  `geschlecht` enum('m','w','d') NOT NULL,
  `interessen` set('Gartenarbeit','Sport & Fitness','Lesen','Fotografieren','Kochen & Bakken','Reisen','Gaming','Musik') DEFAULT NULL,
  `angelegt_am` datetime NOT NULL DEFAULT current_timestamp(),
  `angelegt_von` varchar(20) NOT NULL,
  `letzte_aenderung_am` datetime DEFAULT NULL,
  `letzte_aenderung_von` varchar(20) NOT NULL,
  `ist_geloescht` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `mitarbeiter_nummer` (`mitarbeiter_nummer`),
  KEY `fk_vorgesetzter` (`vorgesetzter_id`),
  KEY `nachname` (`nachname`),
  KEY `idx_mitarbeiter_gehalt` (`gehalt`),
  CONSTRAINT `fk_vorgesetzter` FOREIGN KEY (`vorgesetzter_id`) REFERENCES `mitarbeiter` (`id`),
  CONSTRAINT `chk_vergütung_exklusiv` CHECK (`gehalt` is not null and `stundenlohn` is null and `wochenstunden` is null or `gehalt` is null and `stundenlohn` is not null and `wochenstunden` is not null)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Daten-Export vom Benutzer nicht ausgewählt

-- Exportiere Struktur von Trigger ddl_db.tr_mitarbeiter_audit_update
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,STRICT_ALL_TABLES';
DELIMITER //
CREATE TRIGGER tr_mitarbeiter_audit_update
BEFORE UPDATE ON mitarbeiter
FOR EACH ROW
BEGIN
    -- Verhindert das Ändern der Erstellungsdaten (Schutz der Integrität)
    SET NEW.angelegt_am = OLD.angelegt_am;
    SET NEW.angelegt_von = OLD.angelegt_von;

    -- Automatische Aktualisierung des Änderungszeitpunkts
    SET NEW.letzte_aenderung_am = NOW();
    
    -- Hinweis: 'letzte_aenderung_von' muss weiterhin im UPDATE-Statement 
    -- von der Applikation übergeben werden, um den User zu erfassen.
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
