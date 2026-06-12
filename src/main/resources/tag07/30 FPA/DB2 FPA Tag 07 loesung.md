# 📘 Prüfungsvorbereitung: NoSQL DBMS (Tag 07)

## Themenbereich 1: Grundlagen und Motivation

### Frage 01: Warum wird NoSQL als „Not Only SQL“ bezeichnet?

NoSQL bedeutet **„Not Only SQL“** (nicht „No SQL“). Das soll ausdrücken:

- Es werden **nicht-relationale** Datenmodelle verwendet (Key-Value, Dokument, Graph, Wide Column).
- SQL wird nicht abgelehnt, sondern **ergänzt** – viele Systeme bieten zusätzlich SQL-ähnliche Abfragemöglichkeiten.
- Der Begriff betont, dass NoSQL **mehr** ist als nur relationale Datenbanken.

---

### Frage 02: Was versteht man unter dem Begriff „Schema-on-Read“?

| Konzept | Erklärung |
|---------|-----------|
| **Schema-on-Read** | Das Datenbankschema wird **erst beim Lesen** (Abfragen) interpretiert. |
| **Gegenteil** | Schema-on-Write (klassische SQL‑DBs): Das Schema muss vor dem Einfügen der Daten definiert werden. |

**Vorteil:** Man kann Daten beliebig speichern, ohne sie vorher zu strukturieren (flexibel, gut für unstrukturierte / sich ändernde Daten).

---

### Frage 03: Nennen Sie drei Gründe, warum ein Unternehmen von SQL zu NoSQL wechseln könnte.

| Grund | Erklärung |
|-------|-----------|
| 1. **Horizontale Skalierbarkeit** | NoSQL ist für verteilte Systeme (Cluster) konzipiert, SQL eher für vertikale Skalierung. |
| 2. **Flexibles Schema** | Keine starren Tabellenstrukturen – besonders nützlich bei wechselnden Anforderungen. |
| 3. **Hohe Schreiblasten** | Z. B. Logging, Sensordaten, Tracking – NoSQL schreibt schneller auf viele Knoten verteilt. |

---

## Themenbereich 2: Key-Value-Stores

### Frage 04: Warum werden Key-Value-Stores wie Redis häufig für das Session-Management eingesetzt?

- **Sehr schnelle Zugriffe** (O(1) über den Schlüssel).
- **In-Memory-Speicher** (Redis) → extrem niedrige Latenz.
- **Einfaches Modell:** Session‑ID als Key, Session‑Daten als Value (z. B. JSON, Nutzerprofil, Warenkorb).
- **TTL (Time‑to‑Live):** Sessions können automatisch ablaufen.

---

### Frage 05: Was ist der Nachteil, wenn man in einem reinen Key-Value-Store nach einem Attribut innerhalb des „Values“ suchen möchte?

- Ein reiner Key-Value-Store hat **keine sekundären Indizes**.
- Eine Suche nach einem Wert innerhalb des Values müsste **alle Keys durchlaufen** (Vollscan) → sehr langsam (O(n)).
- **Lösung:** Sekundärindizes extern verwalten (z. B. über Such-Engine) oder anderen NoSQL‑Typ (Dokumenten‑DB) wählen.

---

## Themenbereich 3: Dokumentenorientierte Datenbanken

### Frage 06: Was ist eine „Collection“ in einer Dokumenten-Datenbank?

Eine **Collection** ist eine **Gruppe von Dokumenten** (ähnlich einer Tabelle in SQL, aber ohne festes Schema).

- Dokumente innerhalb einer Collection können **unterschiedliche Felder** haben.
- **Beispiele:** `users`, `products`, `orders`.

---

### Frage 07: Was bedeutet „Polymorphie“ im Kontext von Dokumenten?

**Polymorphie** bedeutet: In einer Collection können Dokumente **unterschiedliche Strukturen** haben.

**Beispiel:**  
In der Collection `vehicles`:

```json
{ "type": "car", "brand": "BMW", "doors": 4 }
{ "type": "bike", "brand": "Canyon", "frameSize": "L" }
```

➡ Kein Problem – kein festes Schema erlaubt solche Unterschiede.

---

### Frage 08: Warum ist die Entwicklung mit Dokumenten-DBs für Web-Entwickler oft intuitiver?

- **Daten sind JSON** – exakt das Format, das auch im Frontend (JavaScript) und Backend (REST‑APIs) verwendet wird.
- **Keine Joins** nötig: Zusammengehörige Daten werden direkt im Dokument gespeichert (z. B. Bestellung mit Adresse als eingebettetes Objekt).
- **Weniger „Impedance Mismatch“** zwischen Objekt‑Code und Datenbank.

---

## Themenbereich 4: Graph-Datenbanken

### Frage 09: Definieren Sie die Begriffe „Node“, „Edge“ und „Property“.

