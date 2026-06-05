ALTER TABLE mitarbeiter
ADD CONSTRAINT chk_vergütung_exklusiv
CHECK (
    -- Fall 1: Festgehalt (Lohn und Stunden müssen leer sein)
    (gehalt IS NOT NULL AND stundenlohn IS NULL AND wochenstunden IS NULL)
    OR 
    -- Fall 2: Stundenlohn (Gehalt muss leer sein, Lohn und Stunden müssen gefüllt sein)
    (gehalt IS NULL AND stundenlohn IS NOT NULL AND wochenstunden IS NOT NULL)
);