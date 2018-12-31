-- The targeting window
Lucene.targetWindow = {}
Lucene.targetWindow.currentContainer = nil
Lucene.targetWindow.shouldUpdate = true
Lucene.targetWindow.subWindows = {}
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

    -- Go through the current windows and build them
    for _, window in pairs(self.subWindows) do
        window:build()
        window:hide()
    end

    self:setActiveWindow(self.subWindows[1])
end

function Lucene.targetWindow:clean()
    -- Attempts to reset/clean the UI
    self:scrubMobs()
end

function Lucene.targetWindow.headerCallback(index)
    Lucene.targetWindow:setActiveWindow(Lucene.targetWindow.subWindows[index])
end

function Lucene.targetWindow:registerWindow(window)
    table.insert(self.subWindows, window)
    window.tabIndex = #self.subWindows
end

function Lucene.targetWindow:setActiveWindow(windowHandle)

    if Lucene.targetWindow.currentContainer then
        Lucene.targetWindow.currentContainer:hide()
    end

    Lucene.targetWindow.currentContainer = windowHandle
    Lucene.targetWindow.currentContainer:show()
    self:scheduleUpdate()
end

function Lucene.targetWindow:scheduleUpdate()
    if self.updating then
        self.shouldUpdate = true
        return
    end

    self.updating = true
    tempTimer(0.5, function()
        Lucene.targetWindow.currentContainer:update()

        self.updating = false

        if self.shouldUpdate then
            self.shouldUpdate = false
            self:scheduleUpdate()
        end
    end)
end
Lucene.callbacks.register("Lucene.mobAdded", function() Lucene.targetWindow:scheduleUpdate() end)
Lucene.callbacks.register("Lucene.mobsUpdated", function() Lucene.targetWindow:scheduleUpdate() end)
Lucene.callbacks.register("Lucene.mobRemoved", function() Lucene.targetWindow:scheduleUpdate() end)
Lucene.callbacks.register("Lucene.newTarget", function() Lucene.targetWindow:scheduleUpdate() end)
Lucene.callbacks.register("Lucene.hunterUpdated", function() Lucene.targetWindow:scheduleUpdate() end)
Lucene.callbacks.register("Lucene.shipsUpdated", function() Lucene.targetWindow:scheduleUpdate() end)

Lucene.import("ui/targetWindow/importantTargets")
Lucene.import("ui/targetWindow/mobWindow")
Lucene.import("ui/targetWindow/shipWindow")
Lucene.import("ui/targetWindow/playerWindow")
Lucene.targetWindow:buildUi()