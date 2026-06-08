-- Dieser Befehl sollte einen Fehler auslösen (Constraint Violation)
INSERT INTO mitarbeiter (
    mitarbeiter_nummer, vorname, nachname, abteilung, 
    eintritts_datum, gehalt, stundenlohn, wochenstunden, 
    geschlecht, angelegt_am, angelegt_von, letzte_aenderung_von
) VALUES (
    'TEST-001', 'Fehler', 'Beides', 'Testabteilung', 
    '2026-01-01', 5000.00, 25.00, 40, 'd', 
    NOW(), 'Test_User', '-'
);