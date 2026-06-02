# 📘 Prüfungsvorbereitung: ERD, Normalisierung (1NF–3NF), Tabellenmodell (Tag 02)

## Themenbereich 1: ER-Modellierung (ERD) & Notationen

### Frage 01: Nennen und erläutern Sie die drei Grundelemente eines Entity-Relationship-Diagramms (ERD) nach Chen.

| Element | Darstellung (Chen) | Bedeutung |
|---------|-------------------|------------|
| **Entität** | Rechteck | Objekt der realen Welt (Person, Produkt, Firma) mit eigenständiger Existenz. |
| **Beziehung** | Raute | Logische Verbindung zwischen zwei oder mehr Entitäten (z. B. `arbeitet_in`). |
| **Attribut** | Ellipse / Kreis | Eigenschaft einer Entität oder Beziehung (z. B. `Name`, `Preis`, `Datum`). |

---

### Frage 02: Wie wird ein Primärschlüssel (Schlüsselattribut) in der Chen-Notation grafisch gekennzeichnet?

→ Unterstreichen des Attributs in der Ellipse.  
→ Zusätzlich oft: Attributname **unterstrichen** im Modell.

---

### Frage 03: Erklären Sie den Begriff „mehrwertiges Attribut“ und geben Sie ein Beispiel.

**Definition:** Ein Attribut, das **mehrere Werte** gleichzeitig enthalten kann.

**Beispiel:**  
- Entität: `Person`  
- Attribut: `Telefonnummer` (mehrere Nummern möglich, z. B. privat, beruflich, mobil)

**Problematik:** Verletzt die 1NF.

---

### Frage 04: Was versteht man unter einem „abgeleiteten Attribut“? Geben Sie ein Beispiel.

**Definition:** Ein Attribut, dessen Wert **aus anderen Attributen berechnet** werden kann (keine eigene Speicherung nötig).

**Beispiel:**  
- `Alter` kann aus `Geburtsdatum` berechnet werden.  
- `Gesamtpreis` kann als `Menge * Einzelpreis` berechnet werden.

**Darstellung in Chen-Notation:** gestrichelte Ellipse (oder Doppel‑Ellipse).

---

### Frage 05: Definieren Sie den Begriff „Kardinalität“ im Kontext von ER-Modellen.

→ Gibt an, **wie viele Entitäten** einer Seite **mit wie vielen Entitäten** der anderen Seite in Beziehung stehen können.  
→ Typen: `1:1`, `1:n`, `n:m`.

**Beispiel:**  
- Ein **Kunde** kann **mehrere Bestellungen** haben → `1:n`.  
- Eine **Bestellung** gehört zu **genau einem Kunden** → `1:1` (wenn keine Bestellung ohne Kunde existieren darf).

---

### Frage 06: Was beschreibt eine „rekursive Beziehung“?

→ Eine Beziehung, die eine Entität **mit sich selbst** verbindet.  
→ Wird oft verwendet für Hierarchien (Mitarbeiter → Vorgesetzter, Teil → Unterteil).

**Beispiel:**  
`Person` → `ist_verheiratet_mit` → `Person` (1:1)  
`Mitarbeiter` → `ist_vorgesetzter_von` → `Mitarbeiter` (1:n)

---

### Frage 07: Warum werden Beziehungen in der Chen-Notation als Rauten dargestellt?

→ **Visuelle Unterscheidung** von Entitäten (Rechteck).  
→ Die Raute verdeutlicht: *das ist eine Verbindung, kein Objekt.*  
→ Platz für den **Beziehungsnamen** (Verb, z. B. `bestellt`, `arbeitet_in`).

---

### Frage 08: Was ist eine „identifizierende Beziehung“?

→ Eine Beziehung, bei der die **schwache Entität nicht ohne ihre Hauptentität existieren kann**.  
→ Der Primärschlüssel der schwachen Entität enthält den **Primärschlüssel der Hauptentität** als Fremdschlüssel.

**Beispiel:**  
- `Rechnung` (Hauptentität)  
- `Rechnungsposition` (schwache Entität) – ohne Rechnung sinnlos.

**Darstellung in Chen:** doppelte Raute, doppelte Linie zur schwachen Entität.

---

## Themenbereich 2: Datenbank-Anomalien

### Frage 09: Was ist eine „Lösch-Anomalie“?

→ Beim Löschen eines Datensatzes gehen **ungewollt weitere Informationen** verloren, weil sie nicht unabhängig gespeichert sind.

