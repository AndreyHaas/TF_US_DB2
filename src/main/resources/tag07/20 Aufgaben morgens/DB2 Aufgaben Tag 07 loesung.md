# 📘 Prüfungsvorbereitung: NoSQL DBMS (Tag 07)

---

## Frage 01: Erläutern Sie den Hauptunterschied zwischen vertikaler und horizontaler Skalierung.

| Skalierungsart | Beschreibung |
|----------------|--------------|
| **Vertikal (Scale‑up)** | Ein einzelner Server wird leistungsfähiger gemacht (mehr CPU, mehr RAM, schnellere SSDs). |
| **Horizontal (Scale‑out)** | Es werden **mehrere** Server (Knoten) hinzugefügt, die gemeinsam die Last verteilen. |

**Hauptunterschied:**  
Vertikal = **ein** Server wird stärker (Grenze: maximale Hardware).  
Horizontal = **viele** Server (theoretisch unbegrenzt, aber komplexer in der Verwaltung).

---

## Frage 02: Beschreiben Sie das Funktionsprinzip eines Key-Value-Stores.

Ein **Key-Value-Store** ist eine einfache NoSQL‑Datenbank, die Daten als **Schlüssel‑Wert‑Paare** speichert.

- Der **Schlüssel** (Key) ist eindeutig.
- Der **Wert** (Value) kann alles sein (String, JSON, Binärdaten, Bild).
- Es gibt **kein festes Schema**, keine Joins, keine Abfragesprache (außer get / put / delete).

**Beispiel:**  
`Key = "Benutzer:42"` → `Value = "{'name':'Anna', 'email':'anna@mail.de'}"`

**Typische Systeme:** Redis, DynamoDB (im einfachen Modus), Riak.

---

## Frage 03: Erklären Sie den Begriff „In-Memory-Datenbank“.

Eine **In‑Memory‑Datenbank** hält alle Daten **im Arbeitsspeicher (RAM)**, nicht auf der Festplatte.

| Merkmal | Erklärung |
|---------|-----------|
| **Geschwindigkeit** | extrem schnelle Lese‑ / Schreibzugriffe (Mikrosekunden statt Millisekunden) |
| **Nicht‑Flüchtigkeit** | bei Stromausfall sind Daten verloren (es sei denn, es gibt persistente Snapshots / Replikation) |
| **Typische Anwendungen** | Caching (Redis), Session‑Speicherung, Echtzeit‑Analysen |

**Beispiele:** Redis, Memcached, SAP HANA.

---

## Frage 04: Erläutern Sie den Vorteil von JSON/BSON als Speicherformat in Dokumenten‑DBs.

| Format | Vorteil |
|--------|---------|
| **JSON** | menschenlesbar, flexibel, kein festes Schema (jedes Dokument kann anders sein), wird nativ von Web‑APIs unterstützt |
| **BSON** (Binary JSON) | kompakter, schneller zu parsen, unterstützt zusätzliche Datentypen (z. B. `Date`, `BinData`), wird von MongoDB verwendet |

**Hauptvorteil gegenüber relationalen Tabellen:**  
Verschachtelte Strukturen (z. B. `{adresse: {strasse: "...", plz: ...}}`) können **direkt** abgebildet werden – ohne Joins.

---

## Frage 05: Warum scheitern relationale Datenbanken oft an tief verschachtelten Beziehungen (z. B. Freunde von Freunden von Freunden)?

- Relationale DBs nutzen **Joins** – bei tiefen Hierarchien (z. B. Freunde‑in‑Freunde‑in‑Freunde) explodiert die Anzahl der Joins exponentiell.
- Dies führt zu:
  - **extrem langsamen Abfragen** (viele Tabellen‑Joins)
  - **komplexen SQL‑Statements**
- **Graph‑Datenbanken** (z. B. Neo4j) sind für solche Abfragen optimiert, weil sie Beziehungen als **First‑Class‑Citizens** speichern.

---

## Frage 06: Wie unterscheidet sich die Speicherung eines Wide Column Stores von einer klassischen relationalen DB?

