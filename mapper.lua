Lucene.mapper = {}
Lucene.mapper.exploredCache = {}

function Lucene.mapper.explored()
    local roomNum = gmcp.Room.Info.num
    local areaNum = tonumber(gmcp.Room.Info.coords:split(",")[1])
    local dbRoom = nil
    local res = db:fetch(Lucene.db.rooms, db:eq(Lucene.db.rooms.num, roomNum))

    if res and res[1] then
        dbRoom = res[1]
        dbRoom.areanum = areaNum
        dbRoom.explored = 1
        db:update(Lucene.db.rooms, dbRoom)
        return
    end

    dbRoom = {
        num = roomNum,
        areanum = areaNum,
        explored = 1
    }

    db:add(Lucene.db.rooms, dbRoom)
    Lucene.mapper.exploredCache[dbRoom.num] = dbRoom
end
registerAnonymousEventHandler("gmcp.Room.Info", "Lucene.mapper.explored")

function Lucene.mapper.load()
    local res = db:fetch(Lucene.db.rooms)

    for _, room in ipairs(res) do
        Lucene.mapper.explored[room.num] = room
    end
end
registerAnonymousEventHandler("Lucene.bootstrap", "Lucene.hunter.init")