**Beispiel (nicht normalisiert):**

| KursID | Kursname | Dozent | Teilnehmer |
|--------|----------|--------|------------|
| 101 | SQL | Meier | Anna |
| 101 | SQL | Meier | Ben |

Wenn der letzte Teilnehmer eines Kurses gelöscht wird, verschwindet auch der **Kursname + Dozent**, obwohl dieser Kurs weiter existiert.

---

### Frage 10: Beschreiben Sie die „Änderungs-Anomalie“ (Update-Anomalie).

→ Gleiche Information muss an **mehreren Stellen** geändert werden; wenn eine Stelle vergessen wird, entsteht **Inkonsistenz**.

**Beispiel (nicht normalisiert):**

| KursID | Kursname | Dozent | Teilnehmer |
|--------|----------|--------|------------|
| 101 | SQL | Meier | Anna |
| 101 | SQL | Meier | Ben |

Ändert sich der Dozent von Meier zu Schulz, müssen **beide Zeilen** aktualisiert werden. Wird eine Zeile vergessen → inkonsistenter Zustand.

---

### Frage 11: Definieren Sie „Datenkonsistenz“.

→ **Zustand der Datenbank, in dem keine widersprüchlichen Informationen existieren.**  
→ Gleiche Tatsache ist überall **gleich** dargestellt.  
→ Alle Integritätsbedingungen (Primär‑/Fremdschlüssel, Datentypen, Domänen) sind erfüllt.

**Beispiel:**  
Ein Kunde heißt entweder überall `Meier` oder überall `Mayer` – nicht einmal `Meier`, einmal `Mayer`.

---

## Themenbereich 3: Normalisierung (1NF, 2NF, 3NF)

**Frage 12: Nennen Sie die Bedingung für die 1. Normalform (1NF).**  
→ Jede Tabelle muss **atomare Werte** enthalten (keine Mengen, keine wiederholten Gruppen).  
→ Jede Zeile muss eindeutig identifizierbar sein (Primärschlüssel).

**Frage 13: Definieren Sie eine „Wiederholungsgruppe“.**  
→ Mehrere Werte desselben Attributs in einer Zeile (z. B. `Telefon1`, `Telefon2`, `Telefon3` oder eine Liste von Werten).  
→ Verletzt die 1NF, weil nicht atomar.

**Frage 14: Welche Voraussetzungen müssen erfüllt sein, damit eine Tabelle in der 2. Normalform (2NF) vorliegt?**  
→ Die Tabelle muss bereits in der **1NF** sein.  
→ **Keine partiellen Abhängigkeiten** – Nicht‑Schlüsselattribute müssen vom **gesamten Primärschlüssel** abhängen (bei zusammengesetztem Primärschlüssel).

**Frage 15: Erklären Sie die „volle funktionale Abhängigkeit“.**  
→ Ein Nicht‑Schlüsselattribut darf **nicht von einem Teil** des zusammengesetzten Primärschlüssels abhängen, sondern muss vom **gesamten** zusammengesetzten Schlüssel abhängen.

**Frage 16: Eine Tabelle mit dem Schlüssel (Bestell‑ID, Artikel‑ID) enthält das Attribut „Artikelname“. Warum verletzt dies die 2NF?**  
→ `Artikelname` hängt nur von `Artikel‑ID` ab, nicht von `Bestell‑ID`.  
→ Das ist eine **partielle Abhängigkeit** – Verstoß gegen die 2NF.

**Frage 17: Welche Voraussetzungen gelten für die 3. Normalform (3NF)?**  
→ Die Tabelle muss bereits in der **2NF** sein.  
→ **Keine transitiven Abhängigkeiten** – Nicht‑Schlüsselattribute dürfen nicht voneinander abhängen.

**Frage 18: Was ist eine „transitive Abhängigkeit“?**  
→ Ein Nicht‑Schlüsselattribut hängt von einem **anderen Nicht‑Schlüsselattribut** ab.  
→ Beispiel: `PLZ → Ort` (wenn `Ort` von der Postleitzahl abhängt, aber nicht direkt vom Primärschlüssel).

**Frage 19: Wie bereinigt man eine Verletzung der 3. Normalform?**  
→ Man trennt die abhängigen Attribute in eine **eigene Tabelle** und verweist mit einem Fremdschlüssel.  
→ Beispiel: Aus `Mitarbeiter` werden `Abteilungs_ID` (FK) ausgelagert, `Abteilungsname` kommt in Tabelle `Abteilung`.

