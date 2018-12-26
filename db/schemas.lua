ItemSchema = {
    block = 0, -- Do we not even show it in the mob list?
    id = 0,
    name = "",
    ignore = 0,
    monster = 0,
    takeable = 0,
    huntable = 0,
    questable = 0,
    questCommand = "",
    roomnum = 0,
    _index = { "area" },
    _unique = { "id" }
}

HuntTargetSchema = {
    id = 0,
    name = "",
    weight = 25
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
    _index = { "faction", "class" },
    _unique = { "name" }
}

RoomSchema = {
    areanum = 0,
    num = 0,
    explored = 0,
    _index = { "num" }
}