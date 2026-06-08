ALTER TABLE mitarbeiter
    -- Audit-Attribute
    ADD COLUMN angelegt_am DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ADD COLUMN angelegt_von VARCHAR(20) NOT NULL COLLATE 'utf8mb4_unicode_ci',
    
    -- Änderung-Attribute (jetzt mit NULL als Default)
    ADD COLUMN letzte_aenderung_am DATETIME NULL DEFAULT NULL,
    ADD COLUMN letzte_aenderung_von VARCHAR(20) NOT NULL COLLATE 'utf8mb4_unicode_ci',
    
    -- Soft-Delete Flag
    ADD COLUMN ist_geloescht BOOLEAN NOT NULL DEFAULT FALSE;
	 	