-- Handles all the players, mobs, etc in the room
Lucene.room = {}
Lucene.room.mobs = {}

function Lucene.room.addMob(incData)
    -- Process the mob
    local newMob = Lucene.room.processMob(incData)

    table.insert(Lucene.room.mobs, newMob)
    raiseEvent("Lucene.mobAdded", newMob)
end

function Lucene.room.gmcpMobEntered()
    if gmcp.Char.Items.Add.location ~= "room" then
        return
    end
    
    Lucene.room.addMob(gmcp.Char.Items.Add.item)
end
registerAnonymousEventHandler("gmcp.Char.Items.Add", "Lucene.room.gmcpMobEntered")

function Lucene.room.gmcpMobList()
    if gmcp.Char.Items.List.location ~= "room" then
        return
    end
    
    Lucene.room.processList(gmcp.Char.Items.List.items)
end
registerAnonymousEventHandler("gmcp.Char.Items.List", "Lucene.room.gmcpMobList")

function Lucene.room.gmcpMobRemoved()
    if gmcp.Char.Items.Remove.location ~= "room" then
        return
    end
    
    Lucene.room.removeMob(tonumber(gmcp.Char.Items.Remove.item.id))
end
registerAnonymousEventHandler("gmcp.Char.Items.Remove", "Lucene.room.gmcpMobRemoved")

function Lucene.room.processList(mobList)
    Lucene.room.mobs = {}

    for _, mob in pairs(mobList) do
        Lucene.room.addMob(mob)
    end

    raiseEvent("Lucene.mobsUpdated")
end

function Lucene.room.processMob(gmcpData)
    local newMob = {
        id = tonumber(gmcpData.id) or 0,
        name = gmcpData.name or "",
        ignore = false,
        monster = false
    }

    if gmcpData.attrib then
       local ignoreFind = string.find(gmcpData.attrib, "x") or -1
       local monsterFind = string.find(gmcpData.attrib, "m") or -1

        newMob.ignore = ignoreFind > -1
        newMob.monster = monsterFind > -1
    end

    return newMob;
end

function Lucene.room.removeMob(itemNumber)
    itemNumber = tonumber(itemNumber)

    if not itemNumber then return end

    i = #Lucene.room.mobs

    while i ~= 0 do
        local mobInfo = Lucene.room.mobs[i]

        if mobInfo.id == itemNumber then
            table.remove(Lucene.room.mobs, i)
            raiseEvent("Lucene.mobRemoved", mobInfo)
        end

        i = i - 1
    end

    raiseEvent("Lucene.mobsUpdated")
end