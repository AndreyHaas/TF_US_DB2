# Fragen zu DML, TCL und Indizes (Tag 04) - Antworten

---

## Themenbereich 1: Data Manipulation Language (DML)

### Frage 01: Erläutern Sie den grundlegenden Zweck der DML

**DML (Data Manipulation Language)** dient dem **Lesen, Einfügen, Ändern und Löschen** von Daten in einer Datenbank.

**Die vier Grundoperationen (CRUD):**

| Befehl | Operation | Deutsch |
|--------|-----------|---------|
| `SELECT` | Read | Lesen |
| `INSERT` | Create | Einfügen |
| `UPDATE` | Modify | Ändern |
| `DELETE` | Delete | Löschen |

**Zweck:** DML ermöglicht Anwendungen und Benutzern die Interaktion mit den tatsächlichen Daten in den Tabellen, ohne die Datenbankstruktur (DDL) zu verändern.

---

### Frage 02: Warum ist die WHERE-Klausel bei einem UPDATE-Befehl von kritischer Bedeutung?

**Ohne WHERE-Klausel werden ALLE Zeilen der Tabelle aktualisiert.**

**Beispiel:**

```sql
-- Gefährlich: Aktualisiert ALLE Kunden!
UPDATE kunden SET vorname = 'Hans';

-- Sicher: Aktualisiert nur den Kunden mit ID 1
UPDATE kunden SET vorname = 'Hans' WHERE id = 1;
```

**Risiken bei fehlendem WHERE:**

| Risiko | Auswirkung |
|--------|-----------|
| **Datenverlust** | Alle bestehenden Werte werden überschrieben |
| **Keine Wiederherstellung** | Ohne Backup sind die alten Werte verloren |
| **Performance** | Riesige Datenmengen werden unnötig geändert |

**Best Practice:** Vor dem `UPDATE` immer ein `SELECT` mit derselben `WHERE`-Klausel ausführen, um zu prüfen, welche Zeilen betroffen sind.

---

### Frage 03: Unterschied zwischen DELETE und Soft Delete („Geloescht“-Flag)

| Aspekt | DELETE (Hard Delete) | Soft Delete (Gelöscht-Flag) |
|--------|---------------------|----------------------------|
| **Vorgang** | Zeile wird physisch aus der Tabelle entfernt | Zeile bleibt, wird mit einem Flag markiert (z. B. `geloescht = 1`) |
| **Wiederherstellbarkeit** | Nur aus Backup möglich | Einfach durch UPDATE des Flags |
| **Speicherplatz** | Wird freigegeben | Bleibt belegt (muss ggf. manuell bereinigt werden) |
| **Historische Daten** | Verloren | Erhalten für Audits/Reporting |
| **Abfragen** | Standard-SELECT reicht | Abfragen müssen immer `WHERE geloescht = 0` beachten |
| **Performance** | DELETE kann teuer sein (Index-Updates, Logs) | UPDATE des Flags ist meist billiger |

**Soft Delete Beispiel:**

```sql
-- Soft Delete: Zeile wird nur markiert
UPDATE kunden SET geloescht = 1, geloescht_am = NOW() WHERE id = 123;

-- Aktive Kunden abfragen
SELECT * FROM kunden WHERE geloescht = 0;
```

---

### Frage 04: Wie gehen Sie vor, wenn Sie einen Datensatz einfügen möchten, aber für eine Spalte (die NULL erlaubt) keinen Wert haben?

**Möglichkeiten:**

1. **Spalte einfach weglassen** (empfohlen)

```sql
INSERT INTO mitarbeiter (name, abteilung) VALUES ('Müller', 'IT');
-- Gehalts-Spalte (NULL-able) erhält automatisch NULL
```

2. **Explizit NULL setzen**

```sql
INSERT INTO mitarbeiter (name, abteilung, gehalt) 
VALUES ('Müller', 'IT', NULL);
```

3. **DEFAULT-Wert nutzen** (wenn definiert)

```sql
-- Tabelle mit DEFAULT
CREATE TABLE mitarbeiter (
    id INT,
    name VARCHAR(100),
    gehalt DECIMAL DEFAULT 0  -- NULL nicht erlaubt
);

INSERT INTO mitarbeiter (id, name) VALUES (1, 'Müller');
-- gehalt erhält automatisch 0
```

**Wichtig:** Die Spalte muss `NULL` erlaubt haben (kein `NOT NULL` Constraint).

