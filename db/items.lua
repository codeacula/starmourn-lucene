Lucene.items = {}

function Lucene.items:addQuest(num, command)
    local item = self:getById(num)

    if not item then
        Lucene.warn("Unable to locate <LuceneDanger>"..num)
        return
    end

    item:questable(true)
    item:questCommand(command)
    self:update(item)
    Lucene.success(("Registered <LuceneWarn>%s <LuceneSuccess>with command <LuceneWarn>%s"):format(num, command))
end

function Lucene.items:checkVal(item, gmcpData)
    if gmcpData and gmcpData.attrib then
        if string.find(gmcpData.attrib, "x") then item:ignore(true) else item:ignore(false) end
        if string.find(gmcpData.attrib, "m") then item:monster(true) else item:monster(false) end
        if string.find(gmcpData.attrib, "t") then item:takeable(true) else item:takeable(false) end
    end

    if gmcp.Room and gmcp.Room.Info.area then
        item:roomnum(gmcp.Room.Info.num)
    end

    item:huntable(Lucene.hunter:isHuntable(item))

    return item
end

function Lucene.items:createItem(gmcpData)
    local newItem = self:new(gmcpData)
    
    local addedEntity, error = db:add(Lucene.db.items, newItem.context)

    if error then Lucene.error(debug.getinfo(1), error) end

    return self:getById(newItem:id())
end

function Lucene.items:getById(id)
    local res = db:fetch(Lucene.db.items, db:eq(Lucene.db.items.id, id))

    if not res or not res[1] then return nil end

    local resItem = Lucene.objects.item:new(res[1])

    return resItem
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
    local newItemDto = {}

    for k, v in pairs(ItemSchema) do
        if k:sub(1, 1) ~= "_" then
            newItemDto[k] = v
        end
    end

    local newItem = Lucene.objects.item:new(newItemDto)

    if not gmcpData then return newItem end

    newItem:id(tonumber(gmcpData.id) or 0)
    newItem:name(gmcpData.name)
    newItem = self:checkVal(newItem, gmcpData)

    return newItem
end

function Lucene.items:removeQuest(num)
    local item = self:getById(num)

    if not item then
        Lucene.warn("Unable to locate <LuceneDanger>"..num)
        return
    end

    item:questable(false)
    item:questCommand("")
    self:update(item)
    Lucene.success(("Removed quest command from <LuceneWarn>%s"):format(num))
end

function Lucene.items:update(item, gmcpData)

    if gmcpData then
        item = self:checkVal(item, gmcpData)
    end

    tempTimer(0.5, function()
        local res, error = db:update(Lucene.db.items, item.context)
        if error then Lucene.error(debug.getinfo(1), error) end
    end)
end