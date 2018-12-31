Lucene.hunter = {}
Lucene.hunter.attackCommand = "kill %s"
Lucene.hunter.attackList = {}
Lucene.hunter.attacking = false
Lucene.hunter.autoAttack = false
Lucene.hunter.hunting = false
Lucene.hunter.maxWeight = 25
Lucene.hunter.mobCache = {}
Lucene.hunter.shouldStun = false
Lucene.hunter.stunCommand = "bot harass %s"

-- Add mob by specific identifier or shortname
function Lucene.hunter:add(identifier, weight)
    local id = tonumber(identifier)

    if id then identifier = id end

    -- If it exists, don't add again
    if self.mobCache[identifier] then
        Lucene.warn(("Already have %s in the system"))
        return
    end

    weight = weight or self.maxWeight

    local newTarget = Lucene.huntTargets:create(identifier, weight)

    self.mobCache[identifier] = newTarget
    Lucene.say(("<LuceneSuccess>Added <red>%s <LuceneSuccess>with weight <red>%s<reset>"):format(identifier, weight))
    raiseEvent("Lucene.hunterUpdated")
end

function Lucene.hunter:activate(flag)
    if flag == self.hunting then
        return
    end

    if flag == nil then
        flag = not self.hunting
    end

    self.hunting = flag

    if flag then
        Lucene.success("Beginning the hunt.")
        self.mobList()
    else
        Lucene.danger("The hunt has ended.")
    end
end

function Lucene.hunter:adjustWeight(identifier, weight)
    local mob = self.mobCache[identifier]

    if not mob then
        self:add(identifier, weight)
        return
    end

    mob:weight(weight)
    Lucene.huntTargets:update(mob)
    raiseEvent("Lucene.hunterUpdated")
end

function Lucene.hunter:attack(startAttacking)
    if startAttacking == true then
        self.attacking = true
    end
    
    if 
        not self.hunting
        or not Lucene.player:haveCommandBal()
        or not (self.attacking or self.autoAttack)
        or not Lucene.target then
            return
    end

    if self.shouldStun then
        Lucene.player:send(self.stunCommand, Lucene.target)
        return
    end
    Lucene.player:send(self.attackCommand, Lucene.target)
    return
end
Lucene.callbacks.register("Lucene.prompt", function() Lucene.hunter:attack() end)
Lucene.callbacks.register("Lucene.balance.given", function() Lucene.hunter:attack() end)

function Lucene.hunter:getWeight(mob)
    if not mob then return 0 end

    if mob:id() and self.mobCache[mob:id()] then
        return self.mobCache[mob:id()]:weight()
    end

    if mob:name() and self.mobCache[mob:name()] then
        return self.mobCache[mob:name()]:weight()
    end

    if mob:questable() then
        return self.maxWeight + 1
    end
    
    return 0
end

function Lucene.hunter:isHuntable(mob)
    local huntable = false
    if mob:monster() and not mob:ignore() then
        huntable = true
    end

    return huntable
end

function Lucene.hunter:isRegistered(mob)
    if self.mobCache[mob:name()] or self.mobCache[mob:id()] then
        return true
    end

    return false
end

function Lucene.hunter:init()
    self:loadMobs()
end
Lucene.callbacks.register("Lucene.bootstrap", function() Lucene.hunter:init() end)

function Lucene.hunter:loadMobs()
    local mobList = Lucene.huntTargets:getAll()

    for _, huntTarget in ipairs(mobList) do
        self.mobCache[huntTarget:identifier()] = huntTarget
    end
end

function Lucene.hunter:mobAdd(mobInfo)
    if not self.hunting or not self:isRegistered(mobInfo) then return end

    table.insert(self.attackList, mobInfo)
    table.sort(self.attackList)
end
Lucene.callbacks.register("Lucene.mobAdded", function() Lucene.hunter:mobAdd() end)

function Lucene.hunter:mobLeft(mobInfo)
    if not self.hunting then return end

    for i = #self.attackList, 1, -1 do
        local mob = self.attackList[i]

        if mob.id == mobInfo.id then
            table.remove(self.attackList, i)
        end
    end
    table.sort(self.attackList)

    if mobInfo.id == Lucene.target then
        self:switchTarget()
    end
end
Lucene.callbacks.register("Lucene.mobRemoved", function() Lucene.hunter:mobLeft() end)

function Lucene.hunter:mobList()
    if not self.hunting then return end

    self.attackList = {}

    for _, mobInfo in ipairs(Lucene.room.mobs) do
        if self:isRegistered(mobInfo) then
            table.insert(self.attackList, mobInfo)
        end
    end
    table.sort(self.attackList)
    self:switchTarget()
end
Lucene.callbacks.register("Lucene.mobsUpdated", function() Lucene.hunter:mobList() end)

function Lucene.hunter:remove(mob)
    mob = tonumber(mob) or mob

    local foundMob = self.mobCache[mob]

    if not foundMob then
        Hunter.warning("Unable to locate mob: <LuceneDanger>"..mob)
        return
    end

    self.mobCache[mob] = nil
    Lucene.huntTargets:remove(foundMob)
    Lucene.say(("<LuceneWarn>Removed <red>%s <LuceneWarn>with weight <red>%s"):format(mob, foundMob.weight))
    raiseEvent("Lucene.hunterUpdated")
end

function Lucene.hunter:switchTarget()
    if #self.attackList == 0 then 
        self.attacking = false
        Lucene.targeting.setTarget(nil)
        return
    end

    Lucene.targeting.setTarget(self.attackList[1]:id())
end

function Lucene.hunter:toggleAutoAttack(flag)
    if flag == nil then
        flag = not self.autoAttack
    end

    self.autoAttack = flag

    if self.autoAttack then
        self:activate(true)
        Lucene.success("Auto-hunting enabled.")
        self:attack()
    else
        Lucene.danger("Auto-hunting disabled.")
    end
end