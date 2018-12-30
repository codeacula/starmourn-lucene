-- The targeting window
Lucene.targetWindow = {}
Lucene.targetWindow.activeWindow = "mobs"
Lucene.targetWindow.shouldUpdate = true
Lucene.targetWindow.updating = false

Lucene.targetWindow.variables = {
    lineHeight = 15
}

function Lucene.targetWindow:buildUi()

    self.listContainer = Lucene.containers.container({
        name = "listContainer",
        x = "2%", y = "62%",
        width = "94%", height = "37%"
    }, Lucene.ui.sides.left.container)
    
    self.listLabel = Lucene.containers.label({
        name = "listLabel",
        x = px(0), y = px(0),
        width = "100%", height = 
        "100%"
    }, self.listContainer)
    self.listLabel:setStyleSheet([[
        background: rgba(0, 0, 0, .5);
        border: 1px solid black;
        border-radius: 10px;
    ]])
    
    -- Button row. Mob, Ship, Player
    self.headerBox = Lucene.containers.hbox({
        name = "targetHeaderBox",
        x = 0, y = 0,
        height = "10%", width = "100%"
    }, self.listContainer)

    -- Build the windows
    self:buildImportantWindow()
    self:buildMobWindow()
    self:buildShipWindow()
    self:buildPlayerWindow()

    self:setActiveWindow("mobs")
end

function Lucene.targetWindow:clean()
    -- Attempts to reset/clean the UI
    self:scrubMobs()
end

function Lucene.targetWindow:setActiveWindow(name)
    self:cleanupMobWindow()
    self:cleanupShipWindow()

    if name == "mobs" then
        self.mobListContainer:show()
        self.shipListContainer:hide()
        self.playerListContainer:hide()
    elseif name == "ships" then
        self.mobListContainer:hide()
        self.shipListContainer:show()
        self.playerListContainer:hide()
    else
        self.mobListContainer:hide()
        self.shipListContainer:hide()
        self.playerListContainer:show()
    end

    self.activeWindow = name
    self:scheduleUpdate()
end

function Lucene.targetWindow:scheduleUpdate()
    if self.updating then
        self.shouldUpdate = true
        return
    end

    self.updating = true
    if self.activeWindow == "mobs" then
        tempTimer(0.5, function() Lucene.targetWindow:updateMobList() end)
    elseif self.activeWindow == "ships" then
        tempTimer(0.5, function() Lucene.targetWindow:updateNearbyShips() end)
    end
end
registerAnonymousEventHandler("Lucene.mobAdded", function() Lucene.targetWindow:scheduleUpdate() end)
registerAnonymousEventHandler("Lucene.mobsUpdated", function() Lucene.targetWindow:scheduleUpdate() end)
registerAnonymousEventHandler("Lucene.mobRemoved", function() Lucene.targetWindow:scheduleUpdate() end)
registerAnonymousEventHandler("Lucene.newTarget", function() Lucene.targetWindow:scheduleUpdate() end)
registerAnonymousEventHandler("Lucene.hunterUpdated", function() Lucene.targetWindow:scheduleUpdate() end)
registerAnonymousEventHandler("Lucene.shipsUpdated", function() Lucene.targetWindow:scheduleUpdate() end)

Lucene.import("ui/targetWindow/importantTargets")
Lucene.import("ui/targetWindow/mobWindow")
Lucene.import("ui/targetWindow/shipWindow")
Lucene.import("ui/targetWindow/playerWindow")
Lucene.targetWindow:buildUi()