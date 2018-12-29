Lucene.players = {}
Lucene.players.checkingHonors = false
Lucene.players.currentlyChecking = nil
Lucene.players.gagHonors = false
Lucene.players.pendingName = nil
Lucene.players.playerCache = {}
Lucene.players.playerTriggers = {}

function Lucene.players:addPlayer(name)
    local newPlayerDto = {}

    for k, v in pairs(PlayerSchema) do
        if k:sub(1, 1) ~= "_" then
            newPlayerDto[k] = v
        end
    end

    local newPlayer = Lucene.objects.player:new(newPlayerDto)
    newPlayer:name(name)

    local res, error = db:add(Lucene.db.players, newPlayer.context)

    if error then Lucene.error(debug.getinfo(1), error) end
    
    local player = self:getPlayer(newPlayer:name())

    -- Set a new color trigger
    Lucene.players:setColorTrigger(player)
    return player
end

function Lucene.players:finishCheck()
    self:save(Lucene.players.currentlyChecking)
    Lucene.players.checkingHonors = false

    local lowerName = Lucene.players.currentlyChecking:name():lower()

    downloadFile(
        Lucene.getPath(("temp/%s.json"):format(lowerName)),
        ("https://www.starmourn.com/api/characters/%s.json"):format(lowerName)
    )
    Lucene.players.currentlyChecking = nil
end

function Lucene.players.finishDownload(_, fileLocation)
    if not fileLocation:find("(%a+)%.json") then return end

    local fileHandle, error = io.open(fileLocation, "r")

    if not fileHandle then
        Lucene.debug(error)
        return
    end

    local jsonString = fileHandle:read("*a")
    fileHandle:close()
    os.remove(fileLocation)

    local data = yajl.to_value(jsonString)
    local player = Lucene.players:getPlayer(data.name)

    player:explorer(data.explorer)
    player:class(data.class)
    player:age(data.age)
    player:race(data.race)
    player:level(data.level)
    player:faction(data.faction)
    player:fullname(data.fullname)

    Lucene.players:save(player)
end
registerAnonymousEventHandler("sysDownloadDone", "Lucene.players.finishDownload")

function Lucene.players:getByFullname(fullname)
    return fullname
end

function Lucene.players:getPlayer(name)
    -- Camelcase it
    name = name:sub(1,1):upper()..name:sub(2)

    if Lucene.players.playerCache[name] then
        return Lucene.players.playerCache[name]
    end

    local res = db:fetch(Lucene.db.players, db:eq(Lucene.db.players.name, name))

    if not res or not res[1] then
        return self:addPlayer(name)
    end

    return Lucene.objects.player:new(res[1])
end

function Lucene.players.loadNames()
    local res = db:fetch(Lucene.db.players)

    for _, dbPlayer in ipairs(res) do
        local player = Lucene.players:getPlayer(dbPlayer.name)
        Lucene.players.playerCache[player:name()] = player
        Lucene.players:setColorTrigger(player)
    end
end
registerAnonymousEventHandler("Lucene.bootstrap", "Lucene.players.loadNames")

function Lucene.players:save(player)
    Lucene.players.playerCache[player:name()] = player
    local res, error = db:update(Lucene.db.players, player.context)
    if error then Lucene.error(debug.getinfo(1), error) end
end

function Lucene.players:setColorTrigger(player)
    if Lucene.players.playerTriggers[player:name()] then
        killTrigger(Lucene.players.playerTriggers[player:name()])
    end

    Lucene.players.playerTriggers[player:name()] = tempTrigger(player:name(), function()
        selectString(player:name(), 1)
        fg(player:color())
        resetFormat()
    end)
end

function Lucene.players:startCheck(playerName)
    Lucene.players.currentlyChecking = self:getPlayer(playerName)
end