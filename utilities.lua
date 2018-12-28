Lucene.utilities = {}

Lucene.utilities.getKeys = function(incTable)
    local keyTable = {}

    for k, _ in pairs(incTable) do
        table.insert(keyTable, k)
    end

    return keyTable
end

function bton(val)
    if val then return 1 end

    return 0
end

function ntob(val)
    if val == 1 then return true end

    return false
end