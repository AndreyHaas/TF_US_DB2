# 📘 Prüfungsvorbereitung: ERD, Normalisierung (1NF–3NF) und Tabellenmodell

---

## Frage 01: Unterscheiden Sie grafisch (die Darstellung) und inhaltlich (was sagt es aus) zwischen einer Entität und einer schwachen Entität.

| Merkmal | Entität | Schwache Entität |
|---------|---------|------------------|
| **Grafische Darstellung (ERD)** | Rechteck (einfach) | Doppeltes Rechteck (doppelter Rahmen) |
| **Beziehung zum Elternteil** | Identifizierende Beziehung (durchgezogene Linie) | Identifizierende Beziehung (doppelte Raute, doppelte Linie) |
| **Primärschlüssel** | Eindeutig, existiert eigenständig | Zusammengesetzt aus Fremdschlüssel + Teil-/Discriminator |
| **Inhalt (was sagt es aus?)** | Objekt, das **ohne ein anderes** existieren kann (z. B. Kunde, Produkt) | Objekt, das **nicht ohne seine zugehörige Hauptentität** existieren kann (z. B. Rechnungsposition gehört zu Rechnung) |

**Beispiel:**  
– **Entität:** `Kunde` (existiert auch ohne Bestellung).  
– **Schwache Entität:** `Bestellposition` (existiert nicht ohne zugehörige `Bestellung`).

---

## Frage 02: In welcher Notation wird die Kardinalität „viele“ durch eine dreizackige Verzweigung (Krähenfuß) dargestellt?

Die **dreizackige Verzweigung** (Krähenfuß, engl. *crow’s foot*) ist das Markenzeichen der **Chen‑Notation / Information Engineering (IE) Notation** (oft auch „Krähenfuß‑Notation“ oder „Martin‑/Finkelstein‑Notation“ genannt).

- **1** bedeutet: genau eine Entität  
- **Viele (Krähenfuß, dreizackig)** bedeutet: mehrere (n) Entitäten  
- **Optionaler Kreis** bedeutet: 0 oder 1 (nullable)

**Bekannteste Tool‑Umsetzung:** Oracle Designer, PowerDesigner, draw.io (Crow’s Foot).

---

## Frage 03: Erklären Sie die „Einfüge-Anomalie“ anhand eines Beispiels.

**Einfügeanomalie** = Du kannst einen Datensatz **nicht** einfügen, weil eine andere (noch nicht vorhandene) Information fehlt (obwohl sie eigentlich unabhängig ist).

**Beispiel (nicht normalisierte Tabelle):**

| KursID | Kursname | Dozent | Teilnehmer |
|--------|----------|--------|------------|
| 101 | SQL | Meier | Anna |
| 101 | SQL | Meier | Ben |

**Problem:**  
Ein neuer Kurs `102 – Java` mit Dozent `Schulz` soll angelegt werden, aber es ist noch kein Teilnehmer eingetragen.  
Weil `Teilnehmer` ein Pflichtfeld ist (Teil des Primärschlüssels?), **kann der Kurs nicht eingefügt werden**, obwohl Kursname und Dozent bereits feststehen.

➡ **Lösung:** Normalisierung (eigene Tabelle `Kurse`, `Dozenten`, `Teilnehmer`, getrennt voneinander).

---

## Frage 04: Welcher negative Effekt entsteht durch Redundanz in einer Datenbank?

Durch **Redundanz** (mehrfache Speicherung derselben Information) entstehen:

| Effekt | Beschreibung |
|--------|--------------|
| **Anomalien** (Insert, Update, Delete) | Inkonsistente Änderungen möglich, weil an mehreren Stellen gepflegt werden muss. |
| **Speicherverschwendung** | unnötiger Platzverbrauch (besonders kritisch bei großen Tabellen). |
| **Inkonsistenz** | gleiche Tatsache wird unterschiedlich gespeichert (z. B. einmal `Meier`, einmal `Meyer`). |
| **Langsamere Abfragen** | mehr Daten = langsamere Scans/Joins. |

---

## Frage 05: Was bedeutet „atomar“ im Sinne der 1NF für das Attribut „Anschrift“ (bestehend aus Straße, PLZ, Ort)?

**Atomar** bedeutet: Das Attribut darf **nicht weiter zerlegbare Werte** enthalten (keine Mengen, keine zusammengesetzte Struktur).

Die **Anschrift** (Straße + PLZ + Ort) ist **nicht atomar** – sie ist ein **zusammengesetztes Attribut**.  
➡ Für die 1NF muss es in **drei separate atomare Attribute** zerlegt werden:

- `Strasse` (atomar)  
- `PLZ` (atomar)  
- `Ort` (atomar)

**Schlecht (nicht 1NF):** `Anschrift = "Hauptstr. 10, 80331 München"`  
**Gut (1NF):** `Strasse = "Hauptstr. 10", PLZ = "80331", Ort = "München"`

---

## Frage 06: Wann muss die 2NF gar nicht erst geprüft werden?

Die 2NF ist **nur für Tabellen mit zusammengesetztem Primärschlüssel** relevant.  
Wenn der Primärschlüssel **aus nur einer Spalte** besteht, kann eine Tabelle automatisch die 2NF erfüllen (weil partielle Abhängigkeiten nicht möglich sind).  
➡ Prüfung der 2NF entfällt dann.

---

## Frage 07: In einer Tabelle „Mitarbeiter“ (PK: Pers_Nr) gibt es die Spalten „Abteilungs_ID“ und „Abteilungsname“. Warum ist das nicht 3NF-konform?

**Weil eine transitive Abhängigkeit vorliegt:**  
`Pers_Nr → Abteilungs_ID → Abteilungsname`

- `Abteilungsname` ist **funktional abhängig** von `Abteilungs_ID`, aber nicht direkt vom Primärschlüssel `Pers_Nr`.
- Das verstößt gegen die 3NF (keine transitiven Abhängigkeiten von Nicht‑Schlüsselattributen).

**Lösung:**  
Tabelle `Mitarbeiter` enthält nur `Abteilungs_ID` (Fremdschlüssel).  
`Abteilungsname` gehört in die separate Tabelle `Abteilung`.

---

## Frage 08: Was versteht man unter „Denormalisierung“?

**Denormalisierung** ist die **bewusste, kontrollierte Einführung von Redundanz** in eine normalisierte Datenbank – um **Abfrageperformance zu optimieren** (SELECT schneller machen, Joins reduzieren).

**Typische Maßnahmen:**
- Zusammenführung von Tabellen (kein JOIN mehr nötig)
- Einfügen von redundanten Spalten (z. B. `Abteilungsname` in `Mitarbeiter`)
- Vorberechnete Summen / Zähler

**Nachteil:** Redundanz → Update‑Anomalien möglich (muss durch Anwendungslogik kompensiert werden).

---

## Frage 09: Wie wird eine n:m-Beziehung in ein Tabellenmodell überführt?

Eine **n:m-Beziehung** wird durch eine **eigene Tabelle (Kreuztabelle, Assoziationstabelle, Link-Tabelle)** aufgelöst, die die beiden Primärschlüssel der beteiligten Entitäten als Fremdschlüssel enthält (oft zusammen der zusammengesetzte Primärschlüssel).

**Beispiel (Student n:m Kurs):**

**Student** (Student_ID, …)  
**Kurs** (Kurs_ID, …)  
**Student_Kurs** (Student_ID, Kurs_ID, ggf. Note, Datum)

Der Primärschlüssel der Kreuztabelle ist meistens `(Student_ID, Kurs_ID)`.

---

## Frage 10: Warum sollten Primärschlüssel immer „NOT NULL“ sein?

Ein Primärschlüssel muss **jede Zeile eindeutig identifizieren**.  
Ein `NULL`‑Wert bedeutet **unbekannt / nicht vorhanden** – zwei `NULL`‑Werte könnten nicht voneinander unterschieden werden.  
Daher erlauben Datenbanksysteme standardmäßig **keine `NULL`‑Werte** in der Primärschlüsselspalte.  
➡ **NOT NULL** ist logisch zwingend für die Eindeutigkeit.

---

## 📌 Merksätze für die Prüfung

| Konzept | Merksatz |
|---------|----------|
| **Schwache Entität** | „Kann nicht ohne Hauptentität existieren – doppelter Rahmen.“ |
| **Krähenfuß‑Notation** | Viele = Krähenfuß (Crow’s Foot). |
| **Einfügeanomalie** | Kann nichts einfügen, weil ein anderer (nicht benötigter) Wert fehlt. |
| **Redundanz** | Anomalien + Inkonsistenz + Platzverschwendung. |
| **Atomar (1NF)** | Keine zusammengesetzten Werte in einer Spalte. |
| **2NF irrelevant bei** | Einspaltigem Primärschlüssel. |
| **3NF Problem** | Transitive Abhängigkeit über eine andere Spalte. |
| **Denormalisierung** | Redundanz für Performance (bewusst). |
| **n:m** | Immer extra Kreuztabelle. |
| **PRIMARY KEY = NOT NULL** | Weil NULL nicht eindeutig sein kann. |