---

## Themenbereich 2: CHECK-Constraints

### Frage 05: Definieren Sie die Aufgabe eines CHECK-Constraints

Ein **CHECK-Constraint** stellt sicher, dass Werte in einer Spalte eine bestimmte **Bedingung erfüllen**, bevor sie eingefügt oder aktualisiert werden.

**Aufgabe:** Durchsetzung von **geschäftlichen Regeln** auf Datenbankebene.

**Beispiel:**

```sql
ALTER TABLE mitarbeiter ADD CONSTRAINT check_alter
CHECK (alter >= 16 AND alter <= 99);
```

**Vorteile:**

- Datenintegrität wird zentral erzwungen
- Keine Abhängigkeit von Anwendungslogik
- Schutz vor fehlerhaften Daten aus allen Quellen

---

### Frage 06: Nennen Sie ein praxisnahes Beispiel für einen CHECK-Constraint

**Beispiel 1: Altersprüfung**

```sql
CREATE TABLE personen (
    id INT PRIMARY KEY,
    geburtsdatum DATE,
    CONSTRAINT check_geburt CHECK (geburtsdatum <= CURRENT_DATE)
);
```

**Beispiel 2: Gehaltsspanne**

```sql
CREATE TABLE angestellte (
    id INT PRIMARY KEY,
    gehalt DECIMAL(10,2),
    CONSTRAINT check_gehalt CHECK (gehalt BETWEEN 0 AND 1000000)
);
```

**Beispiel 3: Status-Werte einschränken**

```sql
CREATE TABLE bestellungen (
    id INT PRIMARY KEY,
    status VARCHAR(20),
    CONSTRAINT check_status CHECK (status IN ('offen', 'in_bearbeitung', 'versendet', 'storniert'))
);
```

**Beispiel 4: Logische Konsistenz**

```sql
CREATE TABLE rechnungen (
    id INT PRIMARY KEY,
    rechnungsdatum DATE,
    zahlungsziel DATE,
    CONSTRAINT check_ziel_nach_datum CHECK (zahlungsziel >= rechnungsdatum)
);
```

---

### Frage 07: Was passiert technisch, wenn eine Anwendung versucht, ein Geburtsdatum in die Zukunft per UPDATE zu setzen, obwohl ein entsprechender CHECK existiert?

**Die Datenbank lehnt das UPDATE ab.**

**Ablauf:**

1. Anwendung führt `UPDATE` aus
2. Datenbank prüft den CHECK-Constraint
3. Bedingung wird `FALSE` (Geburtsdatum in Zukunft unmöglich)
4. **UPDATE wird nicht ausgeführt**
5. Datenbank wirft einen Fehler (z. B. `CHECK constraint failed`)

**Beispiel:**

```sql
CREATE TABLE personen (
    name VARCHAR(100),
    geburtsdatum DATE,
    CONSTRAINT check_geburt CHECK (geburtsdatum <= CURRENT_DATE)
);

-- Dieser UPDATE schlägt fehl:
UPDATE personen SET geburtsdatum = '2030-01-01' WHERE name = 'Müller';
-- Fehler: CHECK constraint 'check_geburt' is violated.
```

**Konsequenz:** Die Anwendung muss den Fehler abfangen und entsprechend reagieren (z. B. Fehlermeldung an Benutzer).

---

### Frage 08: Kann ein CHECK-Constraint Werte aus anderen Tabellen prüfen?

**Nein, in den meisten Datenbanksystemen (wie MySQL, PostgreSQL, DB2) kann ein CHECK-Constraint nur Werte derselben Zeile prüfen.**

**Einschränkungen:**

- Keine Unterabfragen (`SELECT` aus anderen Tabellen)
- Keine Referenzen auf andere Tabellen
- Nur konstante Ausdrücke, Spalten derselben Zeile und deterministische Funktionen

**Lösung für tabellenübergreifende Prüfungen:**

| Alternative | Beschreibung |
|-------------|--------------|
| **FOREIGN KEY** | Für referenzielle Integrität (z. B. Kunden-ID muss existieren) |
| **Trigger** | Kann komplexe, tabellenübergreifende Logik umsetzen |
| **ASSERTION** (standard SQL, selten implementiert) | Tabellenübergreifende Constraints, aber von den meisten DBMS nicht unterstützt |

**Trigger-Beispiel für tabellenübergreifende Prüfung:**