| Begriff | Bedeutung |
|---------|-----------|
| **Node** | Knoten (Entität), z. B. `Person`, `Company`, `City`. |
| **Edge** | Kante (Beziehung) zwischen Knoten, z. B. `kennt`, `arbeitet_bei`. |
| **Property** | Eigenschaft (Attribut), z. B. `name="Anna"`, `since=2020`. |

---

### Frage 10: Erklären Sie das Konzept des „Index-free Adjacency“.

- Jeder Knoten **kennt seine Nachbarn direkt** (durch direkte Referenzen / Zeiger).
- Es wird **kein zentraler Index** benötigt, um Nachbarn zu finden.
- Dadurch sind **Traversierungen** (z. B. „Freunde von Freunden“) extrem schnell, unabhängig von der Gesamtgröße des Graphen.

---

### Frage 11: Nennen Sie ein Beispiel für ein „Property“ an einer Kante (Edge).

**Beispiel:**  
Kante `arbeitet_bei` zwischen `Person` und `Firma`:

```json
{
  "since": 2021,
  "position": "Backend Developer",
  "fullTime": true
}
```

➡ Die Kante hat eigene Attribute.

---

### Frage 12: Was ist eine Empfehlungs-Engine (Recommendation Engine)?

Ein System, das auf Basis von **Beziehungen** und **Interaktionen** Vorschläge macht:

- „Kunden, die dies kauften, kauften auch …“
- „Personen, die dir folgen, folgen auch …“

**Typische Umsetzung:** Graph‑Datenbank (z. B. Neo4j), weil Beziehungen effizient traversiert werden können.

---

## Themenbereich 5: Spaltenorientierte Datenbanken (Wide Column)

### Frage 13: Warum profitieren analytische Abfragen (Aggregatfunktionen) von spaltenorientierter Speicherung?

- Daten werden **spaltenweise** gespeichert (nicht zeilenweise).
- Nur die Spalten, die für die Abfrage benötigt werden, müssen gelesen werden.
- Das spart **I/O** und beschleunigt Aggregationen wie `SUM`, `AVG`, `COUNT` erheblich.

---

### Frage 14: Was versteht man unter einer „Sparse Column“ in diesem Kontext?

Eine **Sparse Column** ist eine Spalte, die in **den meisten Zeilen keinen Wert** (`NULL` oder nichts) enthält.

**Vorteil im Wide‑Column‑Store:** Solche Spalten benötigen **keinen Speicherplatz**, wenn sie nicht vorhanden sind – im Gegensatz zu relationalen DBs (wo jede Spalte für jede Zeile Platz reserviert).

---

## Themenbereich 6: Time-Series-Datenbanken

### Frage 15: Erklären Sie den Begriff „Data Downsampling“.

**Downsampling** bedeutet, dass Daten mit **geringerer Auflösung** gespeichert werden:

- Aus Sekundenwerten werden Minuten‑Mittelwerte.
- Aus Minuten werden Stundenwerte.
- **Ziel:** Speicherplatz sparen, Abfragen über große Zeiträume beschleunigen.

---

### Frage 16: Warum ist die Schreibgeschwindigkeit bei Time-Series-DBs so kritisch?

- Sensoren, IoT‑Geräte oder Serverlogs erzeugen **Millionen Schreibvorgänge pro Sekunde**.
- Die Datenbank muss diese Last **in Echtzeit** bewältigen können – sonst gehen Daten verloren oder das System wird instabil.

---

## Themenbereich 7: CAP-Theorem und ACID vs. BASE

### Frage 17: Erläutern Sie die drei Säulen des CAP-Theorems.

| Buchstabe | Bedeutung |
|-----------|-----------|
| **C** | **Consistency (Konsistenz)** – Alle Knoten sehen die gleichen Daten. |
| **A** | **Availability (Verfügbarkeit)** – Jede Anfrage erhält eine Antwort. |
| **P** | **Partition Tolerance (Partitionstoleranz)** – System arbeitet trotz Netzwerkausfall (Partition) weiter. |

➡ **In einem verteilten System können nur zwei der drei Eigenschaften gleichzeitig voll erfüllt werden.**

---

### Frage 18: Wofür steht das Akronym BASE?

| Buchstabe | Bedeutung |
|-----------|-----------|
| **B** | **Basically Available** – Immer verfügbar (auch bei Partition). |
| **S** | **Soft State** – Zustand kann sich ohne Eingabe ändern. |
| **E** | **Eventual Consistency** – Daten werden letztlich konsistent. |

➡ **Gegenmodell zu ACID** (typisch für NoSQL).

---

### Frage 19: Erklären Sie den Begriff „Eventual Consistency“ an einem Beispiel.

**Beispiel:**  
Ein Like‑Zähler in sozialen Netzwerken.

