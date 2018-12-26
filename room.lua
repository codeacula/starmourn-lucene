-- Handles all the players, mobs, etc in the room
Lucene.room = {}
Lucene.room.mobs = {}

function Lucene.room.addMob(incData, suppressEvent)
    -- Process the mob
    local newMob = Lucene.room.processMob(incData)

    table.insert(Lucene.room.mobs, newMob)

    if suppressEvent then return end

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
        Lucene.room.addMob(mob, true)
    end
    raiseEvent("Lucene.mobsUpdated")
end

function Lucene.room.processMob(gmcpData)
    local newMob = Lucene.items:fetchItem(gmcpData)

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