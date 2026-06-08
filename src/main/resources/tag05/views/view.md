# VIEW vs. SELECT in SQL – Unterschiede einfach erklärt

## 1. Kurze Definition

- **`SELECT`** – ein **einmaliger Befehl** zum Abfragen von Daten (keine dauerhafte Speicherung in der Datenbank).
- **`VIEW`** – ein **dauerhaft gespeichertes Abfrageobjekt**, das wie eine virtuelle Tabelle funktioniert.

> **Merke:** Eine `VIEW` **enthält** einen `SELECT`, ist aber mehr als das.

---

## 2. `SELECT` – die einmalige Abfrage

Ein `SELECT` ist der Standardbefehl, um Daten aus Tabellen oder Views zu lesen. Er existiert **nur zur Ausführungszeit**.

```sql
SELECT vorname, nachname, SUM(betrag) AS gesamt
FROM kunden
JOIN bestellungen ON kunden.id = bestellungen.kunden_id
GROUP BY vorname, nachname;
```

| Eigenschaft | Bedeutung |
|-------------|-----------|
| **Temporär** | Nur während der Ausführung sichtbar |
| **Keine Datenbankspeicherung** | Wird nicht als Objekt gespeichert |
| **Jeder Benutzer schreibt seine eigene Logik** | Keine Wiederverwendung |

---

## 3. `VIEW` – die gespeicherte Abfrage

Eine `VIEW` ist ein **dauerhaftes Objekt** in der Datenbank, das eine Abfrage speichert. Danach kann sie wie eine Tabelle verwendet werden.

### 3.1 View erstellen

```sql
CREATE VIEW kunden_umsatz AS
SELECT 
    kunden.vorname, 
    kunden.nachname, 
    COALESCE(SUM(bestellungen.betrag), 0) AS gesamt
FROM kunden
LEFT JOIN bestellungen ON kunden.id = bestellungen.kunden_id
GROUP BY kunden.vorname, kunden.nachname;
```

### 3.2 View verwenden (wie eine Tabelle)

```sql
-- Einfach aus der View lesen
SELECT * FROM kunden_umsatz;

-- Mit WHERE filtern
SELECT * FROM kunden_umsatz WHERE gesamt > 100;

-- Mit anderen Tabellen JOINen
SELECT * FROM kunden_umsatz WHERE nachname LIKE 'M%';
```

### 3.3 View löschen

```sql
DROP VIEW kunden_umsatz;
```

---

## 4. Die wichtigsten Unterschiede im Überblick

| Merkmal | `SELECT` | `VIEW` |
|---------|----------|--------|
| **Dauerhaftigkeit** | ❌ nur temporär | ✅ dauerhaft gespeichert |
| **Wiederverwendbarkeit** | ❌ muss immer neu geschrieben werden | ✅ wie eine Tabelle nutzbar |
| **Zugriffsrechte** | erfordert Rechte auf Tabellen | kann Rechte kapseln (`GRANT` auf View) |
| **Speicherplatz** | kein Speicherplatz | nur die Definition, nicht die Daten (außer materialisierte Views) |
| **Datenaktualität** | immer aktuell (live) | immer aktuell (bei Standard‑Views) |
| **Performance** | bei komplexen Abfragen ggf. langsam | gleich wie `SELECT` (bei Standard‑View) |

---

## 5. Wann verwendet man was?

| Situation | Empfehlung |
|-----------|------------|
| Einmalige, schnelle Abfrage | `SELECT` |
| Komplexe Abfrage, die immer wieder benötigt wird | `VIEW` erstellen |
| Mehrere Benutzer sollen gleiche Logik nutzen (ohne SQL schreiben zu müssen) | `VIEW` |
| Zugriff auf bestimmte Spalten einschränken (Sicherheit) | `VIEW` (ohne Grant auf Tabelle) |
| Temporäre Abfrage innerhalb einer großen Auswertung | CTE (`WITH` …) |

---

## 6. Einschränkungen von Views

