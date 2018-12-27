-- The targeting window
Lucene.targetWindow = {}
Lucene.targetWindow.activeWindow = "mobs"
Lucene.targetWindow.shouldUpdate = true
Lucene.targetWindow.updating = false

Lucene.targetWindow.variables = {
    lineHeight = 15
}

Lucene.targetWindow.listContainer = Lucene.containers.container({
    name = "listContainer",
    x = "2%", y = "62%",
    width = "94%", height = "37%"
}, Lucene.ui.sides.left.container)

Lucene.targetWindow.listLabel = Lucene.containers.label({
    name = "listLabel",
    x = px(0), y = px(0),
    width = "100%", height = 
    "100%"
}, Lucene.targetWindow.listContainer)
Lucene.targetWindow.listLabel:setStyleSheet([[
    background: rgba(0, 0, 0, .5);
    border: 1px solid black;
    border-radius: 10px;
]])

-- Button row. Mob, Ship, Player
Lucene.targetWindow.headerBox = Lucene.containers.hbox({
    name = "targetHeaderBox",
    x = 0, y = 0,
    height = "10%", width = "100%"
}, Lucene.targetWindow.listContainer)

function Lucene.targetWindow.setActiveWindow(name)
    if name == "mobs" then
        Lucene.targetWindow.mobListContainer:show()
        Lucene.targetWindow.shipListContainer:hide()
        Lucene.targetWindow.playerListContainer:hide()
    elseif name == "ships" then
        Lucene.targetWindow.mobListContainer:hide()
        Lucene.targetWindow.shipListContainer:show()
        Lucene.targetWindow.playerListContainer:hide()
    else
        Lucene.targetWindow.mobListContainer:hide()
        Lucene.targetWindow.shipListContainer:hide()
        Lucene.targetWindow.playerListContainer:show()
    end

    Lucene.targetWindow.activeWindow = name
    Lucene.targetWindow.scheduleUpdate()
end

function Lucene.targetWindow.scheduleUpdate()
    if Lucene.targetWindow.updating then
        Lucene.targetWindow.shouldUpdate = true
        return
    end

    Lucene.targetWindow.updating = true
    if Lucene.targetWindow.activeWindow == "mobs" then
        tempTimer(0.5, Lucene.targetWindow.updateMobList)
    elseif Lucene.targetWindow.activeWindow == "ships" then
        tempTimer(0.5, Lucene.targetWindow.updateNearbyShips)
    end
end
registerAnonymousEventHandler("Lucene.mobAdded", "Lucene.targetWindow.scheduleUpdate")
registerAnonymousEventHandler("Lucene.mobsUpdated", "Lucene.targetWindow.scheduleUpdate")
registerAnonymousEventHandler("Lucene.mobRemoved", "Lucene.targetWindow.scheduleUpdate")
registerAnonymousEventHandler("Lucene.newTarget", "Lucene.targetWindow.scheduleUpdate")
registerAnonymousEventHandler("Lucene.hunterUpdated", "Lucene.targetWindow.scheduleUpdate")
registerAnonymousEventHandler("Lucene.shipsUpdated", "Lucene.targetWindow.scheduleUpdate")

Lucene.import("ui/targetWindow/mobWindow")
Lucene.import("ui/targetWindow/shipWindow")
Lucene.import("ui/targetWindow/playerWindow")
Lucene.targetWindow.setActiveWindow("mobs")