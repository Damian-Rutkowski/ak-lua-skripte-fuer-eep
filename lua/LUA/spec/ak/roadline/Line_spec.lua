insulate("Line Management", function()
    require("ak.core.eep.EepSimulator")
    local Train = require("ak.train.Train")
    local Line = require("ak.roadline.Line")
    local RoadStation = require("ak.roadline.RoadStation")

    -- Station definition
    local sMesseDresden = RoadStation:new("Messe Dresden", -1)
    local sFeuerwehrGasse = RoadStation:new("Feuerwehrgasse", -1)
    local sHauptbahnhof = RoadStation:new("Hauptbahnhof", -1)
    local sStriesen = RoadStation:new("Striesen", -1)


    -- Route definition
    local line10 = Line:new({nr = "1a"})
    local l10Striesen = line10:newRoute("10 Striesen")
    l10Striesen:addStation(sMesseDresden, 1)
    l10Striesen:addStation(sFeuerwehrGasse, 1, 2)
    l10Striesen:addStation(sHauptbahnhof, 1, 2)
    l10Striesen:addStation(sStriesen, 1, 3)


    local l10MesseDresden = line10:newRoute("10 Messe Dresden")
    l10MesseDresden:addStation(sStriesen, 2, 0)
    l10MesseDresden:addStation(sHauptbahnhof, 2, 3)
    l10MesseDresden:addStation(sFeuerwehrGasse, 2, 2)
    l10MesseDresden:addStation(sMesseDresden, 2)

    -- Check route
    it("Station 1", function() assert.equals("Messe Dresden", l10Striesen:getFirstStation().name) end)
    it("Station 4", function() assert.equals("Striesen", l10Striesen:getLastStation().name) end)

    it("", function() assert.equals("2", sHauptbahnhof.routes[l10MesseDresden.routeName].platform) end)
    it("", function() assert.equals("1", sHauptbahnhof.routes[l10Striesen.routeName].platform) end)
    it("", function() assert.equals("2", sFeuerwehrGasse.routes[l10MesseDresden.routeName].platform) end)
    it("", function() assert.equals("1", sFeuerwehrGasse.routes[l10Striesen.routeName].platform) end)

    -- Check reverse route
    it("Station 1", function() assert.equals("Striesen", l10MesseDresden:getFirstStation().name) end)
    it("Station 4", function() assert.equals("Messe Dresden", l10MesseDresden:getLastStation().name) end)

    -- add contact-point functions
    local function stationArrivalPlanned(trainName, station, timeInMinutes)
        assert(type(trainName) == "string", "Need 'trainName' as string")
        assert(type(station) == "table", "Need 'station' as table")
        assert(station.type == "RoadStation", "Provide 'station' as 'RoadStation'")
        assert(type(timeInMinutes) == "number", "Need 'timeInMinutes' as number")

        Line.scheduleDeparture(trainName, station, timeInMinutes)
    end

    local function stationLeft(trainName, station)
        assert(type(trainName) == "string", "Need 'trainName' as string")
        assert(type(station) == "table", "Need 'station' as table")
        assert(station.type == "RoadStation", "Provide 'station' as 'RoadStation'")

        Line.trainDeparted(trainName, station)
    end

    local function changeDestination(trainName, station, departureTime)
        assert(type(trainName) == "string", "Need 'trainName' as string")
        assert(type(station) == "table", "Need 'station' as table")
        assert(station.type == "RoadStation", "Provide 'station' as 'RoadStation'")
        if departureTime then
            assert(type(departureTime) == "number", "Need 'departureTime' as number")
        end

        Line.changeRoute(trainName, station, departureTime)
    end

    Line.addRouteChange(sStriesen, l10Striesen, l10MesseDresden, line10)
    Line.addRouteChange(sMesseDresden, l10MesseDresden, l10Striesen, line10)

    -- Create a new train
    local trainName = "#Train 1"
    Train.forName("#Train 1"):setRoute(l10MesseDresden.routeName)

    -- Prepare to use route 1
    --line10:prepareDepartureAt(trainName, l10MesseDresden, 10)-- The following stations are informed
    changeDestination(trainName, sMesseDresden)

    -- Drive through route 1 by contacts
    stationLeft(trainName, sMesseDresden)
    stationArrivalPlanned(trainName, sFeuerwehrGasse, 3)
    stationArrivalPlanned(trainName, sFeuerwehrGasse, 2)
    stationArrivalPlanned(trainName, sFeuerwehrGasse, 1)
    stationArrivalPlanned(trainName, sFeuerwehrGasse, 0)
    stationLeft(trainName, sFeuerwehrGasse)
    stationArrivalPlanned(trainName, sHauptbahnhof, 0)
    stationLeft(trainName, sHauptbahnhof)
    stationArrivalPlanned(trainName, sStriesen, 0)
    stationLeft(trainName, sStriesen)

    -- Prepare to use route 2
    --line10:prepareDepartureAt(trainName, l10Striesen, 10)-- The following stations are informed
    changeDestination(trainName, sStriesen)

    -- Drive through route 2 by contacts

    stationArrivalPlanned(trainName, sStriesen, 0)
    stationLeft(trainName, sStriesen)
    stationArrivalPlanned(trainName, sHauptbahnhof, 0)
    stationLeft(trainName, sHauptbahnhof)
    stationArrivalPlanned(trainName, sFeuerwehrGasse, 3)
    stationArrivalPlanned(trainName, sFeuerwehrGasse, 2)
    stationArrivalPlanned(trainName, sFeuerwehrGasse, 1)
    stationArrivalPlanned(trainName, sFeuerwehrGasse, 0)
    stationLeft(trainName, sFeuerwehrGasse)
    stationArrivalPlanned(trainName, sMesseDresden, 0)
    stationLeft(trainName, sMesseDresden)

end)