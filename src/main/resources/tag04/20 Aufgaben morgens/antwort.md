# SQL & Performance-Fragen - Antworten

## Frage 01: Daten aus „Produkte“ in „Produkte_Alt“ kopieren

**Syntax (Standard SQL):**

```sql
INSERT INTO Produkte_Alt
SELECT * FROM Produkte;
```

**Wenn nur bestimmte Spalten kopiert werden sollen:**

```sql
INSERT INTO Produkte_Alt (id, name, preis, erstellt_am)
SELECT id, name, preis, erstellt_am
FROM Produkte;
```

**Mit Bedingung:**

```sql
INSERT INTO Produkte_Alt
SELECT * FROM Produkte
WHERE erstellt_am < '2024-01-01';
```

**Voraussetzung:** Die Tabelle `Produkte_Alt` muss bereits existieren und die Spaltenstruktur muss mit dem `SELECT` kompatibel sein.

**Alternative (Tabelle neu erstellen + kopieren):**

```sql
CREATE TABLE Produkte_Alt AS
SELECT * FROM Produkte;
```

---

## Frage 02: Risiko eines Full Table Scans bei großen DELETE-Operationen

Ein **Full Table Scan** bedeutet, dass die Datenbank die gesamte Tabelle durchliest, um die zu löschenden Zeilen zu finden.

**Risiken:**

| Risiko | Erklärung |
|--------|-----------|
| **Lange Ausführungszeit** | Die Datenbank muss jede Zeile prüfen – bei Millionen Zeilen dauert das extrem lange |
| **Tabellensperrung** | Viele Datenbanken sperren die gesamte Tabelle während des Löschens → andere Anwendungen können nicht zugreifen |
| **Transaktionslog-Explosion** | Jede gelöschte Zeile wird im Redo-/Undo-Log protokolliert. Bei 1 Mio Zeilen kann das Log mehrere GB groß werden |
| **Timeout-Risiko** | Bei langen Operationen können Timeouts auftreten oder Verbindungen abbrechen |
| **Hohe Last** | CPU, I/O und Arbeitsspeicher werden stark belastet |

**Bessere Alternative:** Löschen in Batches (z. B. `LIMIT 10000` in einer Schleife) oder Partitionierung + `DROP PARTITION`.

---

## Frage 03: Was bewirkt der Befehl COMMIT?

**COMMIT** macht alle Änderungen der aktuellen Transaktion **dauerhaft und für andere sichtbar**.

**Effekte:**

- Änderungen werden **fest in die Datenbank geschrieben**
- Andere Transaktionen sehen die Änderungen (je nach Isolation Level)
- Die Transaktion wird **beendet**
- **Sperren** (Locks) werden freigegeben
- Die Änderungen überleben einen **Stromausfall / Neustart**

**Beispiel:**

```sql
BEGIN;
UPDATE Produkte SET preis = 19.99 WHERE id = 1;
COMMIT;  -- Jetzt ist die Änderung endgültig
```

**Gegenteil:** `ROLLBACK` macht alle Änderungen der Transaktion rückgängig.

---

## Frage 04: Warum ist „Isolation“ bei gleichzeitigem Zugriff wichtig?

**Isolation** verhindert Anomalien, wenn mehrere Transaktionen gleichzeitig auf dieselben Daten zugreifen.

**Ohne Isolation können folgende Probleme auftreten:**

| Problem | Erklärung | Beispiel |
|---------|-----------|----------|
| **Dirty Read** | Eine Transaktion liest nicht-commitierte Daten einer anderen | T1 ändert Preis, T2 liest neuen Preis, T1 macht ROLLBACK → T2 hat falschen Wert |
| **Non-Repeatable Read** | Zwei Lesevorgänge in derselben Transaktion liefern unterschiedliche Ergebnisse | T1 liest Preis (10€), T2 ändert auf 20€, T1 liest erneut (20€) → inkonsistent |
| **Phantom Read** | Neue Zeilen erscheinen zwischen zwei Lesevorgängen | T1 zählt Produkte (5 Stück), T2 fügt neues Produkt ein, T1 zählt erneut (6 Stück) |

**Lösung:** Die Datenbank bietet verschiedene **Isolation Levels** (READ UNCOMMITTED, READ COMMITTED, REPEATABLE READ, SERIALIZABLE). Höhere Isolation = mehr Schutz, aber weniger Parallelität.

---

## Frage 05: Warum sollte man Transaktionen so kurz wie möglich halten?

**Gründe für kurze Transaktionen:**

| Grund | Erklärung |
|-------|-----------|
| **Weniger Sperren (Locks)** | Lange Transaktionen halten Sperren über lange Zeit → andere müssen warten |
| **Geringeres Deadlock-Risiko** | Je länger eine Transaktion läuft, desto höher die Wahrscheinlichkeit eines Deadlocks mit anderen Transaktionen |
| **Kleinere Transaktionslogs** | Lange Transaktionen erzeugen große Log-Mengen, die viel Speicher und I/O verbrauchen |
| **Bessere Parallelität** | Kurze Transaktionen geben Sperren schnell frei → andere können arbeiten |
| **Schnellere Fehlerbehandlung** | Bei einem Fehler ist nur wenig Arbeit rückgängig zu machen |
| **Geringere Timeout-Gefahr** | Vermeidet Zeitüberschreitungen bei Verbindungen |

