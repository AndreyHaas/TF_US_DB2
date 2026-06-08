-- Dieser Befehl wird erfolgreich ausgeführt
INSERT INTO mitarbeiter (
    mitarbeiter_nummer, vorname, nachname, abteilung, 
    eintritts_datum, gehalt, stundenlohn, wochenstunden, 
    geschlecht, angelegt_am, angelegt_von, letzte_aenderung_von
) VALUES (
    'TEST-003', 'Erfolg', 'Gehalt', 'Testabteilung', 
    '2026-01-01', 4500.00, NULL, NULL, 'm', 
    NOW(), 'Test_User', '-'
);