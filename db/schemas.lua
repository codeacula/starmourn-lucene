ItemSchema = {
    id = 0,
    name = "",
    gmcpData = "",
    ignore = false,
    monster = false,
    takeable = false,
    area = "",
    huntable = false,
    questable = false,
    questCommand = "",
    __index = { "id", "area" },
    __unique = { "id" }
}

PlayerSchema = {
    name = "",
    fullname = "",
    race = "",
    gender = "",
    faction = "",
    factionRank = "",
    lawless = "",
    married = "",
    motto = "",
    xprank = 0,
    xplrank = 0,
    caprank = 0,
    honrank = 0,
    level = 0,
    class = "",
    age = 0,
    kills = 0,
    deaths = 0,
    __index = { "name", "faction", "class" },
    __unique = { "name" }
}

RoomSchema = {
    num = 0,
    explored = false,
    __index = { "num" }
}