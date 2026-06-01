# 📘 Prüfungsvorbereitung: CAP, ACID, BASE, OLTP, OLAP, DWH, Big Data

---

## Themenbereich 1: CAP-Theorem & Verteilte Systeme

**Frage 01: Warum ist in modernen Cloud-Systemen die Eigenschaft „P“ (Partitionstoleranz) meist unverzichtbar?**  
→ In Cloud‑Systemen sind Netzwerkpartitionen (z. B. Verbindungsausfall zwischen Rechenzentren oder Servern) unvermeidbar. Ohne Partitionstoleranz würde ein einziger Verbindungsfehler das gesamte System lahmlegen. Daher muss jedes echt verteilte System P erfüllen.

**Frage 02: Was passiert in einem AP‑System, wenn eine Netzwerkpartition auftritt?**  
→ Das System bleibt **verfügbar** (A), akzeptiert weiter Anfragen, kann aber **kurzzeitig inkonsistente Daten** liefern. Nach Auflösung der Partition gleichen sich die Knoten wieder an (Eventual Consistency).

**Frage 03: Nennen Sie zwei Nachteile der vertikalen Skalierung.**  
1. **Hardware‑Limit** – irgendwann ist kein Upgrade mehr möglich (max. CPU/RAM).  
2. **Hohe Kosten** – High‑End‑Komponenten sind überproportional teuer.  
3. (optional) **Single Point of Failure** – fällt der eine Server aus, ist das gesamte System betroffen.

**Frage 04: Warum skalieren NoSQL‑Datenbanken oft besser horizontal als relationale Datenbanken?**  
→ NoSQL‑Systeme sind von Grund auf für **Verteilung** entworfen (z. B. Sharding, Master‑los, Eventual Consistency). Viele relationale DBs sind eher auf vertikale Skalierung optimiert; horizontale Skalierung ist oft nachträglich mit komplexen Clustern möglich, aber weniger effizient.

**Frage 05: Was versteht man unter einem „Single Point of Failure“?**  
→ Eine einzelne Komponente (Server, Festplatte, Switch, Datenbankinstanz), deren Ausfall das gesamte System unverfügbar macht.

**Frage 06: Skizzieren Sie kurz die Entscheidungsebene: Wenn ein System CA wählt, was bedeutet das für die Verteilung?**  
→ CA (Konsistenz + Verfügbarkeit) ist **nicht partitionstolerant**. Das System läuft nur störungsfrei, wenn keine Netzwerkpartition auftritt – es ist also **nicht echt verteilt** (z. B. eine einzelne Datenbankinstanz ohne Replikation). Bei einer Partition würde es stoppen oder Fehler liefern.

---

## Themenbereich 2: ACID vs. BASE

**Frage 07: Erklären Sie das Prinzip der „Atomarität“.**  
→ Eine Transaktion wird entweder **vollständig** ausgeführt oder **gar nicht** (alles oder nichts). Tritt ein Fehler auf, werden bereits ausgeführte Schritte rückgängig gemacht (Rollback).

**Frage 08: Was garantiert die „Isolation“ bei Datenbanktransaktionen?**  
→ Gleichzeitig ablaufende Transaktionen beeinflussen sich **gegenseitig nicht** – sie laufen isoliert voneinander, als wären sie nacheinander ausgeführt. Das verhindert z. B. „Dirty Reads“.

**Frage 09: Was ist der Kernunterschied zwischen ACID und BASE bezüglich der Konsistenz?**  
→ **ACID** garantiert **strikte Konsistenz** (nach jeder Transaktion sind alle Daten sofort konsistent).  
→ **BASE** erlaubt **kurzfristige Inkonsistenz** (Eventual Consistency) – die Konsistenz stellt sich erst später ein.

**Frage 10: Beschreiben Sie den Zustand „Soft State“.**  
→ Der Systemzustand kann sich **auch ohne Benutzereingabe** ändern – z. B. durch Replikation, Hintergrundprozesse oder Anti‑Entropy‑Mechanismen. Es gibt keinen festen, sofort konsistenten Zustand.

**Frage 11: Warum ist ACID für OLTP‑Systeme so wichtig?**  
→ OLTP‑Systeme verarbeiten **Buchungen, Bestellungen, Zahlungen** – Daten müssen jederzeit **konsistent** sein (kein Geldverlust, keine doppelten Buchungen). ACID garantiert Transaktionssicherheit.

