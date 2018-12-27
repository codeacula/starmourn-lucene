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
function Lucene.hunter.add(identifier, weight)
    local id = tonumber(identifier)

    if id then identifier = id end

    -- If it exists, don't add again
    if Lucene.hunter.mobCache[identifier] then
        Lucene.warn(("Already have %s in the system"))
        return
    end

    weight = weight or Lucene.hunter.maxWeight

    local newTarget = Lucene.huntTargets:create(identifier, weight)

    Lucene.hunter.mobCache[identifier] = newTarget
    Lucene.say(("<LuceneSuccess>Added <red>%s <LuceneSuccess>with weight <red>%s<reset>"):format(identifier, weight))
    raiseEvent("Lucene.hunterUpdated")
end

function Lucene.hunter.activate(flag)
    if flag == nil then
        flag = not Lucene.hunter.hunting
    end

    Lucene.hunter.hunting = flag

    if flag then
        Lucene.success("Beginning the hunt.")
        Lucene.hunter.mobList()
    else
        Lucene.danger("The hunt has ended.")
    end
end

function Lucene.hunter.adjustWeight(identifier, weight)
    local mob = Lucene.hunter.mobCache[identifier]

    if not mob then
        Lucene.hunter.add(identifier, weight)
        return
    end

    mob.weight = weight
    Lucene.huntTargets:update(mob)
    raiseEvent("Lucene.hunterUpdated")
end

function Lucene.hunter.attack(startAttacking)
    if startAttacking == true then
        Lucene.hunter.attacking = true
    end
    
    if 
        not Lucene.hunter.hunting
        or not Lucene.player:haveCommandBal()
        or not (Lucene.hunter.attacking or Lucene.hunter.autoAttack)
        or not Lucene.target then
            return
    end

    if Lucene.hunter.shouldStun then
        Lucene.player:send(Lucene.hunter.stunCommand, Lucene.target)
        return
    end
    Lucene.player:send(Lucene.hunter.attackCommand, Lucene.target)
    return
end

function Lucene.hunter.getWeight(mob)
    if not mob then return 0 end

    if mob.id and Lucene.hunter.mobCache[mob.id] then
        return Lucene.hunter.mobCache[mob.id].weight
    end

    if mob.name and Lucene.hunter.mobCache[mob.name] then
        return Lucene.hunter.mobCache[mob.name].weight
    end

    if mob.questable then
        return Lucene.hunter.maxWeight + 1
    end
    
    return 0
end

function Lucene.hunter.isHuntable(mob)
    local huntable = 0
    
    if mob.monster == 1 and mob.ignore == 0 then
        huntable = 1
    end

    return huntable
end

function Lucene.hunter.isRegistered(mob)
    if Lucene.hunter.mobCache[mob.name] or Lucene.hunter.mobCache[mob.id] then
        return true
    end

    return false
end

function Lucene.hunter.init()
    Lucene.hunter.loadMobs()
end
registerAnonymousEventHandler("Lucene.bootstrap", "Lucene.hunter.init")

function Lucene.hunter.loadMobs()
    local mobList = Lucene.huntTargets:getAll()

    for _, huntTarget in ipairs(mobList) do
        local id = huntTarget.id

        if not id or id == 0 then id = huntTarget.name end

        Lucene.hunter.mobCache[id] = huntTarget
    end
end

function Lucene.hunter.mobAdd(mobInfo)
    if not Lucene.hunter.hunting then return end

    if Lucene.hunter.isRegistered(mobInfo) then
        table.insert(Lucene.hunter.attackList, mobInfo)
    end
    Lucene.hunter.sortList()
end
registerAnonymousEventHandler("Lucene.mobAdded", "Lucene.hunter.mobAdd")

function Lucene.hunter.mobLeft(mobInfo)
    if not Lucene.hunter.hunting then return end

    for i = #Lucene.hunter.attackList, 1, -1 do
        local mob = Lucene.hunter.attackList[i]

        if mob.id == mobInfo.id then
            table.remove(Lucene.hunter.attackList, i)
        end
    end
    Lucene.hunter.sortList()

    if mobInfo.id == Lucene.target then
        Lucene.hunter.switchTarget()
    end

end
registerAnonymousEventHandler("Lucene.mobRemoved", "Lucene.hunter.mobLeft")

function Lucene.hunter.mobList()
    if not Lucene.hunter.hunting then return end

    Lucene.hunter.attackList = {}

    for _, mobInfo in ipairs(Lucene.room.mobs) do
        if Lucene.hunter.isRegistered(mobInfo) then
            table.insert(Lucene.hunter.attackList, mobInfo)
        end
    end
    Lucene.hunter.sortList()
    Lucene.hunter.switchTarget()
end
registerAnonymousEventHandler("Lucene.mobsUpdated", "Lucene.hunter.mobList")

function Lucene.hunter.onPrompt()
    Lucene.hunter.attack()
end
registerAnonymousEventHandler("Lucene.prompt", "Lucene.hunter.onPrompt")
registerAnonymousEventHandler("Lucene.balance.given", "Lucene.hunter.onPrompt")



function Lucene.hunter.remove(mob)
    mob = tonumber(mob) or mob

    local foundMob = Lucene.hunter.mobCache[mob]

    if not foundMob then
        Hunter.warning("Unable to locate mob: <LuceneDanger>"..mob)
        return
    end

    Lucene.hunter.mobCache[mob] = nil
    Lucene.huntTargets:remove(foundMob)
    Lucene.say(("<LuceneWarn>Removed <red>%s <LuceneWarn>with weight <red>%s"):format(mob, foundMob.weight))
    raiseEvent("Lucene.hunterUpdated")
end

function Lucene.hunter.sortList()
    table.sort(Lucene.hunter.attackList, function(a, b)
        aweight = Lucene.hunter.getWeight(a)
        bweight = Lucene.hunter.getWeight(b)

        if aweight < bweight then
            return true
        end

        if bweight < aweight then
            return false
        end

        if a.name == b.name then
            return a.id < b.id
        end

        return a.name < b.name
    end)
end

function Lucene.hunter.switchTarget()
    if #Lucene.hunter.attackList == 0 then 
        Lucene.hunter.attacking = false
        Lucene.targeting.setTarget(nil)
        return
    end

    Lucene.targeting.setTarget(Lucene.hunter.attackList[1].id)
end

function Lucene.hunter.toggleAutoAttack(flag)
    if flag == nil then
        flag = not Lucene.hunter.autoAttack
    end

    Lucene.hunter.autoAttack = flag

    if Lucene.hunter.autoAttack then
        Lucene.success("Auto-hunting enabled.")
        Lucene.hunter.attack()
    else
        Lucene.danger("Auto-hunting disabled.")
    end
end