```sql
CREATE TRIGGER check_kontostand
BEFORE UPDATE ON konto
FOR EACH ROW
BEGIN
    IF NEW.kontostand < (SELECT min_kontostand FROM kontotypen WHERE id = NEW.typ_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Kontostand zu niedrig';
    END IF;
END;
```

---

## Themenbereich 3: Transaction Control Language (TCL)

### Frage 09: Erklären Sie das Konzept einer „Transaktion“

Eine **Transaktion** ist eine **logische Einheit von Datenbankoperationen**, die entweder **vollständig** oder **gar nicht** ausgeführt wird.

**Beispiel (Geldtransfer):**

```sql
BEGIN TRANSACTION;

UPDATE konto SET kontostand = kontostand - 100 WHERE konto_nr = 'A';
UPDATE konto SET kontostand = kontostand + 100 WHERE konto_nr = 'B';

COMMIT;  -- oder ROLLBACK bei Fehler
```

**ACID-Eigenschaften einer Transaktion:**

| Eigenschaft | Bedeutung |
|-------------|-----------|
| **Atomicity** | Alles oder nichts |
| **Consistency** | Datenbank bleibt in gültigem Zustand |
| **Isolation** | Parallele Transaktionen stören sich nicht |
| **Durability** | Commitierte Änderungen überdauern Abstürze |

---

### Frage 10: In welcher Situation ist ein ROLLBACK zwingend erforderlich?

Ein `ROLLBACK` ist zwingend erforderlich, wenn innerhalb einer Transaktion **ein Fehler auftritt** und die Datenbank nicht automatisch rollbackt.

**Typische Situationen:**

| Situation | Grund |
|-----------|-------|
| **Fehlerhafte Daten** | CHECK-Constraint verletzt, Datentyp-Konflikt |
| **Deadlock** | Transaktion wurde als Opfer eines Deadlocks ausgewählt |
| **Systemfehler** | Verbindungsabbruch, Timeout, Speicherproblem |
| **Geschäftslogik-Abbruch** | Anwendung erkennt eine inkonsistente Situation |
| **Bereits ausgeführte Änderungen** | Nach einer erfolgreichen Operation tritt später ein Fehler auf |

**Beispiel:**

```sql
BEGIN TRANSACTION;

UPDATE lager SET menge = menge - 10 WHERE produkt_id = 1;

-- Fehler! Kunde existiert nicht
INSERT INTO bestellungen (kunde_id, produkt_id) VALUES (99999, 1);

-- ROLLBACK ist zwingend, um die Lager-Änderung rückgängig zu machen
ROLLBACK;  -- Macht das UPDATE rückgängig
```

**Wichtig:** In den meisten Anwendungen wird `ROLLBACK` im `catch`-Block eines `try/catch` aufgerufen.

---

### Frage 11: Beschreiben Sie die Funktion eines SAVEPOINT

Ein **SAVEPOINT** setzt einen **Markierungspunkt** innerhalb einer Transaktion, zu dem man später zurückspringen (`ROLLBACK TO SAVEPOINT`) kann, ohne die gesamte Transaktion abzubrechen.

**Funktionsweise:**

```sql
BEGIN;

INSERT INTO log (nachricht) VALUES ('Start');

SAVEPOINT vor_update;

UPDATE produkt SET preis = preis * 1.1;

-- Wenn etwas schiefgeht:
ROLLBACK TO SAVEPOINT vor_update;  -- Nur UPDATE wird rückgängig

-- Weiterarbeiten
INSERT INTO log (nachricht) VALUES ('Fortgesetzt');
COMMIT;
```

**Wichtige Punkte:**

| Aspekt | Beschreibung |
|--------|-------------|
| **Verwendung** | Komplexe Transaktionen mit mehreren Schritten |
| **Rollback-Ziel** | Nur Änderungen ab dem SAVEPOINT werden rückgängig |
| **Mehrere SAVEPOINTS** | Beliebig viele möglich |
| **Freigabe** | `RELEASE SAVEPOINT name` (optional) |
| **Benennung** | Jeder SAVEPOINT braucht einen eindeutigen Namen |

---

### Frage 12: Was versteht man unter „Atomarität“ im Kontext von TCL?

**Atomarität (Atomicity)** bedeutet: Eine Transaktion wird entweder **vollständig ausgeführt** oder **gar nicht**.

**Das Prinzip "Alles oder Nichts":**