| Einschränkung | Erklärung |
|--------------|-----------|
| **Kein eigenes `ORDER BY`** (im View selbst) | Nicht erlaubt in den meisten DBMS (Ausnahme: mit `LIMIT` / `TOP`). |
| **DML-Einschränkungen** | `INSERT`, `UPDATE`, `DELETE` auf View sind nur eingeschränkt möglich (z. B. nur bei einer Tabelle, keine Aggregatfunktionen). |
| **Performance** | Bei komplexen Joins / Aggregaten wird der Code **bei jeder Abfrage neu ausgeführt**. |
| **Keine Parameter** | Eine View kann keine Parameter entgegennehmen (für parametrisierte Abfragen → gespeicherte Prozedur / Function). |

---

## 7. Materialisierte Views (Sonderfall)

Einige Datenbanken (Oracle, PostgreSQL, SQL Server) bieten **materialisierte Views** an:

- Die Abfrage wird **physikalisch gespeichert** (wie eine Tabelle).
- Deutlich **schneller** bei großen Datenmengen.
- Muss **aktualisiert** werden (manuell oder automatisch).

> **Hinweis:** MySQL unterstützt **keine** materialisierten Views nativ (nicht direkt).

---

## 8. Alternative: CTE (`WITH`) – die temporäre View

Eine Common Table Expression (CTE) ist wie eine **temporäre View**, die nur während einer Abfrage lebt.

```sql
WITH kunden_umsatz AS (
    SELECT ...    -- gleiche Logik wie bei der View
)
SELECT * FROM kunden_umsatz WHERE gesamt > 100;
```

| Merkmal | CTE | View |
|---------|-----|------|
| Dauerhaft | ❌ | ✅ |
| Wiederverwendbar in einer Abfrage | ✅ (mehrfach) | ✅ |
| Wiederverwendbar über mehrere Abfragen | ❌ | ✅ |

---

## 9. Praxisbeispiel (Vor‑ / Nachteile einer View)

### Aufgabe: Zeige alle Kunden mit Gesamtumsatz (auch mit 0 € Umsatz)

**Ohne View (jeder Benutzer muss die Logik kennen):**

```sql
SELECT 
    k.vorname, 
    k.nachname, 
    COALESCE(SUM(b.betrag), 0) AS gesamt
FROM kunden k
LEFT JOIN bestellungen b ON k.id = b.kunden_id
GROUP BY k.id, k.vorname, k.nachname;
```

**Mit View (nur einmal definieren, beliebig oft nutzen):**

```sql
CREATE VIEW kunden_umsatz AS
SELECT 
    k.id,
    k.vorname, 
    k.nachname, 
    COALESCE(SUM(b.betrag), 0) AS gesamt
FROM kunden k
LEFT JOIN bestellungen b ON k.id = b.kunden_id
GROUP BY k.id, k.vorname, k.nachname;

-- Danach ganz einfach:
SELECT * FROM kunden_umsatz WHERE gesamt > 100;
SELECT * FROM kunden_umsatz WHERE nachname = 'Müller';
```

---

## 10. Merksätze für die Prüfung

> **„Ein `SELECT` ist eine einmalige Abfrage – eine `VIEW` ist eine dauerhaft gespeicherte Abfrage, die sich wie eine Tabelle verwenden lässt.“** ✅

> **„Wenn du die gleiche komplizierte Abfrage öfter brauchst, mach eine View – dann musst du nicht jedes Mal die vielen Joins neu schreiben.“** ✅

> **„Views sind virtuell (außer materialisierte Views) – sie speichern keine Daten, nur die Abfrage.“** ✅

---

## 11. Übungsfrage

**Frage:**  
Warum solltest du eine `VIEW` anstatt eines `SELECT` verwenden, wenn mehrere Mitarbeiter immer wieder die gleiche Auswertung brauchen?

**Antwort (zum Nachdenken / Lernen):**
- Einsparung von Schreibarbeit
- Einheitliche Logik (keine Fehler durch unterschiedliche `SELECT`-Formulierungen)
- Zentrales Ändern der Logik (nur die View ändern, nicht Dutzende Abfragen)
- Berechtigungen: Mitarbeiter können die View sehen, ohne Zugriff auf die dahinter liegenden Tabellen zu haben.