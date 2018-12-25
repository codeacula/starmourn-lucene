Lucene.hunter = {}
Lucene.hunter.autoAttack = false
Lucene.hunter.hunting = false
Lucene.hunter.maxWeight = 25
Lucene.hunter.mobCache = {}
Lucene.hunter.mobList = {}

-- Add mob by specific identifier or shortname
function Lucene.hunter.add(identifier, weight)
    local id = tonumber(identifier)

    if id then identifier = id end

    -- If it exists, don't add again
    if Lucene.hunter.mobCache[identifier] then
        Lucene.warn(("Already have %s in the system"))
    end

    weight = weight or Lucene.hunter.maxWeight

    table.insert(Lucene.hunter.mobList[weight], identifier)
    Lucene.hunter.mobCache[identifier] = weight
    Lucene.hunter.saveMobs()
    Lucene.say(("<LuceneSuccess>Added <red>%s <LuceneSuccess>with weight <red>%s<reset>"):format(identifier, weight))
    raiseEvent("Lucene.hunterUpdated")
end

function Lucene.hunter.adjustWeight(identifier, weight)
    Lucene.hunter.remove(identifier)
    Lucene.hunter.add(identifier, weight)
end

function Lucene.hunter.getWeight(mob)
    if not mob then return 0 end

    if mob.id and Lucene.hunter.mobCache[mob.id] then
        return Lucene.hunter.mobCache[mob.id]
    end

    if mob.name and Lucene.hunter.mobCache[mob.name] then
        return Lucene.hunter.mobCache[mob.name]
    end
    
    return 0
end

function Lucene.hunter.isHuntable(mob)
    return mob.monster and not mob.ignore
end

function Lucene.hunter.isRegistered(mob)
    return Lucene.hunter.mobCache[mob.name] or Lucene.hunter.mobCache[mob.id]
end

function Lucene.hunter.init()
    if not io.exists(Lucene.getPath("mobs.json")) then
        for i = 1, 25 do
            Lucene.hunter.mobList[i] = {}
        end

        Lucene.hunter.saveMobs()
    else
        Lucene.hunter.loadMobs()
    end
end
registerAnonymousEventHandler("Lucene.bootstrap", "Lucene.hunter.init")

function Lucene.hunter.loadMobs()
    local saveFile = assert(io.open(Lucene.getPath("mobs.json"), "r"))
    local settingString = saveFile:read("*a")
    saveFile:close()

    Lucene.hunter.mobList = yajl.to_value(settingString)

    for weight, items in ipairs(Lucene.hunter.mobList) do
        for _, id in ipairs(items) do
            Lucene.hunter.mobCache[id] = weight
        end
    end
end

function Lucene.hunter.saveMobs()
    local saveFile = assert(io.open(Lucene.getPath("mobs.json"), "w+"))
    saveFile:write(yajl.to_string(Lucene.hunter.mobList))
    saveFile:flush()
    saveFile:close()
end

function Lucene.hunter.remove(mob)

    local weight = 0
    local locator = nil

    if type(mob) == "string" then
        mobname = mob
        mob = { name = mobname }
    elseif type(mob) == "number" then
        mobname = mob
        mob = { id = mobname }
    end

    if Lucene.hunter.mobCache[mob.id] then
        locator = mob.id
        weight = Lucene.hunter.mobCache[mob.id]
    elseif Lucene.hunter.mobCache[mob.name] then
        locator = mob.name
        weight = Lucene.hunter.mobCache[mob.name]
    else
        return
    end

    for i = #Lucene.hunter.mobList[weight], 1, -1 do
        local item = Lucene.hunter.mobList[weight][i]

        if item.name == locator or item.id == locator then
            table.remove(Lucene.hunter.mobList[weight], i)
        end
    end

    Lucene.hunter.mobCache[locator] = nil
    Lucene.hunter.saveMobs()
    Lucene.say(("<LuceneWarn>Removed <red>%s <LuceneWarn>with weight <red>%s"):format(locator, weight))
    raiseEvent("Lucene.hunterUpdated")
end