| Szenario | Ergebnis |
|----------|----------|
| Alle Operationen erfolgreich | `COMMIT` → alle Änderungen werden dauerhaft |
| Mindestens eine Operation schlägt fehl | `ROLLBACK` → keine Änderung wird wirksam |

**Beispiel:**

```sql
-- Geldtransfer: Zwei Operationen müssen beide oder keine erfolgreich sein
UPDATE konto SET saldo = saldo - 500 WHERE nr = 123;  -- Abbuchung
UPDATE konto SET saldo = saldo + 500 WHERE nr = 456;  -- Gutschrift
-- Wenn die zweite Operation fehlschlägt, macht die erste keinen Sinn
```

**Merkbild:** Eine Transaktion verhält sich wie ein einzelner Befehl – der Benutzer sieht nur den Endzustand, nie einen Zwischenzustand.

---

### Frage 13: Erklären Sie den Begriff „Dirty Read“

Ein **Dirty Read** liegt vor, wenn eine Transaktion Daten liest, die von einer **anderen, noch nicht commitierten Transaktion** geschrieben wurden.

**Problem:**

```
Zeit  | Transaktion A                 | Transaktion B
------|-------------------------------|-------------------------------
t1    | BEGIN;                        |
t2    | UPDATE konto SET saldo = 0;   |
t3    |                               | SELECT saldo FROM konto; -- liest 0
t4    | ROLLBACK; (saldo wieder alt)  |
```

Transaktion B hat einen **Wert gelesen, der nie wirklich existiert hat** (weil A zurückgesetzt wurde).

**Lösung:** Höhere Isolationsebene (`READ COMMITTED` oder höher)

| Isolation Level | Dirty Reads möglich? |
|-----------------|----------------------|
| READ UNCOMMITTED | ✅ Ja |
| READ COMMITTED | ❌ Nein |
| REPEATABLE READ | ❌ Nein |
| SERIALIZABLE | ❌ Nein |

---

### Frage 14: Was ist ein „implizites Commit“?

Ein **implizites Commit** ist ein automatischer `COMMIT`, der ausgeführt wird, ohne dass der Benutzer explizit `COMMIT` aufruft.

**Auslöser für implizite Commits:**

| Kategorie | Beispiele |
|-----------|-----------|
| **DDL-Befehle** | `CREATE`, `ALTER`, `DROP`, `TRUNCATE`, `RENAME` |
| **Verbindungsende** | Normales Trennen der Verbindung |
| **Start einer neuen Transaktion** | `BEGIN` startet automatisch eine neue Transaktion |
| **Bestimmte Administrative Befehle** | `ANALYZE`, `VACUUM` (PostgreSQL), `OPTIMIZE TABLE` (MySQL) |

**Beispiel (gefährlich):**

```sql
BEGIN;
UPDATE konten SET saldo = saldo - 500 WHERE id = 1;
CREATE TABLE temp (id INT);  -- Impliziter COMMIT!
-- Jetzt ist das UPDATE dauerhaft, ROLLBACK geht nicht mehr!
```

**Wichtig:** In Transaktionen niemals DDL-Befehle ausführen, wenn die Möglichkeit eines Rollbacks erhalten bleiben soll.

---

### Frage 15: Wie wird ein „Deadlock“ durch das Datenbankmanagement gelöst?

Ein **Deadlock** entsteht, wenn zwei Transaktionen gegenseitig auf Ressourcen warten, die die jeweils andere Transaktion hält.

**Beispiel:**

```
Transaktion A: hat Lock auf Tabelle X, will Lock auf Tabelle Y
Transaktion B: hat Lock auf Tabelle Y, will Lock auf Tabelle X
→ Keine kommt weiter
```

**Lösung durch DBMS:**

| Schritt | Beschreibung |
|---------|--------------|
| 1. **Erkennung** | Das DBMS führt einen **Deadlock-Detection-Algorithmus** durch (meist Wait-for-Graph) |
| 2. **Auswahl eines Opfers** | Die Transaktion wird ausgewählt, die am wenigsten "teuer" ist (weniger Änderungen, jünger) |
| 3. **Abbruch des Opfers** | Die ausgewählte Transaktion wird mit `ROLLBACK` abgebrochen |
| 4. **Freigabe der Locks** | Alle Locks der abgebrochenen Transaktion werden freigegeben |
| 5. **Fehlermeldung** | Die abgebrochene Anwendung erhält einen Deadlock-Fehler |

