-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server-Version:               11.8.6-MariaDB - MariaDB Server
-- Server-Betriebssystem:        Win64
-- HeidiSQL Version:             12.15.0.7171
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

-- Exportiere Daten aus Tabelle ddl_db.mitarbeiter: ~7 rows (ungefähr)
DELETE FROM `mitarbeiter`;
INSERT INTO `mitarbeiter` (`id`, `mitarbeiter_nummer`, `vorname`, `nachname`, `abteilung`, `vorgesetzter_id`, `eintritts_datum`, `austritts_datum`, `gehalt`, `stundenlohn`, `wochenstunden`, `geschlecht`, `interessen`, `angelegt_am`, `angelegt_von`, `letzte_aenderung_am`, `letzte_aenderung_von`, `ist_geloescht`) VALUES
	(1, 'MA-001', 'Max', 'Mustermann-Schulz', 'IT-Strategie', NULL, '2023-01-01', NULL, 6500.00, NULL, NULL, 'm', 'Gaming,Musik', '2026-03-02 11:55:51', 'Admin_System', '2026-03-02 13:39:27', 'HR_Admin', 0),
	(2, 'MA-002', 'Erika', 'Schmidt', 'Personalwesen', 1, '2023-02-15', '2026-12-31', 4800.00, NULL, NULL, 'w', 'Lesen,Reisen', '2026-03-02 11:55:51', 'Admin_System', '2026-03-02 13:39:27', 'HR_Admin', 0),
	(3, 'MA-004', 'Sarah', 'König', 'Marketing', NULL, '2023-08-10', NULL, 4500.00, NULL, NULL, 'w', 'Kochen & Bakken', '2026-03-02 11:55:51', 'Admin_System', '2026-03-02 13:39:27', 'System_Audit', 1),
	(4, 'MA-003', 'Alex', 'Meyer', 'IT-Support', 1, '2023-05-01', NULL, NULL, 30.00, 40, 'd', 'Reisen,Gaming,Musik', '2026-03-02 11:55:51', 'Admin_System', '2026-03-02 13:39:27', 'Self_Service', 0),
	(5, 'MA-005', 'Thomas', 'Bauer', 'Marketing', 4, '2023-11-20', NULL, NULL, 24.50, 35, 'm', 'Sport & Fitness,Musik', '2026-03-02 11:55:51', 'Admin_System', '2026-03-02 13:39:27', 'Abteilungsleiter', 0),
	(6, 'TEST-003', 'Erfolg', 'Gehalt', 'Testabteilung', NULL, '2026-01-01', NULL, 4500.00, NULL, NULL, 'm', NULL, '2026-03-02 13:16:32', 'Test_User', '2026-03-03 08:48:29', '-', 1);

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