- Nach einem Klick sehen verschiedene Nutzer kurzzeitig 101, 102 oder 103 Likes.
- Nach einigen Sekunden gleichen sich alle Server auf den richtigen Stand (z. B. 103) an.

➡ **Letztliche Konsistenz** – nicht sofort, aber irgendwann.

---

### Frage 20: In welchem Fall ist ACID-Konformität (SQL) zwingend gegenüber BASE vorzuziehen?

| Anwendung | Warum ACID zwingend ist |
|-----------|------------------------|
| **Banküberweisungen** | Kein Geldverlust, keine doppelten Buchungen. |
| **Flug‑ / Hotelreservierungen** | Keine Doppelbuchungen. |
| **Lagerbestandsführung** | Letzte Einheit darf nicht zweimal verkauft werden. |

➡ Überall dort, wo **sofortige, strikte Konsistenz** und **Transaktionssicherheit** erforderlich ist.

---

## Themenbereich 8: Skalierung und Verteilung

### Frage 21: Was ist „Sharding“?

**Sharding** ist die **horizontale Partitionierung** von Daten über mehrere Server.

- Jeder Server (Shard) trägt **nur einen Teil** der Daten.
- Der Shard wird über einen **Shard‑Key** bestimmt (z. B. `user_id % 4`).

---

### Frage 22: Was ist der Unterschied zwischen Sharding und Replikation?

| Konzept | Beschreibung |
|---------|--------------|
| **Sharding** | Verteilung **unterschiedlicher** Daten auf viele Server (jeder Server hat eigene Daten). |
| **Replikation** | Gleiche Daten werden auf mehrere Server kopiert (für Ausfallsicherheit / höhere Leselast). |

➡ Sharding = **mehr Daten**, Replikation = **mehr Redundanz**.

---

### Frage 23: Erklären Sie die Aufgabe eines „Load Balancers“ im NoSQL‑Cluster.

Ein **Load Balancer** verteilt eingehende Anfragen auf mehrere Server:

- Vermeidet Überlastung einzelner Knoten.
- Kann Ausfälle erkennen (Health Checks) und defekte Server umgehen.
- Unterstützt horizontale Skalierung (einfach mehr Server hinzufügen).

---

## Themenbereich 9: O-Notation und Performance

### Frage 24: Warum ist O(1) bei Key-Value-Abfragen das Idealziel?

- O(1) bedeutet: Die Zugriffszeit ist **konstant**, unabhängig von der Anzahl der Datensätze.
- Bei einem Key‑Value‑Store mit Hash‑Index wird genau das erreicht.
- Das ist **optimal** für Latenz‑sensitive Anwendungen (Caching, Session‑Store).

---

### Frage 25: Welche Komplexität hat die Suche in einer unindizierten Dokumenten-Collection mit n Dokumenten?

- **O(n)** – ein Vollscan über alle Dokumente ist nötig, weil kein Index auf das Suchfeld existiert.
- Bei sehr vielen Dokumenten wird das **extrem langsam**.

---

## Themenbereich 10: Praxisanwendungen und Auswahl

### Frage 26: Welcher Datenbanktyp eignet sich am besten für die Betrugserkennung (Fraud Detection) bei Kreditkarten?

**Graph‑Datenbanken** (z. B. Neo4j).

- Betrugsmuster sind oft über Beziehungen erkennbar (z. B. verdächtige Transaktionsketten, gemeinsame Geräte / IPs).
- Graph‑Traversierung ist effizienter als viele Joins in SQL.

---

### Frage 27: Erklären Sie den Begriff „Polyglot Persistence“.

**Polyglot Persistence** bedeutet: In einer Anwendung werden **mehrere verschiedene Datenbanktechnologien** gleichzeitig eingesetzt – je nach Anforderung:

- Key‑Value für Session‑Store (Redis)
- Dokumenten‑DB für Produktkatalog (MongoDB)
- Graph‑DB für Empfehlungen (Neo4j)
- SQL für Finanztransaktionen (PostgreSQL)

---

### Frage 28: Was ist ein „Schema-Migration“-Problem in SQL und wie löst NoSQL dies?

| SQL (Schema-Migration) | NoSQL |
|------------------------|-------|
| Änderungen am Schema erfordern `ALTER TABLE` (oft mit Downtime). | Schema‑on‑Read / flexibles Schema: Neue Felder werden einfach hinzugefügt, alte Dokumente bleiben wie sie sind (keine Migration nötig). |

---

### Frage 29: Beschreiben Sie eine „Hotspot“-Problematik beim Sharding.

- Ein **Hotspot** entsteht, wenn ein Shard übermäßig viel Last abbekommt (z. B. durch einen schlecht gewählten Shard‑Key).
- **Beispiel:** Sharding nach `nachname` – viele Anfragen auf einen häufigen Namen (`Müller`) belasten einen Shard extrem.