**Beispiel-Fehlermeldung (MySQL):**

```
ERROR 1213 (40001): Deadlock found when trying to get lock; 
try restarting transaction
```

**Aufgabe der Anwendung:** Die abgebrochene Transaktion sollte automatisch **wiederholt** werden.

---

## Themenbereich 4: Indizes & B-Tree

### Frage 16: Erklären Sie die Struktur eines B-Tree-Index

Ein **B-Tree** (Balanced Tree) ist eine **balancierte Baumstruktur**, die für schnelle Suchen, Einfügungen und Löschungen optimiert ist.

**Struktur:**

```
                    [50]                    ← Wurzelknoten (Root)
                   /    \
            [20, 40]     [60, 80]           ← Interne Knoten (Innere Knoten)
            /   |   \     /   |   \
        [10] [30] [45] [55] [70] [90]       ← Blattknoten (Leaf Nodes) 
          ↓    ↓    ↓    ↓    ↓    ↓
       (Datenzeiger) → (Datenzeiger)
```

**Eigenschaften des B-Tree:**

| Eigenschaft | Beschreibung |
|-------------|--------------|
| **Balanced** | Alle Blätter haben denselben Abstand zur Wurzel |
| **Mehrweg-Suche** | Jeder Knoten enthält mehrere Werte (nicht nur einen) |
| **Sortiert** | Werte in jedem Knoten sind aufsteigend sortiert |
| **Dynamisch** | Wächst und schrumpft automatisch |
| **Seiten (Blöcke)** | Knoten entsprechen Datenbank-Seiten (typ. 4-16 KB) |

**Füllgrad:** Normalerweise 50-100% pro Knoten (je nach Implementierung).

---

### Frage 17: Warum führt ein Index zu einer schnelleren Suche?

Ein Index reduziert die **Anzahl der Leseoperationen** von O(n) (linearer Scan) auf **O(log n)** (logarithmisch).

**Vergleich:**

| Suche in 1.000.000 Zeilen | Full Table Scan | B-Tree Index |
|---------------------------|----------------|--------------|
| Leseoperationen | 1.000.000 | ca. 20 |
| I/O-Zugriffe | 1.000.000 | ca. 3-4 |
| Zeit (geschätzt) | 1 Sekunde | 1 Millisekunde |

**Warum ist der B-Tree so schnell?**

1. **Logarithmische Tiefe:** Bei 1 Mio Zeilen ist der Baum nur ca. 20 Knoten tief (log₂ 1.000.000 ≈ 20)
2. **Mehrere Werte pro Knoten:** Reduziert die Höhe des Baumes
3. **Sortierte Struktur:** Ermöglicht `BETWEEN`, `>` und `<` effizient
4. **Datenbank-Seiten:** Mehrere Werte passen auf eine Festplattenseite → weniger I/O

**Beispiel für Index-Nutzung:**

```sql
-- Kein Index: 1.000.000 Vergleiche
SELECT * FROM kunden WHERE nachname = 'Schmidt';

-- Mit Index: Nur ca. 20 Vergleiche
CREATE INDEX idx_nachname ON kunden(nachname);
SELECT * FROM kunden WHERE nachname = 'Schmidt';
```

---

### Frage 18: Was versteht man unter einem „Clustered Index“?

Ein **Clustered Index** bestimmt die **physische Sortierung der Daten** in der Tabelle.

**Wichtige Eigenschaften:**

| Eigenschaft | Clustered Index | Non-Clustered Index |
|-------------|-----------------|---------------------|
| **Anzahl pro Tabelle** | Maximal 1 | Beliebig viele |
| **Datenanordnung** | Daten sind nach Index sortiert | Index enthält Verweise auf Daten |
| **Zugriffsgeschwindigkeit** | Sehr schnell für Bereichsabfragen | Zusätzlicher Lookup nötig |
| **Einfügegeschwindigkeit** | Langsamer (muss Daten umsortieren) | Schneller |

**Visualisierung:**

```
Clustered Index (z. B. nach ID):
[ID=1] [ID=2] [ID=3] [ID=4] [ID=5] ...  ← Daten physisch sortiert

Non-Clustered Index (z. B. nach Name):
Index: [Meier → ID 3] [Müller → ID 1] [Schmidt → ID 5]
Daten: [ID=1] [ID=2] [ID=3] [ID=4] [ID=5] ... (unsortiert)
```

