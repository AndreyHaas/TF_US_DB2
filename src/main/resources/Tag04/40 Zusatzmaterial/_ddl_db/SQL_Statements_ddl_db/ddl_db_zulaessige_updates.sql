-- 1. Abteilungswechsel und Namensänderung (z.B. nach Heirat)
UPDATE mitarbeiter 
SET nachname = 'Mustermann-Schulz', 
    abteilung = 'IT-Strategie', 
    letzte_aenderung_von = 'HR_Admin' 
WHERE mitarbeiter_nummer = 'MA-001';

-- 2. Anpassung der Wochenstunden (für einen Lohnempfänger)
UPDATE mitarbeiter 
SET wochenstunden = 35, 
    letzte_aenderung_von = 'Abteilungsleiter' 
WHERE mitarbeiter_nummer = 'MA-005';

-- 3. Hinzufügen eines neuen Hobbys (Nutzung der SET-Funktionalität)
UPDATE mitarbeiter 
SET interessen = 'Gaming,Musik,Reisen', 
    letzte_aenderung_von = 'Self_Service' 
WHERE mitarbeiter_nummer = 'MA-003';

-- 4. Eintragung eines Austrittsdatums
UPDATE mitarbeiter 
SET austritts_datum = '2026-12-31', 
    letzte_aenderung_von = 'HR_Admin' 
WHERE mitarbeiter_nummer = 'MA-002';

-- 5. Logisches Löschen eines Mitarbeiters (Soft-Delete)
UPDATE mitarbeiter 
SET ist_geloescht = TRUE, 
    letzte_aenderung_von = 'System_Audit' 
WHERE mitarbeiter_nummer = 'MA-004';