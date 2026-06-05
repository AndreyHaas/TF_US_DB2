-- FEHLER 1: Versuch, einem Gehaltsempfänger zusätzlich einen Stundenlohn zu geben
-- (Verstoß: gehalt IS NOT NULL AND stundenlohn IS NOT NULL)
UPDATE mitarbeiter 
SET stundenlohn = 45.00, 
    wochenstunden = 40,
    letzte_aenderung_von = 'Admin_Fehler' 
WHERE mitarbeiter_nummer = 'MA-001';

-- FEHLER 2: Versuch, bei einem Lohnempfänger das Gehalt zu füllen, ohne Lohn zu löschen
-- (Verstoß gegen die Exklusivität)
UPDATE mitarbeiter 
SET gehalt = 5000.00, 
    letzte_aenderung_von = 'Admin_Fehler' 
WHERE mitarbeiter_nummer = 'MA-003';

-- FEHLER 3: Versuch, alle Vergütungsfelder auf NULL zu setzen
-- (Verstoß: Weder Fall 1 noch Fall 2 des Constraints sind erfüllt)
UPDATE mitarbeiter 
SET gehalt = NULL, 
    stundenlohn = NULL, 
    wochenstunden = NULL,
    letzte_aenderung_von = 'Admin_Fehler' 
WHERE mitarbeiter_nummer = 'MA-005';