---

### Frage 30: Was ist der „Quorum“-Ansatz bei der Lese‑/Schreibkonsistenz?

Ein **Quorum** ist eine Mindestanzahl von Knoten, die bei einem Lese‑ oder Schreibvorgang bestätigen müssen.

**Beispiel (3 Knoten):**
- `W = 2` (mindestens 2 Knoten bestätigen Schreibvorgang)
- `R = 2` (mindestens 2 Knoten werden für eine Leseabfrage befragt)

Damit wird ein Kompromiss zwischen Konsistenz und Verfügbarkeit erreicht.

---

## Themenbereich 11: Vergleich und Definitionen

### Frage 31: Nennen Sie den bekanntesten Vertreter für Document Stores.

**MongoDB**

---

### Frage 32: Welches NoSQL-System ist für Wide Column Stores bekannt?

**Apache Cassandra** (auch: HBase)

---

### Frage 33: Inwiefern unterscheiden sich „strukturierte“ von „semi-strukturierten“ Daten?

| Datenart | Beschreibung | Beispiel |
|----------|--------------|----------|
| **Strukturiert** | Starres Schema (Spalten, Datentypen) | SQL‑Tabelle |
| **Semi‑strukturiert** | Enthält Strukturelemente (Tags, Schlüssel), aber kein starres Schema | JSON, XML, BSON |

---

### Frage 34: Was ist „Object Storage“ im Vergleich zu NoSQL?

| Konzept | Beschreibung |
|---------|--------------|
| **Object Storage** | Speicherung von unstrukturierten Blobs (Bilder, Videos, Backups) mit Metadaten – z. B. Amazon S3. |
| **NoSQL** | Datenbank mit Abfragemöglichkeiten, Indizes, Konsistenzmodellen. |

➡ Object Storage ist **kein** NoSQL‑System (auch wenn es manchmal als NoSQL bezeichnet wird). Es dient eher als persistentes Datei‑Speichersystem.

---

### Frage 35: Was versteht man unter „Multi-Model-Datenbanken“?

Eine Datenbank, die **mehrere NoSQL‑Datenmodelle** in einem System vereint:

- Key‑Value
- Dokument
- Graph
- Spaltenfamilie

**Beispiel:** ArangoDB, OrientDB

---

## Themenbereich 12: Big Data Konzepte

### Frage 36: Erklären Sie den Zusammenhang zwischen „Big Data“ und NoSQL

- Big Data = große Datenmengen (Volume), hohe Geschwindigkeit (Velocity), verschiedene Formate (Variety).
- NoSQL wurde **speziell für Big Data** entwickelt: horizontal skalierbar, flexibles Schema, hohe Schreiblasten, verteilt.

➡ Ohne NoSQL wäre Big Data mit klassischen SQL‑Datenbanken kaum zu bewältigen.

---

### Frage 37: Was ist ein „Data Lake“?

Ein **Data Lake** ist ein zentraler Speicher für **rohe Daten** in beliebigem Format:

- Strukturiert (CSV)
- Semi‑strukturiert (JSON, XML)
- Unstrukturiert (Bilder, Videos, PDFs)

➡ Im Gegensatz zum Data Warehouse: Daten werden **nicht vor dem Laden** transformiert.

---

### Frage 38: Wie wird die Verfügbarkeit in einem NoSQL-Cluster sichergestellt, wenn ein Server physisch abbrennt?

- **Replikation:** Daten sind auf mehreren Knoten vorhanden.
- Wenn ein Knoten ausfällt, übernehmen die anderen Knoten seine Arbeit.
- Systeme wie Cassandra / MongoDB erkennen den Ausfall automatisch und leiten Anfragen um.

---

### Frage 39: Warum ist die Dokumentation des Datenmodells bei NoSQL wichtiger als bei SQL?

- SQL: Das Schema ist in der Datenbank selbst dokumentiert (Tabellen, Spalten, Datentypen, Constraints).
- NoSQL: Es gibt **kein festes Schema** – die Struktur ist nur implizit im Code vorhanden.
- **Daher:** Ohne gute Dokumentation weiß niemand mehr, welche Felder existieren oder wie sie zu interpretieren sind.

---

### Frage 40: Was ist die Hauptaufgabe eines Fachinformatikers bei der Auswahl einer NoSQL-Datenbank?

- Analyse der **Anforderungen** (Lese‑/Schreiblast, Konsistenz, Skalierung, Datenmodell).
- Bewertung verschiedener NoSQL‑Typen (Dokument, Key‑Value, Graph, Wide Column, Time‑Series).
- Entscheidung, ob ein **NoSQL‑System überhaupt** sinnvoll ist (oder ob SQL besser passt).
- Kosten‑ / Nutzen‑Abwägung (Betriebsaufwand, Lizenz, Wartung).