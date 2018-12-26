Lucene.huntTargets = {}

function Lucene.huntTargets:create(identifier, weight)
    local id = tonumber(identifier)
    local name = ""

    if not id then name = identifier end

    local newTarget = self:new(id, name, weight)
    addedEntity, error = db:add(Lucene.db.huntTargets, newTarget)

    if error then Lucene.error(debug.getinfo(1), error) end

    return Lucene.items:getById(newItem.id)
end

function Lucene.huntTargets:getAll()
    return db:fetch(Lucene.db.huntTargets)
end

function Lucene.huntTargets:new(id, name, weight)
    local huntTarget = {
        id = id,
        name = name,
        weight = weight
    }

    return huntTarget
end

function Lucene.huntTargets:remove(huntTarget)
    db:delete(Lucene.db.huntTargets, huntTarget)
end

function Lucene.huntTargets:update(huntTarget)
    local res, error = db:update(Lucene.db.huntTargets, huntTarget)
    if error then Lucene.error(debug.getinfo(1), error) end
end