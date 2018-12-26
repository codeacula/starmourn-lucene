Lucene.import("db/schemas")
Lucene.import("db/items")
Lucene.import("db/huntTargets")

Lucene.db = db:create("lucenedb", {
    huntTargets = HuntTargetSchema,
    items = ItemSchema,
    players = PlayerSchema,
    rooms = RoomSchema
})