**Frage 20: Welchen Vorteil hat die 3NF bei der Wartung der Daten?**  
→ Keine Anomalien mehr (Einfüge‑, Änderungs‑, Lösch‑Anomalien).  
→ Änderungen müssen nur **an einer Stelle** durchgeführt werden (z. B. neue Postleitzahl nur in einer Tabelle).

**Frage 21: Ist eine Datenbank in der 3NF automatisch performanter als eine nicht normalisierte Datenbank? Begründen Sie.**  
→ **Nein, nicht automatisch.**  
→ 3NF reduziert Redundanz, kann aber **mehr Joins** erfordern → mögliche Verschlechterung der Leseperformance.  
→ In Data Warehouses wird daher oft bewusst **denormalisiert**, um Abfragen zu beschleunigen.

---

## Themenbereich 4: Relationales Mapping (Vom ERD zur Tabelle)

**Frage 22: Beschreiben Sie die Mapping‑Regel für eine 1:1‑Beziehung.**  
→ Der Primärschlüssel einer Seite wird als **Fremdschlüssel** in die andere Tabelle eingefügt.  
→ Oder: Beide Seiten teilen sich denselben Primärschlüssel.

**Frage 23: Erklären Sie die Mapping‑Regel für eine 1:n‑Beziehung.**  
→ Der Primärschlüssel der **1‑Seite** wird als **Fremdschlüssel** in die Tabelle der **n‑Seite** eingefügt.

**Frage 24: Was passiert mit Attributen, die direkt an einer n:m‑Beziehung hängen (Beziehungsattribute)?**  
→ Sie kommen in die **Kreuztabelle** (die Tabelle, die die n:m‑Beziehung auflöst).

**Frage 25: Welchen Datentyp sollte ein Fremdschlüssel haben?**  
→ **Denselben Datentyp** wie der Primärschlüssel, auf den er verweist (inklusive Länge/Genauigkeit).

**Frage 26: Was ist die Aufgabe eines Fremdschlüssels (FK)?**  
→ Er stellt die **referenzielle Integrität** sicher: Ein Wert darf nur vorkommen, wenn er in der referenzierten Tabelle existiert.  
→ Er bildet Beziehungen zwischen Tabellen ab.

**Frage 27: Kann ein Fremdschlüssel Teil eines Primärschlüssels sein? Wenn ja, wo?**  
→ **Ja** – in Kreuztabellen (n:m‑Beziehungen) sind beide Fremdschlüssel zusammen der zusammengesetzte Primärschlüssel.

**Frage 28: Was versteht man unter einem „zusammengesetzten Primärschlüssel“?**  
→ Ein Primärschlüssel, der aus **mehreren Spalten** besteht (z. B. `BestellID, ArtikelID`).

**Frage 29: Warum ist es sinnvoll, künstliche Schlüssel (Surrogat‑Keys wie Auto‑Increment IDs) statt natürlicher Schlüssel (wie Name) zu verwenden?**  
→ Sie sind **stabil** (ändern sich nie).  
→ Sie sind **einfach** (ein Wert, ein Datentyp).  
→ Sie vermeiden Probleme mit **Duplikaten** oder **späteren Änderungen**.

**Frage 30: Wie wird im Tabellenschema ein Fremdschlüssel üblicherweise gekennzeichnet?**  
→ In Text‑Dokumentation oft: `abteilungs_id (FK)`  
→ In SQL mit der Klausel: `FOREIGN KEY (abteilungs_id) REFERENCES abteilung(id)`

---

## Themenbereich 5: Tabellenmodell & Dokumentation

**Frage 31: Was bedeutet die Eigenschaft „Nullability“ in einer Tabellendefinition?**  
→ Gibt an, ob eine Spalte den Wert `NULL` (unbekannt / nicht vorhanden) enthalten darf.  
→ `NOT NULL` = Wert muss vorhanden sein.

**Frage 32: Was versteht man unter der „Dimensionierung“ eines Datentyps?**  
→ Die Festlegung von **maximaler Länge, Genauigkeit oder Wertebereich** (z. B. `VARCHAR(50)`, `DECIMAL(10,2)`, `INT`).  
→ Vermeidet unnötigen Speicherplatzverbrauch und erhöht die Datenqualität.

