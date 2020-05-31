-- describe("LaneQueue", function()
--     insulate("Sample1", function()
--         require("ak.core.eep.AkEepFunktionen")
--         local Lane = require("ak.road.Lane")
--         local TrafficLight = require("ak.road.TrafficLight")
--         local TrafficLightModel = require("ak.road.TrafficLightModel")
--         local k1Lane1Signal = TrafficLight:new(22, TrafficLightModel.Unsichtbar_2er);
--         local k1K1 = TrafficLight:new(23, TrafficLightModel.JS2_3er_mit_FG);
--         local k1K2 = TrafficLight:new(24, TrafficLightModel.JS2_3er_mit_FG);
--         local k1K3 = TrafficLight:new(25, TrafficLightModel.JS2_2er_nur_FG);
--         -- create a new lane and add the traffic light, which is used for switching the lane's traffic
--         local lane1 = Lane:new("Fahrspur 1", 1, {k1Lane1Signal})
--         local lane1queue1 = lane1:createQueueDefault(k1K1, k1K2)
--         local lane1queue2 = lane1:createQueueOnRoute("matching route", k1K1, k1K2)
--         local lane1queue3 = lane1:createQueueOnRoute("other route", k1K1, k1K3)
--         local trainName = "#Car1"
--         EEPSetTrainRoute("#Car1", "matching route")
--         lane1:vehicleEntered(trainName)
--         it("queue1 count is 1 (default)", function() assert.equals(1, lane1queue1:getCount()) end)
--         it("queue2 count is 1 (matching route)", function() assert.equals(1, lane1queue2:getCount()) end)
--         it("queue3 count is 0 (other route)", function() assert.equals(0, lane1queue3:getCount()) end)
--     end)
-- end)
-- -- API Example
-- describe("Crossing", function()
--     insulate("Sample2", function()
--         require("ak.core.eep.AkEepFunktionen")
--         local CrossingCircuit = require("ak.road.CrossingCircuit")
--         local Crossing = require("ak.road.Crossing")
--         local Lane = require("ak.road.Lane")
--         local TrafficLight = require("ak.road.TrafficLight")
--         local TrafficLightModel = require("ak.road.TrafficLightModel")
--         local k1Lane1Signal = TrafficLight:new(22, TrafficLightModel.Unsichtbar_2er);
--         local k1K1 = TrafficLight:new(23, TrafficLightModel.JS2_3er_mit_FG);
--         local k1K2 = TrafficLight:new(24, TrafficLightModel.JS2_3er_mit_FG);
--         local k1K3 = TrafficLight:new(25, TrafficLightModel.JS2_2er_nur_FG);
--         -- create a new lane and add the traffic light, which is used for switching the lane's traffic
--         local lane1 = Lane:new("Fahrspur 1", 1, {k1Lane1Signal}, {Lane.Directions.STRAIGHT, Lane.Directions.RIGHT})
--         local lane1queue1 = lane1:addTrafficLights(k1K1, k1K2)
--         local lane1queue2 = lane1:addDirectionalTrafficLight(Lane.Directions.RIGHT, "Matching Route", k1K3)
--         local c1Circuit1 = CrossingCircuit:new("Bahnhofstra�e - gerade")
--         c1Circuit1:addRichtungMitAnforderung(lane1queue1)
--         c1Circuit1:addRichtungMitAnforderung(lane1queue2)
--         local c1Circuit2 = CrossingCircuit:new("Bahnhofstra�e - Abbieger")
--         local c1Circuit3 = CrossingCircuit:new("Hauptstr - gerade")
--         local c1Circuit4 = CrossingCircuit:new("Hauptstr - Abbieger")
--         local crossing1 = Crossing:new("Bahnhofsstr. - Hauptstr.")
--         crossing1:fuegeSchaltungHinzu(c1Circuit1)
--         crossing1:fuegeSchaltungHinzu(c1Circuit2)
--         crossing1:fuegeSchaltungHinzu(c1Circuit3)
--         crossing1:fuegeSchaltungHinzu(c1Circuit4)
--     end)
-- end)
-- -- API Example
-- describe("Crossing - Queues - Traffic Lights", function()
--     insulate("Sample2", function()
--         require("ak.core.eep.AkEepFunktionen")
--         require("ak.road.CrossingCircuit")
--         local Crossing = require("ak.road.Crossing")
--         local Lane = require("ak.road.Lane")
--         local TrafficLight = require("ak.road.TrafficLight")
--         local TrafficLightModel = require("ak.road.TrafficLightModel")
--         local k1Lane1Signal = TrafficLight:new(22, TrafficLightModel.Unsichtbar_2er);
--         local k1K1 = TrafficLight:new(23, TrafficLightModel.JS2_3er_mit_FG);
--         local k1K2 = TrafficLight:new(24, TrafficLightModel.JS2_3er_mit_FG);
--         local k1K3 = TrafficLight:new(25, TrafficLightModel.JS2_2er_nur_FG);
--         local k1Lane2Signal = TrafficLight:new(26, TrafficLightModel.Unsichtbar_2er);
--         -- Erzeugt eine neue Kreuzung
--         local crossing1 = Crossing:new("Bahnhofsstr. - Hauptstr.")
--         -- Erzeugt eine neue Fahrspur (jede Fahrspur hat Richtungen f�r die Anzeige und einen Typ: Auto / Tram)
--         local lane1 = crossing1:newLane("Fahrspur 1 - gerade + rechts", 1, k1Lane1Signal,
--                                         {Lane.Directions.STRAIGHT, Lane.Directions.RIGHT})
--         -- Das erste Fahrzeug in einer Fahrsprur kann fahren, wenn die Ampel f�r dieses Fahrzeug gr�n geschaltet wurde
--         -- Ampeln gelten ENTWEDER
--         -- * f�r die komplette Fahrspur (alle Fahrzeuge k�nnen fahren) ODER
--         -- * f�r einzelne Fahrzeuge der Fahrspur (nur wenn )
--         -- * aktiv  (wenn Anforderungen vorliegen, oder nach Zeit)
--         -- * nur nach Anforderung durch bestimmte Fahrzeuge
--         -- * passiv (wenn sie in einer anderen Schaltung vorkommt)
--         local lane1StraightAndRight = lane1:newCircuit({k1K1}, {Lane.Directions.STRAIGHT, Lane.Directions.RIGHT}, {})
--         local lane1Right = lane1:newCircuit({k1K2}, {Lane.Directions.RIGHT}, {"Matching Route"}, Lane.Type.Passive)
--         -- Fahrspur 2
--         local lane2 = crossing1:newLane("Fahrspur 2 - Linksabbieger + Tram geradeaus + Tram links", 2, k1Lane2Signal,
--                                         {Lane.Directions.LEFT}, {Lane.Type.CAR, Lane.Type.TRAM})
--         local lane2Left = lane1:newCircuit({k1K2}, {Lane.Directions.LEFT})
--         local lange2TramStraight = lane1:newCircuit({k1K3}, {Lane.Directions.STRAIGHT}, {"TRAM STRAIGHT"},
--                                                     Lane.Type.OnRequest)
--         -- Fu�g�ngerquerung 1
--         local pedCross1 = crossing1:newPedestrianCrossing("Furt 1", 2, k1K1, k1K2)
--         local pci1 = crossing1:newCircuit()
--         -- Fu�g�ngerquerung 2
--         local pedCross2 = crossing1:newPedestrianCrossing("Furt 2", 2, k1K1, k1K2)
--         local pci2 = crossing1:newCircuit()
--         -- Hier werden alle zusammengeh�renden Schaltungen der einzelnen Fahrspuren geschaltet
--         local circuitSwitching1 = crossing1.addCircuitSwitching("FS1 und FS2 komplett", lane1StraightAndRight,
--                                                                 lane1Right, lane2Left, lange2TramStraight)
--         local circuitSwitching2 = crossing1.addCircuitSwitching("FS2 nur Tram gradeaus", lange2TramStraight)
--         local circuitSwitching3 = crossing1.addCircuitSwitching("FS2 nur Verkehr links ", lane2Left)
--         -- Hier werden alle blinkenden Ampeln angegeben:
--         local offSwitching = crossing1.addOffSwitching("Aus - mit blinkenden Ampeln", k1K3)
--         print(lane1, lane2, pedCross1, pedCross2, pci1, pci2, circuitSwitching1, circuitSwitching2, circuitSwitching3,
--               offSwitching)
--     end)
-- end)
