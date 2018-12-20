Lucene.utilities = {}

Lucene.utilities.getKeys = function(incTable)
    local keyTable = {}

    for k, _ in pairs(incTable) do
        table.insert(keyTable, k)
    end

    return keyTable
end