**In MySQL:**
- Ein `PRIMARY KEY` erstellt automatisch einen **Clustered Index**
- InnoDB verwendet den Primärschlüssel als Clustered Index

**In DB2:**
- `CREATE INDEX ... CLUSTER` erzeugt einen Clustered Index

---

### Frage 19: Wann entscheidet sich der Query Optimizer gegen die Nutzung eines vorhandenen Index?

Der **Query Optimizer** ist ein intelligenter Teil des DBMS, der für jede Abfrage den schnellsten Ausführungsplan wählt.

**Gründe gegen Index-Nutzung:**

| Grund | Erklärung | Beispiel |
|-------|-----------|----------|
| **Niedrige Selektivität** | Index würde mehr als 20-30% der Tabelle liefern | `WHERE geschlecht = 'M'` (50% der Zeilen) |
| **Kleine Tabelle** | Full Table Scan ist billiger als Index + Lookup | Tabelle mit < 100 Zeilen |
| **LIKE mit führendem Wildcard** | `LIKE '%text'` kann Index nicht nutzen | `WHERE name LIKE '%mann'` |
| **Funktion auf Spalte** | `WHERE UPPER(name) = 'SCHMIDT'` kann Index nicht nutzen | Funktion verändert Wert |
| **Typkonvertierung** | Index wird nicht genutzt bei Typ-Mismatch | `WHERE id = '123'` (id ist INT) |
| **OR-Verknüpfungen** | Komplexe `OR`-Bedingungen manchmal problematisch | `WHERE a=1 OR b=2` |

**Beispiel für Entscheidung gegen Index:**

```sql
-- Tabelle: 1.000.000 Zeilen
-- Index auf 'status' (Werte: 'aktiv', 'inaktiv', 'gelöscht')
-- Wenn 400.000 Zeilen 'aktiv' sind → Query Optimizer nutzt Full Table Scan
SELECT * FROM benutzer WHERE status = 'aktiv';
```

---

### Frage 20: Erklären Sie den Begriff „Index-Selektivität“

Die **Selektivität** eines Index gibt an, wie **eindeutig** die Werte einer Spalte sind.

**Berechnung:**

```
Selektivität = Anzahl unterschiedlicher Werte / Gesamtanzahl Zeilen

Beispiel:
100.000 Zeilen, 95.000 unterschiedliche Nachnamen
Selektivität = 95.000 / 100.000 = 0,95 = 95% (sehr gut)

100.000 Zeilen, 2 unterschiedliche Geschlechter
Selektivität = 2 / 100.000 = 0,00002 = 0,002% (sehr schlecht)
```

**Bewertung:**

| Selektivität | Qualität | Beispiel | Index sinnvoll? |
|--------------|----------|----------|-----------------|
| > 90% | Ausgezeichnet | E-Mail, Personalnummer | ✅ Sehr gut |
| 50% - 90% | Gut | Nachname (in DE) | ✅ Gut |
| 10% - 50% | Mittel | PLZ, Geburtsjahr | ⚠️ Eventuell |
| < 10% | Schlecht | Geschlecht, Status (mit wenigen Werten) | ❌ Meist nicht |

**Warum ist hohe Selektivität wichtig?**

- Index mit hoher Selektivität schränkt die Ergebnismenge **stark ein**
- Geringe Selektivität führt zu vielen Treffern → Datenbank wählt oft Full Table Scan

**Zusammengesetzter Index** kann Selektivität verbessern:

```sql
-- Schlecht: geschlecht (Selektivität ~0,001%)
-- Besser: geschlecht + nachname + vorname
CREATE INDEX idx_person ON personen(geschlecht, nachname, vorname);
```

---

## Themenbereich 5: O-Notation (Komplexität)

### Frage 21: Was misst die O-Notation in der Informatik?

Die **O-Notation** (Landau-Notation) misst das **Wachstumsverhalten** eines Algorithmus in Abhängigkeit der **Inputgröße n**.

**Gemessen wird:**

| Aspekt | Beschreibung |
|--------|--------------|
| **Zeitkomplexität** | Wie die Laufzeit mit n wächst |
| **Platzkomplexität** | Wie der Speicherbedarf mit n wächst |

**Wichtig:** Die O-Notation interessiert sich für das **asymptotische Verhalten** (für große n). Konstante Faktoren und niedrigere Terme werden ignoriert.

