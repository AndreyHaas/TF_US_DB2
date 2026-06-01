# 📘 CAP, Skalierung, ACID, BASE, OLAP, DWH – kompakte Übersicht

---

## 1. Grundlegendes Dilemma des CAP-Theorems

> **Von den drei Eigenschaften Konsistenz (Consistency), Verfügbarkeit (Availability) und Partitionstoleranz (Partition Tolerance) können in einem verteilten System maximal zwei gleichzeitig voll erfüllt werden – die dritte muss eingeschränkt werden.**

---

## 2. „Consistency“ im CAP-Kontext

**Definition:**  
Alle Knoten eines verteilten Systems sehen zur gleichen Zeit die gleichen Daten.

---

## 3. Beispiel: Konsistenz vor Verfügbarkeit (C > A)

Ein klassisches Beispiel ist die **Kontostandsführung im Online‑Banking** – insbesondere bei Überweisungen, Kontostandsabfragen und Wertpapiergeschäften.  
➡ Fehlerhafte Buchungen / Geldverlust sind schlimmer als kurze Unterbrechungen.

---

## 4. Vertikale vs. horizontale Skalierung

| Skalierungsart | Beschreibung |
|----------------|--------------|
| **Vertikal (Scale‑up)** | Ein einzelner Knoten wird durch mehr Ressourcen (CPU, RAM) verbessert. |
| **Horizontal (Scale‑out)** | Es werden weitere Knoten hinzugefügt – wichtig für Ausfallsicherheit und unbegrenztes Wachstum. |

---

## 5. ACID – Deutsche Fachbegriffe

| Buchstabe | Englisch | Deutsch |
|-----------|----------|---------|
| A | Atomicity | **Atomarität** |
| C | Consistency | **Konsistenz** |
| I | Isolation | **Isolation** (auch: Isolierung) |
| D | Durability | **Dauerhaftigkeit** (auch: Persistenz) |

➡ Die vier zentralen Eigenschaften von Transaktionen in Datenbanksystemen.

---

## 6. BASE – Das Gegenmodell zu ACID

**B**asically **A**vailable, **S**oft state, **E**ventual consistency

> BASE beschreibt die Eigenschaften vieler NoSQL‑Datenbanken:  
> immer verfügbar, kurzfristige Inkonsistenzen erlaubt, aber letztlich konsistent.

---

## 7. Wann ist „Eventual Consistency“ akzeptabel? Beispiel

**Akzeptabel, wenn kurzzeitige Inkonsistenzen keine schweren Folgen haben** – z. B. bei Likes, Kommentaren, Warenkörben.

**Klassisches Beispiel:**  
Der **Like‑Zähler in sozialen Netzwerken** – nach einem Klick sehen verschiedene Nutzer kurzzeitig unterschiedliche Zahlen. Nach wenigen Sekunden gleicht sich das System an. Für diesen Fall völlig in Ordnung.

---

## 8. OLAP – Definition

**OLAP** (Online Analytical Processing) ist eine Technologie zur **mehrdimensionalen Analyse** großer Datenmengen. Sie ermöglicht schnelle, komplexe Abfragen und Auswertungen für:

- Entscheidungsunterstützung
- Business Intelligence (BI)
- Data Warehousing

➡ **Ziel:** Daten aus verschiedenen Perspektiven (Dimensionen) zu betrachten, zu filtern, zu aggregieren (Summe, Durchschnitt etc.) und Trends zu erkennen.

---

## 9. Warum OLAP nicht auf produktiven OLTP‑Datenbanken ausführen?

- OLAP-Analysen würden die **Performance ruinieren**  
- Das **Tagesgeschäft blockieren**  
- Sie sind für **historische Daten nicht ausgelegt**

> Produktive OLTP‑Datenbanken sind für **schnelle Transaktionen** optimiert, OLAP für **komplexe Analysen**.  
> Daher trennt man sie durch ein **Data Warehouse / Data Mart**, um das operative Geschäft nicht zu gefährden.

---

## 10. Primäre Aufgabe eines Data Warehouse (DWH)

Ein Data Warehouse sammelt, integriert und historisiert Daten aus verschiedenen Quellsystemen, um unternehmensweite Analysen zu ermöglichen – **ohne das operative Tagesgeschäft zu belasten**.

➡ **Primäre Aufgabe:** Zentrale, integrierte, langfristige Speicherung von Daten für BI‑Analysen und Entscheidungsunterstützung.