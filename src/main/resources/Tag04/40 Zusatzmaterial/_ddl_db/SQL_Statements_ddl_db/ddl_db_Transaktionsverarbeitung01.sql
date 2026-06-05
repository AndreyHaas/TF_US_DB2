START TRANSACTION;

INSERT INTO mitarbeiter (
    mitarbeiter_nummer, vorname, nachname, abteilung, 
    eintritts_datum, gehalt, geschlecht, 
    angelegt_am, angelegt_von, letzte_aenderung_von
) VALUES (
    'TRANS-001', 'Ghost', 'User', 'Test', 
    '2026-03-01', 5000.00, 'd', 
    NOW(), 'Admin', '-'
);

-- Jetzt prüfen wir: In dieser Session ist der User sichtbar
SELECT * FROM mitarbeiter WHERE mitarbeiter_nummer = 'TRANS-001';

-- Wir entscheiden uns um: Alles rückgängig machen!
ROLLBACK;

-- Finale Prüfung: Der User darf NICHT mehr existieren
SELECT * FROM mitarbeiter WHERE mitarbeiter_nummer = 'TRANS-001';