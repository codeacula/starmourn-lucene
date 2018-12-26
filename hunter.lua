Lucene.hunter = {}
Lucene.hunter.autoAttack = false
Lucene.hunter.hunting = false
Lucene.hunter.maxWeight = 25
Lucene.hunter.mobCache = {}

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

function Lucene.hunter.getWeight(mob)
    if not mob then return 0 end

    if mob.id and Lucene.hunter.mobCache[mob.id] then
        return Lucene.hunter.mobCache[mob.id].weight
    end

    if mob.name and Lucene.hunter.mobCache[mob.name] then
        return Lucene.hunter.mobCache[mob.name].weight
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