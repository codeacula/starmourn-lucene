Lucene.items = {}

function Lucene.items:addQuest(num, command)
    local item = self:getById(num)

    if not item then
        Lucene.warn("Unable to locate <LuceneDanger>"..num)
        return
    end

    item.questable = 1
    item.questCommand = command
    self:update(item)
    Lucene.success(("Registered <LuceneWarn>%s <LuceneSuccess>with command <LuceneWarn>%s"):format(num, command))
end

function Lucene.items:checkVal(item, gmcpData)
    if gmcpData and gmcpData.attrib then
        if string.find(gmcpData.attrib, "x") then item.ignore = 1 else item.ignore = 0 end
        if string.find(gmcpData.attrib, "m") then item.monster = 1 else item.monster = 0 end
        if string.find(gmcpData.attrib, "t") then item.takeable = 1 else item.takeable = 0 end
    end

    if gmcp.Room and gmcp.Room.Info.area then
        item.roomnum = tonumber(gmcp.Room.Info.num)
    end

    item.huntable = Lucene.hunter.isHuntable(item)

    return item
end

function Lucene.items:createItem(gmcpData)
    local newItem = Lucene.items:new(gmcpData)
    addedEntity, error = db:add(Lucene.db.items, newItem)

    if error then Lucene.error(debug.getinfo(1), error) end

    return Lucene.items:getById(newItem.id)
end

function Lucene.items:getById(id)
    local res = db:fetch(Lucene.db.items, db:eq(Lucene.db.items.id, id))

    if not res then return nil end

    return res[1]
end

function Lucene.items:fetchItem(gmcpData)
    local incItem = self:getById(gmcpData.id)

    if incItem then
        self:update(incItem, gmcpData) 
        return incItem 
    end

    self:createItem(gmcpData)
    return self:getById(gmcpData.id)
end

function Lucene.items:new(gmcpData)
    local newItem = {}

    for k, v in pairs(ItemSchema) do
        if k:sub(1, 1) ~= "_" then
            newItem[k] = v
        end
    end

    if not gmcpData then return newItem end

    newItem.id = tonumber(gmcpData.id) or 0
    newItem.name = gmcpData.name

    newItem = self:checkVal(newItem, gmcpData)

    return newItem
end

function Lucene.items:removeQuest(num)
    local item = self:getById(num)

    if not item then
        Lucene.warn("Unable to locate <LuceneDanger>"..num)
        return
    end

    item.questable = 0
    item.questCommand = ""
    self:update(item)
    Lucene.success(("Removed quest command from <LuceneWarn>%s"):format(num))
end

function Lucene.items:update(item, gmcpData)

    if(gmcpData) then
        item = self:checkVal(item, gmcpData)
    end

    tempTimer(0, function()
        local res, error = db:update(Lucene.db.items, item)
        if error then Lucene.error(debug.getinfo(1), error) end
    end)
end