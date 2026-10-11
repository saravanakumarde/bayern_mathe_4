# Bayern Mathe 4 – Übungs-App

**Android-App (Flutter) für Mathematik-Übungen der 4. Klasse Grundschule Bayern**  
Ausgerichtet am offiziellen **LehrplanPLUS** des Bayerischen Staatsministeriums für Unterricht und Kultus / ISB.

## Lernbereiche (LehrplanPLUS Mathematik 3/4)

| Lernbereich              | Inhalte in der App                                      |
|--------------------------|---------------------------------------------------------|
| **Zahlen und Operationen** | Zahlenraum bis 1 000 000, Stellenwert, Vergleichen, Runden, Zahlenfolgen, Addition/Subtraktion/Multiplikation/Division (Kopf + schriftlich), Einmaleins, Sachaufgaben |
| **Raum und Form**        | Symmetrieachsen, Würfel/Quader (Ecken, Kanten, Flächen), Rauminhalt mit Einheitswürfeln |
| **Größen und Messen**    | Längen (mm–km), Massen (g/kg), Zeitspannen, Geld (€/ct), Volumen (ml/l), Umrechnungen |
| **Daten und Zufall**     | Daten aus Texten/Tabellen lesen, einfache Wahrscheinlichkeiten (Würfel, Kugeln, Glücksrad) |

## Features

- Dynamisch generierte Übungsaufgaben (unendlich viele Varianten)
- 3 Schwierigkeitsstufen (Leicht / Mittel / Schwer)
- Multiple-Choice und freie Eingabe
- Sofortiges Feedback + Erklärung
- Fortschritts- und Trefferstatistik (lokal gespeichert)
- Kindgerechtes, klares Design auf Deutsch
- Nur Übungen – kein Theorie-Unterricht

## Installation / Bauen

### Voraussetzungen
- Flutter SDK ≥ 3.2 ([flutter.dev](https://flutter.dev))
- Android Studio oder VS Code mit Flutter-Plugin
- Android-Gerät oder Emulator

### Schritte

```bash
# 1. In den Projektordner wechseln
cd bayern_mathe_4

# 2. Abhängigkeiten installieren
flutter pub get

# 3. App auf Gerät/Emulator starten
flutter run

# 4. APK bauen (Release)
flutter build apk --release
# Die APK liegt dann unter:
# build/app/outputs/flutter-apk/app-release.apk
```

### Optional: App-Icon & Name anpassen
In `android/app/src/main/AndroidManifest.xml` und über `flutter_launcher_icons` (nicht im Basisprojekt enthalten).

## Projektstruktur

```
lib/
├── main.dart                 # App-Einstieg
├── models/exercise.dart      # Datenmodell
├── services/
│   ├── exercise_generator.dart  # Aufgaben-Generator (Kern)
│   └── progress_service.dart    # Statistik
└── screens/
    ├── home_screen.dart      # Startseite + Kategorien
    ├── exercise_screen.dart  # Übungsmodus
    └── stats_screen.dart     # Statistik
```

## Hinweise zur Lehrplan-Treue

Die Aufgaben orientieren sich an den Kompetenzerwartungen des LehrplanPLUS:
- Zahlenraum bis zur Million
- Schriftliche Verfahren (u. a. Abziehverfahren, Multiplikation 1- und 2-stellig, Division mit Divisor ≤ 10)
- Automatisiertes Einmaleins
- Größenbereiche: Geld, Zeit, Längen, Massen, Hohlmaße
- Einfache kombinatorische und stochastische Situationen
- Raumvorstellung und achsensymmetrische Figuren

Die App ersetzt **keinen** Unterricht und keine Diagnostik durch Lehrkräfte. Sie dient ausschließlich dem zusätzlichen Üben.

## Lizenz

Dieses Projekt ist als Lern- und Übungsgrundlage frei verwendbar.  
Lehrplaninhalte © Bayerisches Staatsministerium für Unterricht und Kultus.
