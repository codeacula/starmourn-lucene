local Item = {
    context = {}, -- for the db
    currentWeight = -1
}

Item.__index = Item

Item.__lt = function(itema, itemb)
    if itema:weight() ~= itemb:weight() then
        return itema:weight() < itemb:weight()
    end

    if itema:name() ~= itemb:name() then
        return itema:name() < itemb:name()
    end

    return itema:id() < itemb:id()
end

function Item:block(flag)
    if flag == nil then return ntob(self.context.block) end

    if flag == true then
        self.context.block = 1
    else
        self.context.block = 0
    end
    self.currentWeight = -1
end

function Item:huntable(flag)
    if flag == nil then return ntob(self.context.huntable) end

    if flag == true then
        self.context.huntable = 1
    else
        self.context.huntable = 0
    end
    self.currentWeight = -1
end

function Item:id(val)
    if val == nil then return self.context.id end

    self.context.id = tonumber(val)
end

function Item:ignore(flag)
    if flag == nil then return ntob(self.context.ignore) end

    if flag == true then
        self.context.ignore = 1
    else
        self.context.ignore = 0
    end
    self.currentWeight = -1
end

function Item:monster(flag)
    if flag == nil then return ntob(self.context.monster) end

    if flag == true then
        self.context.monster = 1
    else
        self.context.monster = 0
    end
    self.currentWeight = -1
end

function Item:name(val)
    if val == nil then return self.context.name end

    self.context.name = val
end

function Item:new(dbItem)
    local newItem = {}
    setmetatable(newItem, self)

    newItem.context = dbItem

    return newItem
end

function Item:questable(flag)
    if flag == nil then return ntob(self.context.questable) end

    if flag == true then
        self.context.questable = 1
    else
        self.context.questable = 0
    end
    self.currentWeight = -1
end

function Item:questCommand(val)
    if val == nil then return self.context.questCommand end

    self.context.questCommand = val
end

function Item:roomnum(val)
    if val == nil then return self.context.roomnum end

    self.context.roomnum = tonumber(val)
end

function Item:takeable(flag)
    if flag == nil then return ntob(self.context.takeable) end

    if flag == true then
        self.context.takeable = 1
    else
        self.context.takeable = 0
    end
    self.currentWeight = -1
end

function Item:weight()

    if self.currentWeight ~= -1 then return self.currentWeight end

    local w = Lucene.hunter:getWeight(self)

    if w ~= 0 then
        self.currentWeight = w
        return self.currentWeight 
    end

    if not self:monster() then w = w + Lucene.settings.weights.monster end
    if self:ignore() then w = w + Lucene.settings.weights.ignore end

    -- No weights o' 0 here
    if w == 0 then w = Lucene.settings.weights.float end

    self.currentWeight = w
    return self.currentWeight
end

Lucene.objects.item = Item