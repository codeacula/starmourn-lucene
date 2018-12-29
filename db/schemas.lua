AfflictionSchema = {
    descrption = "",
    duration = 0,
    name = "",
    stacking = 1,
    subsysDamage = 0,
    subsystem = "",
    type = "",
    _unique = { "name" }
}

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
    age = 0,
    caprank = 0,
    class = "",
    deaths = 0,
    enemy = 0,
    explorer = 0,
    faction = "",
    factionRank = "",
    fullname = "",
    gender = "",
    honrank = 0,
    kills = 0,
    lawless = "",
    level = 0,
    married = "",
    motto = "",
    name = "",
    race = "",
    xprank = 0,
    _index = { "faction", "class" },
    _unique = { "name" }
}

RoomSchema = {
    areanum = 0,
    num = 0,
    explored = 0,
    _index = { "num" }
}