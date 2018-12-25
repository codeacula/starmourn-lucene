Item = {
    area = "",
    gmcpdata = "",
    huntable = false,
    id = 0,
    ignore = false,
    monster = false,
    name = "",
    registered = false,
    takeable = false,
    weight = 0
}

function Item:new(gmcpData)
    local newItem = {}

    for k, v in pairs(self) do
        newItem[k] = v
    end

    if not gmcpData then return newItem end

    newItem.id = tonumber(gmcpData.id) or 0
    newItem.name = gmcpData.name or ""

    local ignoreFind = string.find(gmcpData.attrib, "x") or -1
    local monsterFind = string.find(gmcpData.attrib, "m") or -1
    local takeableFind = string.find(gmcpData.attrib, "t") or -1

    newItem.ignore = ignoreFind > -1
    newItem.monster = monsterFind > -1
    newItem.takeable = takeableFind > -1

    newItem.huntable = Lucene.hunter.isHuntable(newItem)
    newItem.registered = Lucene.hunter.isRegistered(newItem)


    return newItem
end