Lucene.spaceship = {}
Lucene.spaceship.nearby = {}

function Lucene.spaceship:addNearby(xpos, ypos, dist, direction, desc)
    local newTarget = self:createTarget(xpos, ypos, dist, direction, desc)

    table.insert(Lucene.spaceship.nearby, newTarget)
    self:sortNearby()
    raiseEvent("Lucene.shipsUpdated")
end

function Lucene.spaceship:createTarget(xpos, ypos, dist, direction, desc)
    local newTarget = {
        direction = direction,
        display = desc,
        distance = tonumber(dist),
        id = 0,
        name = "",
        player = "",
        type = "Tr",
        weight = 999,
        xpos = tonumber(xpos),
        ypos = tonumber(ypos),
    }

    if desc:find("the Satellite") then
        newTarget.type = "Sa"
        newTarget.name = desc:gsub("the Satellite ", "")
        newTarget.display = newTarget.name
        return newTarget
    end

    if desc:find("the Planet") then
        newTarget.type = "Pl"
        _, _, newTarget.name = desc:find("the Planet (%a+).*")
        newTarget.display = newTarget.name
        return newTarget
    end

    if desc:find("a station") then
        newTarget.type = "St"
        _, _, newTarget.name = desc:find("a station %- (.*) Station.*")
        newTarget.display = newTarget.name
        return newTarget
    end

    if desc:find("Ship #(%d+)%((.-)%) %- (.*)") then
        newTarget.type = "Sh"
        _, _, id, playerName, shipName = desc:find("Ship #(%d+)%((.-)%) %- (.*)")
        newTarget.id = tonumber(id)
        newTarget.player = Lucene.players:get(playerName)
        newTarget.name = shipName
        newTarget.display = newTarget.player
        newTarget.weight = 10
        return newTarget
    end

    if desc:find("Ship #(%d+) %- (.*)") then
        newTarget.type = "Ot"
        _, _, id, shipName = desc:find("Ship #(%d+) %- (.*)")
        newTarget.id = tonumber(id)
        newTarget.name = shipName
        newTarget.display = shipName
        newTarget.weight = 5
        return newTarget
    end

    if desc:find("Platform#(%d+) %- (.*)") then
        newTarget.type = "Ot"
        _, _, id, shipName = desc:find("Platform#(%d+) %- (.*)")
        newTarget.id = tonumber(id)
        newTarget.name = shipName
        newTarget.display = shipName
        newTarget.weight = 5
        return newTarget
    end

    if desc:find("a mineable asteroid %(#(%d+)%)") then
        newTarget.type = "Ot"
        _, _, id = desc:find("a mineable asteroid %(#(%d+)%)")
        newTarget.id = tonumber(id)
        newTarget.name = "a mineable asteroid"
        newTarget.display = "asteroid"
        newTarget.weight = 5
        return newTarget
    end

    newTarget.type = "Uk"
    newTarget.id = 0
    newTarget.name = desc
    return newTarget
end

function Lucene.spaceship.move(dist, dir)
    send(("ship travel %s %s"):format(dir, dist))
end

function Lucene.spaceship:resetNearby()
    Lucene.spaceship.nearby = {}
    raiseEvent("shipsUpdated")
end

function Lucene.spaceship:sortNearby()
    table.sort(Lucene.spaceship.nearby, function(a, b)
        if a.weight == b.weight then
            return a.name < b.name
        end

        return a.weight < b.weight
    end)
end

function Lucene.spaceship.target(id)
    send("ship target "..id)
end

--[[

Pl - Planet
Sh - Ship
Sa - Satellite
St - Station
Ot - Other Targetable
As - Asteroid
Uk - Unknown

 ship probe 
The ship launches a probe towards the asteroid.
The probe reports a source of Isotropic Duramine, good for 4 refining batches.
]]--