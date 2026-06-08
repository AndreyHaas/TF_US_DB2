START TRANSACTION;

-- 1. Gültiges Update: Gehaltserhöhung für Max
UPDATE mitarbeiter SET gehalt = 7000.00, letzte_aenderung_von = 'Boss' 
WHERE mitarbeiter_nummer = 'MA-001';

-- 2. UNGÜLTIGES Update: Wir versuchen, Sarah (MA-004) Gehalt UND Lohn zu geben
-- Dies wird fehlschlagen (Constraint Violation)
UPDATE mitarbeiter SET stundenlohn = 50.00, wochenstunden = 40 
WHERE mitarbeiter_nummer = 'MA-004';

-- Da der zweite Befehl einen Fehler geworfen hat, machen wir den Rollback
-- (In einer Applikation würde dies der Error-Handler tun)
ROLLBACK;

-- Prüfung: Max (MA-001) darf NICHT 7000.00 verdienen, sondern wieder sein altes Gehalt haben.
SELECT vorname, gehalt FROM mitarbeiter WHERE mitarbeiter_nummer = 'MA-001';