| Merkmal | Relationale DB (z. B. MySQL) | Wide Column Store (z. B. Cassandra) |
|---------|-------------------------------|--------------------------------------|
| **Schema** | fest (Spalten müssen vordefiniert sein) | flexibel (jede Zeile kann andere Spalten haben) |
| **Struktur** | Tabellen mit festen Spalten | Zeilen mit dynamischen Spaltenfamilien |
| **Skalierung** | eher vertikal | horizontal (verteilt) |
| **Typische Abfragen** | SQL mit Joins | Abfragen über Zeilen‑/Spaltenschlüssel (keine Joins) |

---

## Frage 07: Was ist das primäre Sortierkriterium in einer Time‑Series‑Datenbank?

Das primäre Sortierkriterium ist der **Zeitstempel** (Timestamp).

- Daten werden in zeitlicher Reihenfolge gespeichert.
- Abfragen sind meist auf **Zeitbereiche** ausgerichtet (z. B. Sensordaten der letzten 24 Stunden).
- Typische Optimierungen: Kompression, Aggregation nach Zeitintervallen.

**Beispiele:** InfluxDB, Prometheus, TimescaleDB.

---

## Frage 08: Warum kann man laut CAP in einem verteilten System bei einem Netzwerkausfall nicht gleichzeitig C und A garantieren?

Das **CAP‑Theorem** besagt:

| Eigenschaft | Bedeutung |
|-------------|-----------|
| **C (Consistency)** | Alle Knoten sehen die gleichen Daten (strikte Konsistenz). |
| **A (Availability)** | Jede Anfrage erhält eine Antwort (auch wenn nicht der neueste Stand). |
| **P (Partition Tolerance)** | System arbeitet weiter, auch wenn die Verbindung zwischen Knoten ausfällt (Netzwerkpartition). |

Bei einem **Netzwerkausfall (P)** muss man sich entscheiden:
- **CP**: System stoppt Schreibvorgänge oder blockiert, bis die Partition behoben ist → Konsistenz bleibt, aber Verfügbarkeit sinkt.
- **AP**: System akzeptiert weiter Schreibvorgänge → Verfügbarkeit bleibt, aber Daten können kurzzeitig inkonsistent sein (Eventual Consistency).

➡ **C und A gleichzeitig sind bei einer Partition unmöglich.**

---

## Frage 09: Was bedeutet „Soft State“?

**Soft State** bedeutet, dass der Zustand des Systems sich **auch ohne Benutzereingabe ändern kann**:

- Durch Hintergrundprozesse (Replikation, Anti‑Entropy).
- Durch festgelegte Verfallszeiten (TTL).
- Es gibt keinen **dauerhaft festen**, sofort konsistenten Zustand.

**Gegenbegriff:** „Hard State“ (dauerhafter, stabiler Zustand, wie bei ACID‑Datenbanken).

**Typisch für:** BASE‑orientierte NoSQL‑Systeme.

---

## Frage 10: Warum nutzen Logistikunternehmen oft NoSQL für das Paket‑Tracking?

Logistik‑Tracking hat Anforderungen, die relationale DBs schwer erfüllen können:

| Anforderung | Warum NoSQL besser geeignet ist |
|-------------|--------------------------------|
| **extrem viele Schreibvorgänge** | Paketscanner schreiben ständig neue Status (horizontal skalierbar) |
| **unterschiedliche Datenstrukturen** | jedes Paket kann andere Stationen / Status haben – kein festes Schema |
| **Verfügbarkeit > strikte Konsistenz** | kurzfristige Inkonsistenz akzeptabel (z. B. zwei Scanner sehen kurz unterschiedliche Status) |
| **hohe Lese‑Last** | (z. B. Kunde fragt „wo ist mein Paket?“) |
| **geografisch verteilt** | Paketzentren weltweit – NoSQL ist auf Verteilung ausgelegt |

**Typische NoSQL‑Typen für Tracking:**  
- **Wide Column Stores** (z. B. Cassandra) für hohe Schreiblasten  
- **Key-Value-Stores** für schnelle Statusabfragen  
- **Time‑Series‑DBs** für Verlauf / Historie (optional)