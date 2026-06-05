-- Dieser Befehl sollte ebenfalls einen Fehler auslösen
INSERT INTO mitarbeiter (
    mitarbeiter_nummer, vorname, nachname, abteilung, 
    eintritts_datum, gehalt, stundenlohn, wochenstunden, 
    geschlecht, angelegt_am, angelegt_von, letzte_aenderung_von
) VALUES (
    'TEST-002', 'Fehler', 'Nichts', 'Testabteilung', 
    '2026-01-01', NULL, NULL, NULL, 'd', 
    NOW(), 'Test_User', '-'
);