**Best Practice:** Benutzereingaben nicht innerhalb einer Transaktion erwarten. Transaktionen nur für die tatsächlichen Datenbankoperationen verwenden.

**Beispiel (schlecht):**

```sql
BEGIN;
-- ... hier wartet die DB auf Benutzereingabe (schlecht!) ...
UPDATE ...;
COMMIT;
```

**Beispiel (gut):**

```sql
-- Benutzereingabe abfragen (außerhalb der Transaktion)
$name = $_POST['name'];

BEGIN;
UPDATE ... WHERE id = $name;
COMMIT;
```

---

## Frage 06: Nachteil vieler Indizes bei häufigen INSERT-Operationen

**Jeder Index muss bei jedem INSERT aktualisiert werden.**

**Das Problem im Detail:**

| Aktion | Ohne Index | Mit 3 Indizes | Mit 10 Indizes |
|--------|-----------|---------------|----------------|
| **INSERT** | 1 Schreibvorgang | 4 Schreibvorgänge | 11 Schreibvorgänge |
| **UPDATE** (indizierte Spalten) | 1-2 Schreibvorgänge | 3-4 Schreibvorgänge | 10+ Schreibvorgänge |
| **DELETE** | 1 Schreibvorgang | 3 Schreibvorgänge | 10+ Schreibvorgänge |

**Konkrete Nachteile:**

- **Langsame Schreiboperationen** – jede Einfügung muss alle Indizes durchlaufen und aktualisieren
- **Mehr Speicherplatz** – Indizes können größer sein als die Tabelle selbst
- **Höhere I/O-Last** – mehr Schreibvorgänge auf die Festplatte
- **Pufferpool-Verdrängung** – Index-Seiten belegen den Cache, der für Daten fehlt

**Faustregel:** Wenige, gezielte Indizes sind besser als viele Indizes "für alle Fälle". Bei Tabellen mit sehr vielen Schreiboperationen (Logging, Messdaten) Indizes minimieren.

---

## Frage 07: Spalte „type: ALL“ in einer EXPLAIN-Ausgabe

**`type: ALL`** bedeutet: **Full Table Scan** – die Datenbank liest die **gesamte Tabelle** Zeile für Zeile.

**Was das aussagt:**

| Aspekt | Bedeutung |
|--------|-----------|
| **Kein Index genutzt** | Es wurde kein (brauchbarer) Index gefunden |
| **Langsam bei großen Tabellen** | Die Abfrage wird mit jeder zusätzlichen Zeile langsamer: O(n) |
| **Teuer** | CPU, I/O und Speicher werden stark belastet |

**Beispiel (schlecht):**

```sql
EXPLAIN SELECT * FROM produkte WHERE name = 'Laptop';
-- type: ALL  (kein Index auf 'name')
```

**Beispiel (gut – nach Index-Erstellung):**

```sql
CREATE INDEX idx_name ON produkte(name);
EXPLAIN SELECT * FROM produkte WHERE name = 'Laptop';
-- type: ref oder range  (Index wird genutzt)
```

**Ausnahme:** Bei sehr kleinen Tabellen (z. B. < 100 Zeilen) ist `ALL` akzeptabel, da ein Index mehr Overhead als Nutzen hätte.

---

## Frage 08: Warum ist ein Index auf „Anrede“ (Herr/Frau) meist wirkungslos?

Ein Index ist nur dann effektiv, wenn er die Ergebnismenge **stark einschränkt**. Die Spalte "Anrede" hat eine sehr **niedrige Kardinalität**.

**Kardinalität = Anzahl der unterschiedlichen Werte**

| Spalte | Unterschiedliche Werte | Selektivität |
|--------|----------------------|--------------|
| Anrede | 2–3 (Herr, Frau, Divers) | Sehr niedrig (~0,001%) |
| PLZ | ~8.000 in Deutschland | Mittel (~5%) |
| E-Mail-Adresse | Millionen | Sehr hoch (~100%) |

**Das Problem:**

- Ein Index auf "Anrede" teilt die Tabelle nur in **2-3 Blöcke** auf
- Bei `WHERE anrede = 'Herr'` wählt die Datenbank trotzdem **~50% der gesamten Tabelle** aus
- Die Datenbank entscheidet sich dann oft für einen **Full Table Scan**, weil das schneller ist als Index + viele zufällige Lesevorgänge

**Wann ein Index auf "Anrede" doch nützlich sein kann:**

- Wenn die Tabelle extrem groß ist (Milliarden Zeilen) und `anrede = 'divers'` nur 0,001% betrifft
- Als Teil eines **zusammengesetzten Indexes** (z. B. `(anrede, nachname, plz)`)

