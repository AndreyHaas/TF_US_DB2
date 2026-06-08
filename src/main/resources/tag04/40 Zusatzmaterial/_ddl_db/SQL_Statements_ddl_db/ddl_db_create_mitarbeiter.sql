CREATE TABLE IF NOT EXISTS mitarbeiter (
    -- 1. Identifikation
    id                  INT PRIMARY KEY AUTO_INCREMENT,
    mitarbeiter_nummer  VARCHAR(20) UNIQUE NOT NULL,

    -- 2. Stammdaten
    vorname             VARCHAR(50) NOT NULL,
    nachname            VARCHAR(50) NOT NULL,
    abteilung           VARCHAR(50) NOT NULL,

    -- 3. Hierarchie
    vorgesetzter_id     INT,
    CONSTRAINT fk_vorgesetzter 
        FOREIGN KEY (vorgesetzter_id) REFERENCES mitarbeiter(id),

    -- 4. Zeitraum & Vergütung
    eintritts_datum     DATE NOT NULL,
    austritts_datum     DATE DEFAULT NULL,
    gehalt              DECIMAL(12, 2),
    stundenlohn         DECIMAL(10, 2),
    wochenstunden       INT,

    -- 5. Besondere Datentypen
    -- ENUM für Geschlecht: Genau eine Auswahl aus 'm', 'w', 'd'
    geschlecht          ENUM('m', 'w', 'd') NOT NULL,
    
    -- SET für Interessen: Erlaubt Mehrfachauswahl aus der vorgegebenen Liste
    interessen          SET(
        'Gartenarbeit', 'Sport & Fitness', 'Lesen', 'Fotografieren', 
        'Kochen & Bakken', 'Reisen', 'Gaming', 'Musik'
    ),

    -- 6. Technische Details
    INDEX (nachname) -- Kleiner Bonus für die Performance bei der Suche
) 
ENGINE=InnoDB 
DEFAULT CHARSET=utf8mb4 
COLLATE=utf8mb4_unicode_ci;