**Beispiel:**

```
Algorithmus braucht: 3n² + 5n + 100 Operationen
→ O(n²)
```

**Typische Komplexitätsklassen (schnell → langsam):**

| Klasse | Name | Beispiel | n=1000 | n=1.000.000 |
|--------|------|----------|--------|-------------|
| O(1) | Konstant | Array-Zugriff | 1 | 1 |
| O(log n) | Logarithmisch | Binäre Suche | ~10 | ~20 |
| O(n) | Linear | Full Table Scan | 1000 | 1.000.000 |
| O(n log n) | Log-linear | Sortieren | ~7.000 | ~20.000.000 |
| O(n²) | Quadratisch | Verschachtelte Schleifen | 1.000.000 | 10¹² |
| O(2ⁿ) | Exponentiell | Brute-Force | astronomisch | unmöglich |

---

### Frage 22: Beschreiben Sie das Verhalten von O(n)

**O(n)** (lineare Komplexität) bedeutet: Die Laufzeit wächst **direkt proportional** zur Eingabegröße n.

**Verhalten:**

| n | Relative Laufzeit |
|---|------------------|
| 10 | 10 |
| 100 | 100 |
| 1.000 | 1.000 |
| 1.000.000 | 1.000.000 |

**Beispiele für O(n) in Datenbanken:**

| Operation | Warum O(n)? |
|-----------|-------------|
| **Full Table Scan** | Jede Zeile muss genau einmal gelesen werden |
| `SELECT * FROM tabelle` | Alle n Zeilen durchlaufen |
| `DELETE` ohne Index | Jede Zeile auf Bedingung prüfen |
| **Sequentielles Lesen** | Cache: n Operationen (Festplatte: n Seeks) |

**Visualisierung:**

```
Laufzeit
   ↑
   |                                    /
   |                                  /
   |                               /
   |                            /
   |                         /
   |                      /
   |                   /
   |                /
   |             /
   |          /
   |       /
   |    /
   | /
   +--------------------------------→ n
```

**Fazit:** O(n) ist für große Datenmengen akzeptabel, wenn n nicht zu groß wird. Für Millionen Zeilen wird es jedoch spürbar langsam.

---

### Frage 23: Warum ist O(log n) besser als O(n)?

**O(log n)** wächst viel **langsamer** als O(n). Bereits bei moderaten n ist der Unterschied riesig.

**Vergleich (zur Basis 2):**

| n | O(log₂ n) | O(n) | Faktor |
|---|-----------|------|--------|
| 10 | ~3 | 10 | 3x |
| 100 | ~7 | 100 | 14x |
| 1.000 | ~10 | 1.000 | 100x |
| 1.000.000 | ~20 | 1.000.000 | 50.000x |
| 1.000.000.000 | ~30 | 1.000.000.000 | 33.000.000x |

**Bedeutung für Datenbanken:**

| Suche in 1 Mio Zeilen | O(n) Full Scan | O(log n) Index | Verbesserung |
|----------------------|----------------|----------------|--------------|
| Vergleiche | 1.000.000 | ~20 | 50.000x |
| I/O-Zugriffe (Festplatte) | 1.000.000 | ~3-4 | 300.000x |

**Praktisches Beispiel:**

```sql
-- Full Table Scan: O(n) → 1 Sekunde bei 1 Mio Zeilen
SELECT * FROM kunden WHERE name = 'Müller';

-- Mit B-Tree-Index: O(log n) → 0,02 Millisekunden
CREATE INDEX idx_name ON kunden(name);
SELECT * FROM kunden WHERE name = 'Müller';
```

**Fazit:** O(log n) skaliert hervorragend mit großen Datenmengen. Verdoppelt sich n, steigt der Aufwand nur um eine konstante Zahl (z. B. von 20 auf 21 Vergleiche).

---

### Frage 24: Welche Komplexität hat der Zugriff auf einen Datensatz über den Primärschlüssel in einer idealen Hash-Struktur?

**O(1)** – konstante Zeit (ideale Hash-Struktur).

**Erklärung:**

| Struktur | Komplexität | Begründung |
|----------|-------------|------------|
| **Ideale Hash-Struktur** | O(1) | Direkte Berechnung der Speicheradresse |
| **B-Tree** | O(log n) | Baumdurchlauf mit log n Vergleichen |
| **Unsortiertes Array** | O(n) | Linearer Scan |

