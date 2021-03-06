Zugname = "#PLATZHALTER"

print("Lade AkEepFunctions ...")
require 'ak.eep.AkEepFunktionen'
-- endregion

clearlog()
--------------------------------------------------------------------
-- Zeigt erweiterte Informationen waehrend der Initialisierung an --
--------------------------------------------------------------------
AkDebugInit = false

--------------------------------------------------------------------
-- Zeigt erweiterte Informationen waehrend der erste Schitte an   --
--------------------------------------------------------------------
print("Lade Ampeldemo-Grundmodelle-main ...")
require 'ak-demo-lua.ampel.Ampeldemo-Grundmodelle-main'

--------------------------------------------------------------------
-- Zeige erweiterte Informationen an                              --
--------------------------------------------------------------------
AkScheduler.debug = false
AkStorage.debug = false
AkAmpel.debug = false
AkKreuzung.debug = false
AkKreuzung.showAnforderungenAlsInfo = false
AkKreuzung.showSchaltungAlsInfo = false

--------------------------------------------------------------------
-- Erste Hilfe - normalerweise nicht notwendig                    --
--------------------------------------------------------------------
-- AkKreuzung.zaehlerZuruecksetzen()





-------------------------------------------------------------------
AkKreuzung.debug = true
KpBetritt(k1_r8)
KpBetritt(k1_r8)
assert(k1_r8.fahrzeuge == 2, k1_r8.anzahlFahrzeuge)
AkKreuzung.zaehlerZuruecksetzen()
assert(k1_r8.fahrzeuge == 0)
-------------------------------------------------------------------
local function run()
    EEPTime = EEPTime + 20
    EEPMain()
end

local function k1Print()
    list = {}
    for k, v in pairs(k1:getSchaltungen()) do table.insert(list, k) end
    table.sort(list, AkKreuzungsSchaltung.hoeherePrioAls)

    for k, v in ipairs(list) do
        print(k .. ": " .. v:getName() .. " - Prio: " .. v:getPrio())
    end
end

for i = 1, 10 do
    print("Betritt Block")
    KpBetritt(k1_r8)
    run()
    run()
    run()
    run()
    print("Verlasse Block")
    KpVerlasse(k1_r8,true)
    run()
end