**Frage 12: Welches der beiden Konzepte (ACID/BASE) ist typisch für Big‑Data‑Anwendungen und warum?**  
→ **BASE** – Big‑Data‑Anwendungen (soziale Medien, Sensordaten, Logs) priorisieren **Verfügbarkeit und Skalierbarkeit** vor strikter Sofortkonsistenz. Kurzzeitige Inkonsistenzen (z. B. Like‑Zähler) sind akzeptabel.

**Frage 13: Was bedeutet „Durability“ (Dauerhaftigkeit) konkret nach einem Systemabsturz?**  
→ Einmal bestätigte (committete) Transaktionen bleiben **dauerhaft erhalten** – auch nach Stromausfall, Absturz oder Neustart. Die Daten sind auf nichtflüchtigem Speicher (SSD, Festplatte) gesichert.

---

## Themenbereich 3: OLTP vs. OLAP

**Frage 14: Definieren Sie OLTP.**  
→ **OLTP** (Online Transaction Processing) – Systeme zur Verarbeitung **vieler kurzer, atomarer Transaktionen** im Tagesgeschäft (z. B. Bestellungen, Buchungen, Kontoauszüge). Typisch: viele Schreib‑ und Leseoperationen auf aktuellen Daten.

**Frage 15: Vergleichen Sie die Datenmenge pro Abfrage bei OLTP und OLAP.**  
→ **OLTP:** sehr kleine Datenmengen (meist einzelne oder wenige Datensätze).  
→ **OLAP:** sehr große Datenmengen (Millionen bis Milliarden Datensätze, Aggregationen).

**Frage 16: Warum werden für OLAP‑Systeme Daten oft denormalisiert?**  
→ Um **Joins zu reduzieren** und die Abfragegeschwindigkeit zu erhöhen. Denormalisierte Tabellen (Stern‑ / Schneeflockenschema) sind für lesende, aggregierende Analysen optimiert.

**Frage 17: Nennen Sie ein typisches Beispiel für eine OLTP‑Anweisung.**  
→ `UPDATE konto SET saldo = saldo - 100 WHERE konto_nr = 12345;` (Einzelbuchung).

**Frage 18: Nennen Sie ein typisches Beispiel für eine OLAP‑Abfrage.**  
→ `SELECT region, SUM(umsatz) FROM verkauf WHERE jahr = 2024 GROUP BY region;` (Aggregation über große Datenmenge).

**Frage 19: Was ist das Hauptmerkmal der Datenaktualität in OLTP vs. OLAP?**  
→ **OLTP:** Daten sind **aktuell** (Echtzeit, Stand der letzten Sekunde).  
→ **OLAP:** Daten sind **historisch** (oft tägliche / nächtliche Aktualisierung, Stand von gestern).

**Frage 20: Welches System hat typischerweise mehr Schreibzugriffe – OLTP oder OLAP?**  
→ **OLTP** (viele INSERTs, UPDATEs, DELETEs). OLAP ist meist **leselastig** (Schreibzugriffe nur beim ETL‑Laden).

**Frage 21: Welches Speichermedium ist für OLTP aufgrund der Latenz besonders wichtig?**  
→ **SSD** (Solid State Drive) – wegen geringer Latenz und schnellen Einzelzugriffen. OLAP kann auch langsamere Speicher nutzen (z. B. HDD, Objektspeicher).

---

## Themenbereich 4: Data Warehouse & ETL

**Frage 22: Erläutern Sie die drei Schritte des ETL‑Prozesses.**  
1. **Extract** (Extraktion) – Daten aus Quellsystemen auslesen (OLTP, Dateien, APIs).  
2. **Transform** (Transformation) – Bereinigen, Aggregieren, Umformen, Denormalisieren.  
3. **Load** (Laden) – Daten in das Data Warehouse schreiben.

**Frage 23: Was passiert in der „Transform“‑Phase konkret? Nennen Sie zwei Beispiele.**  
– Bereinigen (z. B. fehlerhafte Datumsformate korrigieren)  
– Denormalisierung (z. B. mehrere Tabellen zu einer großen Tabelle zusammenführen)

**Frage 24: Was unterscheidet ELT von ETL?**  
→ Bei **ELT** werden die Daten **zuerst geladen**, die Transformation erfolgt **im Data Warehouse** (meist mit leistungsfähigen DWH‑Funktionen). ELT nutzt die Rechenleistung des Zielsystems und ist typisch für moderne Cloud‑DWH (z. B. BigQuery, Snowflake).

**Frage 25: Warum ist die Datenbereinigung im DWH‑Prozess so kritisch?**  
→ Fehlerhafte oder inkonsistente Daten führen zu **falschen Analysen, Fehlentscheidungen und mangelndem Vertrauen** in das Berichtssystem. „Garbage in – garbage out“.

