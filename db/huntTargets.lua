Lucene.huntTargets = {}

function Lucene.huntTargets:create(identifier, weight)
    local id = tonumber(identifier)
    local name = ""

    if not id then name = identifier end

    local newTarget = self:new(id, name, weight)
    addedEntity, error = db:add(Lucene.db.huntTargets, newTarget)
    
    if error then Lucene.error(debug.getinfo(1), error) end

    return Lucene.huntTargets:findFirst(newTarget)
end

function Lucene.huntTargets:findFirst(huntTarget)
    local res = db:fetch(Lucene.db.huntTargets, {
        db:eq(Lucene.db.huntTargets.id, huntTarget.id),
        db:eq(Lucene.db.huntTargets.name, huntTarget.name),
    })

    if not res or not res[1] then
        Lucene.warning(("Unable to locate mob: <LuceneDanger>%s %s"):format(huntTarget.id, huntTarget.name))
        return
    end

    return res[1]
end

function Lucene.huntTargets:getAll()
    return db:fetch(Lucene.db.huntTargets)
end

function Lucene.huntTargets:new(id, name, weight)
    local huntTarget = {
        id = id or 0,
        name = name or "",
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