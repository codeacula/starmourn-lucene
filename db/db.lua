Lucene.import("db/schemas")

Lucene.db = {}
Lucene.db.context = db:create("lucenedb",{
    items = ItemSchema,
    players = PlayerSchema,
    rooms = RoomSchema
})

-- Repos, basically
Lucene.db.items = {}
Lucene.db.players = {}
Lucene.db.rooms = {}

function Lucene.db.items.getById(id)

end