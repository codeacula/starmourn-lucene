Lucene.huntTargets = {}

function Lucene.huntTargets:create(identifier, weight)
    local id = tonumber(identifier)
    local name = ""

    if not id then name = identifier end

    local newTarget = self:new(id, name, weight)
    addedEntity, error = db:add(Lucene.db.huntTargets, newTarget.context)
    
    if error then Lucene.error(debug.getinfo(1), error) end

    return Lucene.huntTargets:findFirst(newTarget)
end

function Lucene.huntTargets:findFirst(huntTarget)
    display(huntTarget:dbFind())
    local res = db:fetch(Lucene.db.huntTargets, db:eq(huntTarget:dbFind()))

    if not res or not res[1] then
        Lucene.warning(("Unable to locate mob: <LuceneDanger>%s %s"):format(huntTarget.id, huntTarget.name))
        return
    end

    huntTarget.context = res[1]

    return huntTarget
end

function Lucene.huntTargets:getAll()
    local res = db:fetch(Lucene.db.huntTargets)

    local hts = {}

    for _, v in ipairs(res) do
        table.insert(hts, Lucene.objects.huntTarget:new(v))
    end

    return hts
end

function Lucene.huntTargets:new(id, name, weight)
    local huntTargetDto = {
        id = id or 0,
        name = name or "",
        weight = weight
    }

    local huntTarget = Lucene.objects.huntTarget:new(huntTargetDto)

    return huntTarget
end

function Lucene.huntTargets:remove(huntTarget)
    display(huntTarget.context)
    db:delete(Lucene.db.huntTargets, huntTarget.context)
end

function Lucene.huntTargets:update(huntTarget)
    display(huntTarget.context)
    local res, error = db:update(Lucene.db.huntTargets, huntTarget.context)
    if error then Lucene.error(debug.getinfo(1), error) end
end