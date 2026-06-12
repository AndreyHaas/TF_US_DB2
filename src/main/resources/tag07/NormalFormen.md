# Normalformen in SQL – einfach erklärt

## Warum Normalisierung?

Normalisierung ist der Prozess, eine Datenbank so zu strukturieren, dass:
- **Redundanz** vermieden wird (gleiche Daten nicht mehrfach speichern)
- **Anomalien** vermieden werden (Einfüge‑, Änderungs‑, Lösch‑Anomalien)
- Die Datenbank **konsistent** bleibt.

---

## 1. Normalform (1NF)

### Regel
- Jede Spalte enthält **atomare Werte** (nicht weiter zerlegbar).
- Es gibt keine **Wiederholungsgruppen** (mehrere Werte in einer Zelle).

### Beispiel (nicht 1NF)

| Kunde_ID | Name | Telefonnummern       |
|----------|------|----------------------|
| 1        | Anna | 01234, 05678         |
| 2        | Ben  | 0111                 |

➡ Problem: `Telefonnummern` enthält mehrere Werte → **nicht atomar**.

### Nach 1NF (korrigiert)

| Kunde_ID | Name | Telefonnummer |
|----------|------|---------------|
| 1        | Anna | 01234         |
| 1        | Anna | 05678         |
| 2        | Ben  | 0111          |

---

## 2. Normalform (2NF)

### Voraussetzung
- Die Tabelle muss bereits in der **1NF** sein.
- Der Primärschlüssel darf **nicht zusammengesetzt** sein? **Doch**: Bei zusammengesetztem Schlüssel gilt:

### Regel
- **Keine partiellen Abhängigkeiten**:  
  Ein Nicht‑Schlüsselattribut darf nicht nur von **einem Teil** des zusammengesetzten Primärschlüssels abhängen.

### Beispiel (nicht 2NF)

| Bestell_ID | Artikel_ID | Artikelname | Menge |
|------------|------------|-------------|-------|
| 1          | 100        | Hammer      | 2     |
| 1          | 101        | Nagel       | 10    |

➡ Primärschlüssel = `(Bestell_ID, Artikel_ID)`  
➡ `Artikelname` hängt **nur von `Artikel_ID`** ab, nicht von `Bestell_ID`  
➡ **partielle Abhängigkeit** → Verletzung der 2NF.

### Nach 2NF (korrigiert)

**Tabelle `Bestellung_Position`**:

| Bestell_ID | Artikel_ID | Menge |
|------------|------------|-------|

**Tabelle `Artikel`**:

| Artikel_ID | Artikelname |
|------------|-------------|

---

## 3. Normalform (3NF)

### Voraussetzung
- Die Tabelle muss bereits in der **2NF** sein.

### Regel
- **Keine transitiven Abhängigkeiten**:  
  Ein Nicht‑Schlüsselattribut darf nicht von **einem anderen Nicht‑Schlüsselattribut** abhängen.

### Beispiel (nicht 3NF)

| Mitarbeiter_ID | Name | PLZ | Ort |
|----------------|------|-----|-----|
| 1              | Anna | 80331 | München |
| 2              | Ben  | 80331 | München |

➡ Primärschlüssel = `Mitarbeiter_ID`  
➡ `Ort` hängt von `PLZ` ab (nicht direkt von `Mitarbeiter_ID`) → **transitive Abhängigkeit**.

### Nach 3NF (korrigiert)

**Tabelle `Mitarbeiter`**:

| Mitarbeiter_ID | Name | PLZ |
|----------------|------|-----|

**Tabelle `Ort`**:

| PLZ    | Ort      |
|--------|----------|
| 80331  | München  |

---

## Zusammenfassung (Merksätze)

| Normalform | Regel |
|------------|-------|
| **1NF** | Atomare Werte, keine Wiederholungsgruppen |
| **2NF** | Keine partiellen Abhängigkeiten (nur bei zusammengesetztem Primärschlüssel) |
| **3NF** | Keine transitiven Abhängigkeiten |

---

## Wann ist Normalisierung nicht sinnvoll?

- **Read‑only‑Systeme** (Data Warehouse, Berichte)
- **Performance‑Optimierung** (Denormalisierung für schnellere Lesezugriffe)

Aber für transaktionale Systeme (OLTP) sind die Normalformen **sehr wichtig**.