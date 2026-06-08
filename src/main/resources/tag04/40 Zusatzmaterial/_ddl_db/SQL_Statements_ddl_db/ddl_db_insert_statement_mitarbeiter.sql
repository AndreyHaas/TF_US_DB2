-- Mitarbeiter mit Gehalt (MA 1, 2 und 4)
INSERT INTO mitarbeiter (
    mitarbeiter_nummer, vorname, nachname, abteilung, 
    vorgesetzter_id, eintritts_datum, gehalt, stundenlohn, 
    wochenstunden, geschlecht, interessen, 
    angelegt_am, angelegt_von, letzte_aenderung_von
) VALUES 
(
    'MA-001', 'Max', 'Mustermann', 'IT-Leitung', 
    NULL, '2023-01-01', 6500.00, NULL, NULL, 'm', 'Gaming,Musik', 
    NOW(), 'Admin_System', '-'
),
(
    'MA-002', 'Erika', 'Schmidt', 'Personalwesen', 
    1, '2023-02-15', 4800.00, NULL, NULL, 'w', 'Lesen,Reisen', 
    NOW(), 'Admin_System', '-'
),
(
    'MA-004', 'Sarah', 'König', 'Marketing', 
    NULL, '2023-08-10', 4500.00, NULL, NULL, 'w', 'Kochen & Bakken', 
    NOW(), 'Admin_System', '-'
);

-- Mitarbeiter mit Stundenlohn (MA 3 und 5)
INSERT INTO mitarbeiter (
    mitarbeiter_nummer, vorname, nachname, abteilung, 
    vorgesetzter_id, eintritts_datum, gehalt, stundenlohn, 
    wochenstunden, geschlecht, interessen, 
    angelegt_am, angelegt_von, letzte_aenderung_von
) VALUES 
(
    'MA-003', 'Alex', 'Meyer', 'IT-Support', 
    1, '2023-05-01', NULL, 30.00, 40, 'd', 'Fotografieren,Gaming', 
    NOW(), 'Admin_System', '-'
),
(
    'MA-005', 'Thomas', 'Bauer', 'Marketing', 
    4, '2023-11-20', NULL, 24.50, 20, 'm', 'Sport & Fitness,Musik', 
    NOW(), 'Admin_System', '-'
);