**Wie funktioniert O(1) mit Hash?**

```sql
-- Annahme: Hash-Index auf Primärschlüssel
SELECT * FROM kunden WHERE id = 12345;
```

1. Hash-Funktion berechnet aus `12345` eine Adresse: `h = hash(12345)`
2. Direkter Zugriff auf diese Adresse
3. Unabhängig von der Gesamtzahl der Zeilen

**Einschränkungen der O(1)-Hash-Struktur:**

| Einschränkung | Erklärung |
|--------------|-----------|
| **Keine Bereichssuche** | `WHERE id BETWEEN 1 AND 100` geht nicht effizient |
| **Hash-Kollisionen** | Mehrere Werte auf gleiche Adresse → minimal schlechter |
| **Nur Gleichheit** | Nur `=`-Vergleiche, nicht `>`, `<`, `BETWEEN` |
| **Nicht sortiert** | Keine `ORDER BY` über Hash-Index möglich |

**In der Praxis:** Die meisten Datenbanken (MySQL, PostgreSQL) verwenden **B-Tree als Standard**, bieten aber auch Hash-Index für spezielle Anwendungsfälle.

---

### Frage 25: Warum entspricht ein Full Table Scan der Komplexität O(n)?

Ein **Full Table Scan** muss **jede einzelne Zeile** der Tabelle lesen und prüfen.

**Ablauf:**

```
Tabelle mit n Zeilen:
┌─────┬──────────┐
│ Row │ WHERE?   │
├─────┼──────────┤
│ 1   │ prüfen   │ ← 1. Operation
│ 2   │ prüfen   │ ← 2. Operation
│ 3   │ prüfen   │ ← 3. Operation
│ ... │ ...      │
│ n   │ prüfen   │ ← n. Operation
└─────┴──────────┘
```

**Anzahl der Operationen = n**

| n | Operationen |
|---|-------------|
| 10 | 10 |
| 1.000 | 1.000 |
| 1.000.000 | 1.000.000 |

**Mathematisch:**

```
T(n) = a·n + b
```

- a = Zeit pro Zeile (prüfen, ob Bedingung zutrifft)
- b = konstante Initialisierung

In der O-Notation: **O(n)**

**Beispiel in SQL:**

```sql
-- Kein Index → Full Table Scan (O(n))
SELECT * FROM artikel WHERE preis > 100;

-- Die Datenbank muss ALLE Zeilen lesen, selbst wenn der Preis
-- in den ersten 10 Zeilen nie > 100 ist.
```

**Ausnahme (extrem kleine Tabellen):**

Bei sehr kleinen Tabellen (n < 100) kann ein Full Table Scan **trotz O(n)** performant sein, da der Index-Overhead größer wäre.

---

### Frage 26: Warum sollte man O(n²) in produktiven Datenbankabfragen vermeiden?

**O(n²) (quadratische Komplexität)** wächst so schnell, dass schon bei moderaten Datenmengen die Performance **inakzeptabel** wird.

**Wachstum im Vergleich:**

| n | O(n) | O(n log n) | O(n²) | Unterschied O(n) vs O(n²) |
|---|------|------------|-------|---------------------------|
| 100 | 100 | 660 | 10.000 | 100x langsamer |
| 1.000 | 1.000 | 10.000 | 1.000.000 | 1.000x langsamer |
| 10.000 | 10.000 | 130.000 | 100.000.000 | 10.000x langsamer |
| 1.000.000 | 1.000.000 | 20.000.000 | 1.000.000.000.000 | 1.000.000x langsamer |

**Wo tritt O(n²) in Datenbanken auf?**

| Ursache | Beispiel | Problem |
|---------|----------|---------|
| **Kartesisches Produkt** (CROSS JOIN) | `FROM a, b` (keine JOIN-Bedingung) | n*m Kombinationen |
| **Nested Loop Join** ohne Index | Zwei große Tabellen | n * m Vergleiche |
| **Ineffiziente Subqueries** | Korrelierte Subquery für jede Zeile | n² |
| **Schlechte Gruppierung** | `GROUP BY` ohne Index auf großen Strings | n log n (sort) + n |

**Beispiel für O(n²):**

```sql
-- Kartesisches Produkt (CROSS JOIN)
-- Tabelle A: 10.000 Zeilen
-- Tabelle B: 10.000 Zeilen
-- Ergebnis: 100.000.000 Zeilen (10.000 * 10