local HuntTarget = {
    context = {}, -- for the db
}

HuntTarget.__index = HuntTarget

function HuntTarget:dbFind()
    if self:id() == 0 then
        return Lucene.db.huntTargets.name, self:name()
    end

    return Lucene.db.huntTargets.id, self:id()
end

function HuntTarget:id(val)
    if val == nil then return self.context.id end

    self.context.id = tonumber(val)
end

function HuntTarget:identifier()
    if self:id() == 0 then
        return self:name()
    end

    return self:id()
end

function HuntTarget:name(val)
    if val == nil then return self.context.name end

    self.context.name = val
end

function HuntTarget:new(dbHuntTarget)
    local newHuntTarget = {}
    setmetatable(newHuntTarget, self)

    newHuntTarget.context = dbHuntTarget

    return newHuntTarget
end

function HuntTarget:weight(val)
    if val == nil then return self.context.weight end

    self.context.weight = tonumber(val)
end

Lucene.objects.huntTarget = HuntTarget