Lucene.player = {
    commandQueue = {},
    sentBalance = false,
    skills = {},
    timeoutHandle = nil,
    timeoutPeriod = 3
}
Lucene.player.stats = {
    bal = 0,
    class = "",
    em = 0,
    hp = 0,
    internal = 0,
    maxhp = 0,
    maxpt = 0,
    mind = 0,
    muscular = 0,
    pt = 0,
    sensory = 0,
    stim = 0,
    wetwiring = 0,
    ww = 1,
    xp = 0
}

function Lucene.player:cancelBalanceTimer()
    if not self.timeoutHandle then return end

    killTimer(self.timeoutHandle)
    self.timeoutHandle = nil
end

function Lucene.player:checkQueue()
    if not self:haveCommandBal() or #self.commandQueue == 0 then
        return
    end

    local command = table.remove(self.commandQueue, 1)
    self:send(command)
end

function Lucene.player:enqueue(command)
    -- At the queue to the queue table
    table.insert(self.commandQueue, commad)
end

function Lucene.player:giveBalance(balanceName)
    self.stats[balanceName] = 1

    raiseEvent("Lucene."..balanceName..".give")
end

function Lucene.player:handleGroup()
    local name = gmcp.Char.Skills.List.group
    self.skills[name] = {}

    for _, skill in ipairs(gmcp.Char.Skills.List.list) do
        self.skills[name][skill] = true
    end
end
Lucene.callbacks.register("gmcp.Char.Skills.List", function() Lucene.player:handleGroup() end)

function Lucene.player:hasSkill(skillName, skillGroup)
    if skillGroup then
        if Lucene.player.skills[skillGroup] and Lucene.player.skills[skillGroup][skillName] then
            return true
        end

        return false
    end

    for groupName, skills in pairs(Lucene.player.skills) do
        if skills[skillName] then return true end
    end

    return false
end

function Lucene.player:haveCommandBal()
    if self.stats.bal == 0 or self.sentBalance == true then
        return false
    end

    return true
end

function Lucene.player:resetBalance()
    self.sentBalance = false
    self:cancelBalanceTimer()
end

function Lucene.player:requestSkills()
    for _, group in ipairs(gmcp.Char.Skills.Groups) do
        sendGMCP([[Char.Skills.Get { "group": "]]..group.name..[["}]])
    end
end
Lucene.callbacks.register("gmcp.Char.Skills.Groups", function() Lucene.player:requestSkills() end)

function Lucene.player:send(command, ...)
    Lucene.send(command, unpack(arg))
    self.sentBalance = true
    self:startBalanceTimer()
end

function Lucene.player:setBalance(val)
    val = tonumber(val)
    if val == self.stats.bal then
        return
    end

    self.stats.bal = val
    self:resetBalance()
    
    if val == 1 then
        raiseEvent("Lucene.balance.given")
    else
        raiseEvent("Lucene.balance.taken")
    end
end

function Lucene.player:startBalanceTimer()
    self.timeoutHandle = tempTimer(self.timeoutPeriod, function() Lucene.player:resetBalance() end)
end

function Lucene.player:takeBalance(balanceName)
    self.stats[balanceName] = 0

    raiseEvent("Lucene."..balanceName..".take")
end

function Lucene.player:updateGmcp()
    local vits = gmcp.Char.Vitals
    self:setBalance(vits.bal)
    self.stats.class = vits.class or self.stats.class
    self.stats.em = tonumber(vits.em) or self.stats.em
    self.stats.hp = tonumber(vits.hp) or self.stats.hp
    self.stats.internal = tonumber(vits.internal) or self.stats.internal
    self.stats.maxhp = tonumber(vits.maxhp) or self.stats.maxhp
    self.stats.maxpt = tonumber(vits.maxpt) or self.stats.maxpt
    self.stats.mind = tonumber(vits.mind) or self.stats.mind
    self.stats.muscular = tonumber(vits.muscular) or self.stats.muscular
    self.stats.pt = tonumber(vits.pt) or self.stats.pt
    self.stats.sensory = tonumber(vits.sensory) or self.stats.sensory
    self.stats.wetwiring = tonumber(vits.wetwiring) or self.stats.wetwiring
    self.stats.ww = tonumber(vits.ww) or self.stats.ww
    self.stats.xp = tonumber(vits.xp) or self.stats.xp

    self:checkQueue()
end
Lucene.callbacks.register("gmcp.Char.Vitals", function() Lucene.player:updateGmcp() end)