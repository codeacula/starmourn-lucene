-- Handles all the players, mobs, etc in the room
Lucene.room = {}
Lucene.room.mobs = {}

function Lucene.room:addMob(incData)
    -- Process the mob
    local newMob = self:processMob(incData)

    table.insert(self.mobs, newMob)

    raiseEvent("Lucene.mobAdded", newMob)
end

function Lucene.room.gmcpMobEntered()
    if gmcp.Char.Items.Add.location ~= "room" then
        return
    end
    
    Lucene.room:addMob(gmcp.Char.Items.Add.item)
end
Lucene.callbacks.register("gmcp.Char.Items.Add", Lucene.room.gmcpMobEntered)

function Lucene.room.gmcpMobList()
    if gmcp.Char.Items.List.location ~= "room" then
        return
    end
    
    Lucene.room:processList(gmcp.Char.Items.List.items)
end
Lucene.callbacks.register("gmcp.Char.Items.List", Lucene.room.gmcpMobList)

function Lucene.room.gmcpMobRemoved()
    if gmcp.Char.Items.Remove.location ~= "room" then
        return
    end
    
    Lucene.room:removeMob(tonumber(gmcp.Char.Items.Remove.item.id))
end
Lucene.callbacks.register("gmcp.Char.Items.Remove", Lucene.room.gmcpMobRemoved)

function Lucene.room:processList(mobList)
    self.mobs = {}

    for _, mob in pairs(mobList) do
        self:addMob(mob)
    end

    raiseEvent("Lucene.mobsUpdated")
end

function Lucene.room:processMob(gmcpData)
    local newMob = Lucene.items:fetchItem(gmcpData)

    return newMob;
end

function Lucene.room:removeMob(itemNumber)
    itemNumber = tonumber(itemNumber)

    if not itemNumber then return end

    i = #self.mobs

    while i ~= 0 do
        local mobInfo = self.mobs[i]

        if mobInfo.id == itemNumber then
            table.remove(self.mobs, i)
            raiseEvent("Lucene.mobRemoved", mobInfo)
        end

        i = i - 1
    end

    raiseEvent("Lucene.mobsUpdated")
end