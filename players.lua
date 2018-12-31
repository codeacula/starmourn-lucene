Lucene.players = {}
Lucene.players.checkingHonors = false
Lucene.players.currentlyChecking = nil
Lucene.players.gagHonors = false
Lucene.players.here = {}
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
    self:setColorTrigger(player)
    return player
end

function Lucene.players:finishCheck()
    self:save(self.currentlyChecking)
    self.checkingHonors = false

    local lowerName = self.currentlyChecking:name():lower()

    downloadFile(
        Lucene.getPath(("temp/%s.json"):format(lowerName)),
        ("https://www.starmourn.com/api/characters/%s.json"):format(lowerName)
    )
    self.currentlyChecking = nil
end

function Lucene.players:finishDownload(fileLocation)
    if not fileLocation:find("(%a+)%.json") or fileLocation:find("all_online") then return end

    local fileHandle, error = io.open(fileLocation, "r")

    if not fileHandle then
        Lucene.debug(error)
        return
    end

    local jsonString = fileHandle:read("*a")
    fileHandle:close()
    os.remove(fileLocation)

    local data = yajl.to_value(jsonString)
    local player = self:getPlayer(data.name)

    player:explorer(data.explorer)
    player:class(data.class)
    player:age(data.age)
    player:race(data.race)
    player:level(data.level)
    player:faction(data.faction)
    player:fullname(data.fullname)

    self:save(player)
end
Lucene.callbacks.register("sysDownloadDone", function(fileLocation) Lucene.players:finishDownload(fileLocation) end)

function Lucene.players:getByFullname(fullname)
    return fullname
end

function Lucene.players:getPlayer(name)
    -- Camelcase it
    name = name:sub(1,1):upper()..name:sub(2)

    if self.playerCache[name] then
        return self.playerCache[name]
    end

    local res = db:fetch(Lucene.db.players, db:eq(Lucene.db.players.name, name))

    if not res or not res[1] then
        return self:addPlayer(name)
    end

    return Lucene.objects.player:new(res[1])
end

function Lucene.players:loadNames()
    local res = db:fetch(Lucene.db.players)

    for _, dbPlayer in ipairs(res) do
        local player = self:getPlayer(dbPlayer.name)
        self.playerCache[player:name()] = player
        self:setColorTrigger(player)
    end
end
Lucene.callbacks.register("Lucene.bootstrap", function() Lucene.players:loadNames() end)

function Lucene.players:playerEntered()
    local player = self:getPlayer(gmcp.Room.AddPlayer.name)
    table.insert(self.here, player)
end
Lucene.callbacks.register("gmcp.Room.AddPlayer", function() Lucene.players:playerEntered() end)

function Lucene.players:playerLeft()
    for i = #self.here, 1, -1 do
        if self.here[i]:name() == gmcp.Room.RemovePlayer then
            table.remove(self.here, i)
        end
    end
end
Lucene.callbacks.register("gmcp.Room.RemovePlayer", function() Lucene.players:playerLeft() end)

function Lucene.players:processCharacterList(fileLocation)
    if not fileLocation:find("all_online") then return end

    local fileHandle, error = io.open(fileLocation, "r")

    if not fileHandle then
        Lucene.debug(error)
        return
    end

    local jsonString = fileHandle:read("*a")
    fileHandle:close()
    os.remove(fileLocation)

    local data = yajl.to_value(jsonString)
    
    for _, group in ipairs(data.characters) do
        
        downloadFile(
            Lucene.getPath(("temp/%s.json"):format(group.name)),
            ("https://www.starmourn.com/api/characters/%s.json"):format(group.name)
        )
    end
end
Lucene.callbacks.register("sysDownloadDone", function(fileLocation) Lucene.players:processCharacterList(fileLocation) end)

function Lucene.players:processHere()
    for _, gmcpPlayer in ipairs(gmcp.Room.Players) do
        local player = self:getPlayer(gmcpPlayer.name)
        table.insert(self.here, player)
    end
end
Lucene.callbacks.register("gmcp.Room.Players", function() Lucene.players:processHere() end)

function Lucene.players:processOnline()
    downloadFile(
        Lucene.getPath(("temp/all_online.json"):format(lowerName)),
        ("https://www.starmourn.com/api/characters.json"):format(lowerName)
    )
end

function Lucene.players:save(player)
    self.playerCache[player:name()] = player
    local res, error = db:update(Lucene.db.players, player.context)
    if error then Lucene.error(debug.getinfo(1), error) end
end

function Lucene.players:setColorTrigger(player)
    if self.playerTriggers[player:name()] then
        killTrigger(self.playerTriggers[player:name()])
    end

    self.playerTriggers[player:name()] = tempTrigger(player:name(), function()
        selectString(player:name(), 1)
        fg(player:color())
        resetFormat()
    end)
end

function Lucene.players:startCheck(playerName)
    self.currentlyChecking = self:getPlayer(playerName)
end