-- Exportiere Daten aus Tabelle ddl_db.mitarbeiter: ~7 rows (ungefähr)
DELETE FROM `mitarbeiter`;
INSERT INTO `mitarbeiter` (`id`, `mitarbeiter_nummer`, `vorname`, `nachname`, `abteilung`, `vorgesetzter_id`, `eintritts_datum`, `austritts_datum`, `gehalt`, `stundenlohn`, `wochenstunden`, `geschlecht`, `interessen`, `angelegt_am`, `angelegt_von`, `letzte_aenderung_am`, `letzte_aenderung_von`, `ist_geloescht`) VALUES
	(1, 'MA-001', 'Max', 'Mustermann-Schulz', 'IT-Strategie', NULL, '2023-01-01', NULL, 6500.00, NULL, NULL, 'm', 'Gaming,Musik', '2026-03-02 11:55:51', 'Admin_System', '2026-03-02 13:39:27', 'HR_Admin', 0),
	(2, 'MA-002', 'Erika', 'Schmidt', 'Personalwesen', 1, '2023-02-15', '2026-12-31', 4800.00, NULL, NULL, 'w', 'Lesen,Reisen', '2026-03-02 11:55:51', 'Admin_System', '2026-03-02 13:39:27', 'HR_Admin', 0),
	(3, 'MA-004', 'Sarah', 'König', 'Marketing', NULL, '2023-08-10', NULL, 4500.00, NULL, NULL, 'w', 'Kochen & Bakken', '2026-03-02 11:55:51', 'Admin_System', '2026-03-02 13:39:27', 'System_Audit', 1),
	(4, 'MA-003', 'Alex', 'Meyer', 'IT-Support', 1, '2023-05-01', NULL, NULL, 30.00, 40, 'd', 'Reisen,Gaming,Musik', '2026-03-02 11:55:51', 'Admin_System', '2026-03-02 13:39:27', 'Self_Service', 0),
	(5, 'MA-005', 'Thomas', 'Bauer', 'Marketing', 4, '2023-11-20', NULL, NULL, 24.50, 35, 'm', 'Sport & Fitness,Musik', '2026-03-02 11:55:51', 'Admin_System', '2026-03-02 13:39:27', 'Abteilungsleiter', 0),
	(6, 'TEST-003', 'Erfolg', 'Gehalt', 'Testabteilung', NULL, '2026-01-01', NULL, 4500.00, NULL, NULL, 'm', NULL, '2026-03-02 13:16:32', 'Test_User', '2026-03-03 08:48:29', '-', 1);