**Frage 26: Nennen Sie drei typische Datenquellen für ein Data Warehouse.**  
1. ERP‑System (z. B. SAP)  
2. CRM‑System (z. B. Salesforce)  
3. Operative Datenbank (z. B. MySQL‑Bestandsdaten)

**Frage 27: Was ist ein Data Mart?**  
→ Ein **ausschnittsbezogener** Teil des Data Warehouse für eine bestimmte Fachabteilung (z. B. Vertriebs‑Data‑Mart, Finanz‑Data‑Mart). Enthält meist aggregierte, denormalisierte Daten.

**Frage 28: Erklären Sie den Begriff „Historisierung“ im DWH.**  
→ Daten werden **über lange Zeiträume** (Jahre) gespeichert, nicht nur der aktuelle Stand. Zeitvergleiche (z. B. Umsatzentwicklung) und „wie war es damals“‑Fragen sind möglich.

**Frage 29: Welches Tool/Sprache wird meist zur Abfrage eines DWH genutzt?**  
→ **SQL** (Standard für relationale DWH). Zusätzlich oft Analyse‑Erweiterungen oder BI‑Tools (Power BI, Tableau).

**Frage 30: Was ist der Unterschied zwischen einem Data Warehouse und einem Data Lake bezüglich der Struktur?**  
→ **DWH:** Daten sind vor dem Laden **strukturiert und modelliert** (Schema‑on‑Write).  
→ **Data Lake:** Daten werden **roh** in beliebiger Struktur (strukturiert, semi‑, unstrukturiert) abgelegt (Schema‑on‑Read).

---

## Themenbereich 5: Big Data & Datenstrukturen

**Frage 31: Nennen Sie die „5 V’s“ von Big Data und erläutern Sie kurz „Velocity“.**  
→ **Volume** (Datenmenge), **Velocity** (Geschwindigkeit), **Variety** (Vielfalt), **Veracity** (Wahrhaftigkeit), **Value** (Wert).  
→ **Velocity:** Daten werden mit hoher Geschwindigkeit erzeugt und müssen ggf. in Echtzeit verarbeitet werden (z. B. Sensordaten, Börsenkurse, Log‑Streams).

**Frage 32: Was versteht man unter „Semi‑strukturierten Daten“?**  
→ Daten mit einer **flexiblen, erkennbaren Struktur**, aber ohne striktes starres Schema (z. B. JSON, XML, Log‑Dateien mit variablen Feldern).

**Frage 33: Warum gewinnen unstrukturierte Daten heute so stark an Bedeutung?**  
→ Immer mehr relevante Daten fallen in unstrukturierter Form an: E‑Mails, Social‑Media‑Posts, Bilder, Videos, PDFs, Sensordaten. Sie enthalten wertvolle Informationen für Analysen (Text‑/Bild‑/Video‑Mining, KI).

**Frage 34: Was ist ein Data Lakehouse?**  
→ Eine **Architektur**, die die Flexibilität und Skalierbarkeit eines **Data Lake** mit der **Performance, Transaktionssicherheit und Struktur** eines **Data Warehouse** kombiniert (z. B. Delta Lake, Apache Iceberg).

**Frage 35: Nennen Sie drei Beispiele für unstrukturierte Daten.**  
1. E‑Mails  
2. Videos / Bilder  
3. PDF‑Dokumente mit Freitext

**Frage 36: Was ist der Hauptvorteil von JSON gegenüber CSV?**  
→ JSON unterstützt **Hierarchien, Arrays und verschachtelte Strukturen** – CSV kann nur flache, tabellarische Daten abbilden. JSON ist außerdem **semi‑strukturiert** und benötigt kein festes Schema.

**Frage 37: Welche Rolle spielt „Veracity“ bei Big Data?**  
→ **Veracity** (Wahrhaftigkeit, Datenqualität) – beschreibt Unsicherheiten, Ausreißer, fehlerhafte oder betrügerische Daten. Big‑Data‑Analysen müssen mit ungenauen oder inkonsistenten Daten umgehen können.

**Frage 38: Warum ist Objektspeicher (Object Storage) für Data Lakes besser geeignet als klassische Dateisysteme?**  
→ Objektspeicher (z. B. S3, ADLS) skaliert **praktisch unbegrenzt** (Petabyte bis Exabyte), ist **kostengünstig** und unterstützt **beliebige Dateiformate** sowie **Metadaten** (Schema‑on‑Read). Klassische Dateisysteme (z. B. NFS, HDFS) haben oft Grenzen bei Anzahl der Dateien und Skalierung.