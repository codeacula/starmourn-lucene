local Player = {
    context = {}
}

Player.__index = Player

Player.__lt = function(playera, playerb)
    if playera:weight() ~= playerb:weight() then
        return playera:weight() < playerb:weight()
    end

    return playera:name() < playerb:name()
end

function Player:addDeath()
    self:deaths(self:deaths() + 1)
end

function Player:addKill()
    self:kills(self:kills() + 1)
end

function Player:age(val)
    if val == nil then return self.context.age end

    self.context.age = tonumber(val)
end

function Player:ally(val)
    if val == nil then return ntob(self.context.ally) end

    self.context.ally = bton(val)
end

function Player:caprank(val)
    if val == nil then return self.context.caprank end

    self.context.caprank = tonumber(val)
end

function Player:class(val)
    if val == nil then return self.context.class end

    self.context.class = val
end

function Player:color()
    local choiceColor = self:faction()
    if self:enemy() then choiceColor = "Enemy" end
    if self:faction() == "N/A" then choiceColor = "None" end

    if not color_table[choiceColor] then
        choiceColor = "None"
    end

    return choiceColor
end

function Player:deaths(val)
    if val == nil then return self.context.deaths end

    self.context.deaths = tonumber(val)
end

function Player:enemy(val)
    if val == nil then return ntob(self.context.enemy) end

    self.context.enemy = bton(val)
end

function Player:explorer(val)
    if val == nil then return self.context.explorer end

    self.context.explorer = tonumber(val)
end

function Player:faction(val)
    if val == nil then return self.context.faction end

    self.context.faction = val
end

function Player:factionRank(val)
    if val == nil then return self.context.factionRank end

    self.context.factionRank = val
end

function Player:fullname(val)
    if val == nil then return self.context.fullname end

    self.context.fullname = val
end

function Player:gender(val)
    if val == nil then return self.context.gender end

    self.context.gender = val
end

function Player:honrank(val)
    if val == nil then return self.context.honrank end

    self.context.honrank = tonumber(val)
end

function Player:identifier()
    return self.context.name
end

function Player:kills(val)
    if val == nil then return self.context.kills end

    self.context.kills = tonumber(val)
end

function Player:lawless(val)
    if val == nil then return self.context.lawless end

    self.context.lawless = val
end

function Player:level(val)
    if val == nil then return self.context.level end

    self.context.level = tonumber(val)
end

function Player:married(val)
    if val == nil then return self.context.married end

    self.context.married = val
end

function Player:motto(val)
    if val == nil then return self.context.motto end

    self.context.motto = val
end

function Player:name(val)
    if val == nil then return self.context.name end

    self.context.name = val
end

function Player:new(dbItem)
    local newPlayer = {}
    setmetatable(newPlayer, self)

    newPlayer.context = dbItem

    return newPlayer
end

function Player:race(val)
    if val == nil then return self.context.race end

    self.context.race = val
end

function Player:weight()
    if self:enemy() then return 2 end
    if self:ally() == 1 then return 1 end

    if Lucene.settings.factionWeights[self:faction()] then
        return Lucene.settings.factionWeights[self:faction()]
    end

    return 999
end

function Player:xprank(val)
    if val == nil then return self.context.xprank end

    self.context.xprank = tonumber(val)
end

Lucene.objects.player = Player