**Frage 33: Nennen Sie drei gängige Datentypen in relationalen Datenbanken.**  
1. `INT` (ganze Zahlen)  
2. `VARCHAR(n)` (variable Textlänge)  
3. `DATE` (Datum)

**Frage 34: Was ist ein „Tupel“?**  
→ Eine **Zeile** in einer relationalen Tabelle.  
→ Beispiel: Ein vollständiger Datensatz mit Werten für jede Spalte.

**Frage 35: Definieren Sie den Begriff „Relation“ im Kontext des relationalen Modellentwurfs.**  
→ Eine **Tabelle** mit Zeilen (Tupeln) und Spalten (Attributen).  
→ Jede Relation hat einen eindeutigen Namen und ein festes Schema.

**Frage 36: Warum sollte man bei der Dokumentation eines Tabellenmodells auf den Datenschutz achten?**  
→ Dokumentation könnte in falsche Hände geraten (z. B. nicht öffentliche Musterdaten enthalten).  
→ Tabellen mit personenbezogenen Daten (`Name`, `Adresse`, `Krankendaten`) sollten geschwärzt oder anonymisiert werden.

**Frage 37: Was ist der Unterschied zwischen einem logischen Datenmodell (ERD) und einem physischen Datenmodell (Tabellenschema)?**  
→ **Logisches Modell (ERD):** unabhängig von konkreter DBMS, zeigt Entitäten, Attribute, Beziehungen.  
→ **Physisches Modell (Tabellenschema):** konkrete Umsetzung mit Datentypen, Primär‑/Fremdschlüsseln, Indizes, Tabellennamen.

**Frage 38: Erklären Sie den Begriff „Referenzielle Integrität“.**  
→ Ein Fremdschlüsselwert muss in der referenzierten Tabelle **existieren** oder `NULL` sein (falls erlaubt).  
→ Verhindert „verwaiste Datensätze“ (z. B. Bestellung ohne existierenden Kunden).

**Frage 39: Welche Rolle spielt die Fachabteilung beim Entwurf des ER‑Modells?**  
→ Sie liefert die **Fachlichkeit**:  
  - Welche Entitäten gibt es wirklich?  
  - Welche Attribute sind wichtig?  
  - Welche Geschäftsregeln gelten (z. B. eine Bestellung gehört zu genau einem Kunden)?  
→ Die Fachabteilung **validiert** das Modell.

---

## 📌 Merksätze für die Prüfung

| Konzept | Merksatz |
|---------|----------|
| **ERD Grundelemente** | Entität (Rechteck), Beziehung (Raute), Attribut (Ellipse). |
| **Primärschlüssel (Chen)** | Unterstrichenes Attribut in der Ellipse. |
| **Mehrwertiges Attribut** | Mehrere Werte (z. B. mehrere Telefonnummern). |
| **Abgeleitetes Attribut** | Wird berechnet (Alter aus Geburtsdatum). |
| **Kardinalität** | 1:1, 1:n, n:m. |
| **Rekursive Beziehung** | Entität mit sich selbst verbunden (Vorgesetzter). |
| **Identifizierende Beziehung** | Schwache Entität → doppelte Raute, doppelte Linie. |
| **1NF** | Atomare Werte, keine Wiederholungsgruppen. |
| **2NF** | Keine partielle Abhängigkeit (nur bei zusammengesetztem PK). |
| **3NF** | Keine transitiven Abhängigkeiten. |
| **Wiederholungsgruppe** | Mehrere Werte in einer Zelle. |
| **Partielle Abhängigkeit** | Nicht‑Schlüsselattribut hängt von nur einem Teil des zusammengesetzten PK ab. |
| **Transitive Abhängigkeit** | Nicht‑Schlüsselattribut hängt von einem anderen Nicht‑Schlüsselattribut ab. |
| **Denormalisierung** | Bewusste Redundanz für Performance (3NF oft langsamer bei vielen Joins). |
| **1:1** | FK auf eine Seite oder geteilter PK. |
| **1:n** | FK auf die n‑Seite. |
| **n:m** | Kreuztabelle (zwei FK, zusammen PK). |
| **Beziehungsattribut** | Kommt in die Kreuztabelle. |
| **Surrogat‑Key** | Künstliche ID (int, auto_increment) – stabil, einfach. |
| **Fremdschlüssel** | Gleicher Typ wie referenzierter PK. |
| **Referenzielle Integrität** | FK muss existieren oder NULL. |