---

## Frage 09: Wie löscht man 1 Million alte Log-Einträge am performantesten?

**Die Antwort hängt davon ab, ob die gesamte Tabelle geleert werden soll oder nur alte Einträge.**

### Fall A: Die gesamte Tabelle soll geleert werden (alle Zeilen)

❌ **Schlecht:**

```sql
DELETE FROM log;
-- Dauert extrem lange, erzeugt riesiges Log, sperrt die Tabelle
```

✅ **Besser (TRUNCATE):**

```sql
TRUNCATE TABLE log;
```

**Warum TRUNCATE schneller ist:**
- Ist ein **DDL-Befehl** (kein DML)
- Erzeugt fast keine Log-Einträge
- Gibt Speicherplatz sofort frei
- Ist atomar und extrem schnell (Millisekunden vs. Minuten/Stunden)

**Nachteile von TRUNCATE:**
- Kann nicht rückgängig gemacht werden (kein ROLLBACK möglich)
- Löscht wirklich **alle** Zeilen (keine WHERE-Bedingung)

---

### Fall B: Nur alte Einträge sollen gelöscht werden (z. B. älter als 1 Jahr)

❌ **Schlecht:**

```sql
DELETE FROM log WHERE erstellt_am < '2024-01-01';
-- 1 Mio Zeilen in einer einzigen Transaktion → Log-Explosion, lange Sperre
```

✅ **Besser: Löschen in Batches (Chunking):**

```sql
-- In einer Schleife (z. B. in einer Stored Procedure oder im Anwendungscode)
DELETE FROM log 
WHERE erstellt_am < '2024-01-01' 
LIMIT 10000;
COMMIT;
-- Wiederholen, bis keine Zeilen mehr gelöscht werden
```

**Warum Batches besser sind:**
- Kleine Transaktionen → kleines Transaktionslog
- Kurze Sperren → andere Anwendungen können parallel arbeiten
- Bei Abbruch ist nicht alles verloren

---

**Ultimative Lösung für Log-Tabellen: Tabellen-Partitionierung**

```sql
-- Monatliche Partitionen erstellen
CREATE TABLE log (
    id INT,
    erstellt_am DATE,
    nachricht TEXT
) PARTITION BY RANGE (YEAR(erstellt_am)) (
    PARTITION p2023 VALUES LESS THAN (2024),
    PARTITION p2024 VALUES LESS THAN (2025),
    PARTITION p2025 VALUES LESS THAN (2026)
);

-- Alte Partition löschen (Millisekunden!)
ALTER TABLE log DROP PARTITION p2023;
```

---

## Frage 10: Begriff „Range Scan“ bei einem Index

Ein **Range Scan** bedeutet, dass die Datenbank einen Index verwendet, um einen **Bereich von Werten** zu lesen (z. B. alle Preise zwischen 10€ und 50€).

**Visualisierung (B+Tree-Index):**

```
        [30]
       /    \
    [10-20]  [40-50]
    /   |     |    \
  10   15    40    50
 (Wert) (Wert) (Wert) (Wert)
```

Die Datenbank navigiert zum **Startpunkt** des Bereichs und liest dann **sequentiell** bis zum Endpunkt.

**Beispiel:**

```sql
SELECT * FROM produkte 
WHERE preis BETWEEN 10 AND 50;
-- type: range (wenn Index auf preis existiert)
```

**Wann Range Scan stattfindet:**

| Operator | Beispiel | 
|----------|----------|
| `BETWEEN` | `preis BETWEEN 10 AND 50` |
| `>` / `>=` | `preis > 100` |
| `<` / `<=` | `preis <= 50` |
| `LIKE 'abc%'` | `name LIKE 'Müller%'` |
| `IN (...)` mit wenigen Werten | `id IN (1,2,3,4,5)` |

**Vorteile von Range Scan:**

- Viel schneller als Full Table Scan (O(log n + Anzahl Treffer) vs O(n))
- Besonders effektiv, wenn der Bereich klein ist
- Nutzt die sortierte Natur von B+Trees

**Wann Range Scan ineffizient wird:**

- Wenn der Bereich **sehr groß** ist (z. B. 80% der Tabelle)
- Die Datenbank könnte dann einen Full Table Scan bevorzugen

---

## Zusammenfassung der wichtigsten Konzepte

| Konzept | Kurzdefinition |
|---------|----------------|
| **Full Table Scan (ALL)** | Ganze Tabelle wird gelesen – langsam bei großen Tabellen |
| **Range Scan** | Index wird für Bereichsabfragen genutzt – effizient |
| **COMMIT** | Macht Transaktionsänderungen dauerhaft |
| **Isolation** | Schützt vor Dirty Reads, Non-Repeatable Reads, Phantom Reads |
| **Kardinalität** | Anzahl unterschiedlicher Werte – niedrige Kardinalität = schlecht für Index |
