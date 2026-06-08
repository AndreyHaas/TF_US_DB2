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
END;
//

DELIMITER ;