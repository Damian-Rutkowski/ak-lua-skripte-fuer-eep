# Lua Test vor EEP

Diese Anlage - oder besser deren Lua-Skripte - demonstriert folgendes:

* Lua-Skript auf Syntax-Fehler prüfen
* Lua-Skript auf Herz und Nieren testen
* Lua-Skript Änderungen ohne Copy & Paste in EEP übernehmen - Einfach im Lua-Fenster auf _Skript neu laden_ klicken

Siehe __[ak/strasse](../../ak/eep/README.md)__

## Motivation

Je komplexer die eigenen Lua-Skripte werden, umso mehr möchte man sie selbst testen. Am besten, ohne dass die Skripte
fehlerhaft in EEP laufen und zu "Unfällen" führen.

_Die Grundidee_: __Das Lua-Skript wird erst nach dem bestandenen Test in EEP geladen.__

## Vorbereitungen

* Sämtlicher Inhalt des Anlagen-Skriptes `Lua-Test-vor-EEP.lua`, welches die `EEPMain()`-Funktion enthält, wird in ein
  Haupt-Skript, z.B. `ak-demo-lua\testen\Lua-Test-vor-EEP-main.lua` in `C:\Trend\EEP14\LUA` abgelegt.

* Die Aufgabe des Anlagen-Skriptes `Lua-Test-vor-EEP.lua` ist nur noch das Einbinden Haupt-Skript mittels `require
  'ak-demo-lua.testen.Lua-Test-vor-EEP-main'`, so dass EEP die Main-Methode und alles andere findet
  (da EEP bei require-Befehlen immer in `C:\Trend\EEP14\LUA` schaut, wird das Haupt-Skript von EEP gefunden)

* Es wird ein Testskript `ak-demo-lua\testen\Lua-Test-vor-EEP-test.lua` in `C:\Trend\EEP14\LUA` erstellt,
  welches das Haupt-Skript auch mittels require 'Lua-Test-vor-EEP-main' einbindet.

* Damit das Haupt-Skript ohne EEP funktioniert gibt es von mir ein Skript `AkEepFunktionen.lua` welches auch in
  `C:\Trend\EEP14\LUA` abgelegt werden muss, damit es beim testen die Funktionen von EEP bereitstellt.
  Dieses muss in `ak-demo-lua\testen\Lua-Test-vor-EEP-test.lua` an erster Stelle eingebunden werden:
  `require 'ak.eep.AkEepFunktionen'`

* Zum Ausführen des Testskriptes ohne EEP ist Lua 5.2 erforderlich - z.B. `lua.exe`, `lua52.dll` und `luac.exe` aus
folgendem Link. https://sourceforge.net/projects/luabinaries/files/5.2.4/Tools%20Executables/lua-5.2.4_Win64_bin.zip/download
 diese 3 Dateien einfacherweise auch in `C:\Trend\EEP14\LUA` ablegen


## Der Arbeitsablauf

- Nach dem dem Editieren von `Lua-Test-vor-EEP-main.lua` wird diese gespeichert

- Danach wird `Lua-Test-vor-EEP-test.lua` ausgeführt:
  * In Notepad++ mit F5 folgenden Befehl ausführen:
    `cmd /k C:\Trend\EEP14\LUA\lua.exe Lua-Test-vor-EEP-test.lua`

  * Die Kommandozeile starten: `<Windows-Taste>` + `<R>` und dann `cmd` eintippen und starten
    * Mit der Kommandozeile nach `C:\Trend\EEP14\LUA` wechseln: `cd C:\Trend\EEP14\LUA`
    * Mit der Kommandozeile das Test-Skript starten: `lua.exe Lua-Test-vor-EEP-test.lua`

- Ist man mit dem Ergebnis zufrieden kann man in EEP einfach auf "Skript neu laden" klicken und der Inhalt des
  Haupt-Skriptes wird in EEP ausgeführt


## Testen der Funktion

In EEP ist es manchmal schlecht möglich alle Zustände einer Funktion zu prüfen, ohne diverse Rollmaterialien auf den
Weg zu schicken. Hier kann der Test helfen:

```lua
zaehleHoch() -- simuliere ein Fahrzeug, welches in den Bereich einfährt
assert(1 == zaehler) -- prüfen den zaehler
EEPMain() -- EEPMain aufrufen und danach das Signal prüfen
assert (4 == EEPGetSignal(1)) -- Prüfe das Signal - der Zaehler ist 1, das Signal muss auf 4 stehen
```
