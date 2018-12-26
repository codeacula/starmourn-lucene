Lucene.player = {
    commandQueue = {},
    sentBalance = false,
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

function Lucene.player.updateGmcp()
    local vits = gmcp.Char.Vitals
    
    Lucene.player:setBalance(vits.bal)
    Lucene.player.stats.class = vits.class or Lucene.player.stats.class
    Lucene.player.stats.em = tonumber(vits.em) or Lucene.player.stats.em
    Lucene.player.stats.hp = tonumber(vits.hp) or Lucene.player.stats.hp
    Lucene.player.stats.internal = tonumber(vits.internal) or Lucene.player.stats.internal
    Lucene.player.stats.maxhp = tonumber(vits.maxhp) or Lucene.player.stats.maxhp
    Lucene.player.stats.maxpt = tonumber(vits.maxpt) or Lucene.player.stats.maxpt
    Lucene.player.stats.mind = tonumber(vits.mind) or Lucene.player.stats.mind
    Lucene.player.stats.muscular = tonumber(vits.muscular) or Lucene.player.stats.muscular
    Lucene.player.stats.pt = tonumber(vits.pt) or Lucene.player.stats.pt
    Lucene.player.stats.sensory = tonumber(vits.sensory) or Lucene.player.stats.sensory
    Lucene.player.stats.wetwiring = tonumber(vits.wetwiring) or Lucene.player.stats.wetwiring
    Lucene.player.stats.ww = tonumber(vits.ww) or Lucene.player.stats.ww
    Lucene.player.stats.xp = tonumber(vits.xp) or Lucene.player.stats.xp

    Lucene.player:checkQueue()
end
registerAnonymousEventHandler("gmcp.Char.Vitals", "Lucene.player.updateGmcp")