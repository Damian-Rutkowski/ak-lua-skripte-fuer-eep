if AkDebugLoad then print("Loading ak.road.CrossingCircuit ...") end

local Lane = require("ak.road.Lane")
local LaneSettings = require("ak.road.LaneSettings")

------------------------------------------------------
-- Klasse Richtungsschaltung (schaltet mehrere Ampeln)
------------------------------------------------------
---@class CrossingCircuit
local CrossingCircuit = {}

function CrossingCircuit.getType() return "CrossingCircuit" end

function CrossingCircuit:getName() return self.name end

function CrossingCircuit:new(name)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.name = name
    o.prio = 0
    o.lanes = {}
    o.richtungenMitAnforderung = {}
    o.pedestrianCrossings = {}
    return o
end

function CrossingCircuit:getAlleRichtungen()
    local alle = {}
    for richtung in pairs(self.lanes) do alle[richtung] = "NORMAL" end
    for richtung in pairs(self.richtungenMitAnforderung) do alle[richtung] = "REQUEST" end
    for richtung in pairs(self.pedestrianCrossings) do alle[richtung] = "PEDESTRIANTS" end
    return alle
end

function CrossingCircuit:getNormaleRichtungen() return self.lanes end

function CrossingCircuit:richtungenAlsTextZeile()
    local s = ""
    for richtung in pairs(self.lanes) do s = s .. ", " .. richtung.name end
    for richtung in pairs(self.richtungenMitAnforderung) do s = s .. ", " .. richtung.name end
    s = s:sub(3)
    return s
end

function CrossingCircuit:getRichtungenMitAnforderung() return self.richtungenMitAnforderung end

function CrossingCircuit:addLane(lane, directions, routes, switchingType)
    assert(lane, "Bitte ein gueltige Richtung angeben")
    self.lanes[lane] = LaneSettings:new(lane, directions, routes, switchingType)
end

function CrossingCircuit:addRichtungMitAnforderung(richtung)
    assert(richtung, "Bitte ein gueltige Richtung angeben")
    richtung:setLaneType(Lane.SchaltungsTyp.ANFORDERUNG)
    self.richtungenMitAnforderung[richtung] = true
end

function CrossingCircuit:addPedestrianCrossing(richtung)
    assert(richtung, "Bitte ein gueltige Richtung angeben")
    richtung:setLaneType(Lane.SchaltungsTyp.FUSSGAENGER)
    self.pedestrianCrossings[richtung] = true
end

function CrossingCircuit:getRichtungFuerFussgaenger() return self.pedestrianCrossings end

--- Gibt alle Richtungen nach Prioritaet zurueck, sowie deren Anzahl und deren Durchschnittspriorit¯t
-- @return sortierteRichtungen, anzahlDerRichtungen, durchschnittsPrio
function CrossingCircuit:nachPrioSortierteRichtungen()
    local sortierteRichtungen = {}
    local anzahlDerRichtungen = 0
    local gesamtPrio = 0
    for richtung in pairs(self.lanes) do
        table.insert(sortierteRichtungen, richtung)
        anzahlDerRichtungen = anzahlDerRichtungen + 1
        gesamtPrio = gesamtPrio + richtung:calculatePriority()
    end
    for richtung in pairs(self.pedestrianCrossings) do
        table.insert(sortierteRichtungen, richtung)
        anzahlDerRichtungen = anzahlDerRichtungen + 1
        gesamtPrio = gesamtPrio + richtung:calculatePriority()
    end
    local durchschnittsPrio = gesamtPrio / anzahlDerRichtungen
    local sortierFunktion = function(richtung1, richtung2)
        if richtung1:calculatePriority() > richtung2:calculatePriority() then
            return true
        elseif richtung1:calculatePriority() < richtung2:calculatePriority() then
            return false
        end
        return (richtung1.name < richtung2.name)
    end
    table.sort(sortierteRichtungen, sortierFunktion)
    self.prio = durchschnittsPrio
    return sortierteRichtungen, anzahlDerRichtungen, durchschnittsPrio
end

------ Gibt alle Richtungen nach Name sortiert zurueck
-- @return sortierteRichtungen
function CrossingCircuit:nachNameSortierteRichtungen()
    local sortierteRichtungen = {}
    for richtung in pairs(self.lanes) do table.insert(sortierteRichtungen, richtung) end
    for richtung in pairs(self.richtungenMitAnforderung) do table.insert(sortierteRichtungen, richtung) end
    for richtung in pairs(self.pedestrianCrossings) do table.insert(sortierteRichtungen, richtung) end
    local sortierFunktion = function(richtung1, richtung2) return (richtung1.name < richtung2.name) end
    table.sort(sortierteRichtungen, sortierFunktion)
    return sortierteRichtungen
end

--- Gibt zurueck ob schaltung1 eine hoehere Prioritaet hat, als Schaltung 2
-- @param schaltung1 erste Schaltung
-- @param schaltung2 zweite Schaltung
--
function CrossingCircuit.hoeherePrioAls(schaltung1, schaltung2)
    if schaltung1 and schaltung2 then
        local _, tableSize1, avg1 = schaltung1:nachPrioSortierteRichtungen()
        local _, tableSize2, avg2 = schaltung2:nachPrioSortierteRichtungen()

        if avg1 > avg2 then
            return true
        elseif avg1 < avg2 then
            return false
        end

        if tableSize1 > tableSize2 then
            return true
        elseif tableSize1 < tableSize2 then
            return false
        end

        return (schaltung1.name > schaltung2.name)
    end
end

function CrossingCircuit:calculatePriority()
    local _, _, prio = self:nachPrioSortierteRichtungen()
    return prio
end

function CrossingCircuit:resetWaitCount() for richtung in pairs(self.lanes) do richtung:resetWaitCount() end end

return CrossingCircuit
