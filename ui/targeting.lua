-- The targeting window
Lucene.targetWindow = {}
Lucene.targetWindow.mobs = {}
Lucene.targetWindow.space = {}
Lucene.targetWindow.players = {}

Lucene.targetWindow.mobContainer = Lucene.containers.container({
    name = "mobContainer",
    x = "2%", y = "62%",
    width = "94%", height = "37%"
}, Lucene.ui.sides.left.container)

Lucene.targetWindow.mobLabel = Lucene.containers.label({
    name = "mobLabel",
    x = px(0), y = px(0),
    width = "100%", height = 
    "100%"
}, Lucene.targetWindow.mobContainer)
Lucene.targetWindow.mobLabel:setStyleSheet([[
    background: rgba(0, 0, 0, .5);
    border: 1px solid black;
    border-radius: 10px;
]])

-- Button row. Mob, Ship, Player
Lucene.targetWindow.headerBox = Lucene.containers.hbox({
    name = "targetHeaderBox",
    x = 0, y = 0,
    height = "10%", width = "100%"
}, Lucene.targetWindow.mobContainer)

-- Mobs
Lucene.targetWindow.mobButton = Lucene.containers.label({
    name = "mobTargetsButton"
}, Lucene.targetWindow.headerBox)
Lucene.targetWindow.mobButton:echo("<center>M")
Lucene.targetWindow.mobButton:setStyleSheet([[
    QLabel {
        background: rgba(24, 204, 138, .4);
        border-top-left-radius: 10px;
    }
    QLabel:hover {
        background: rgba(24, 204, 138, .6);
    }
]])

Lucene.targetWindow.mobListContainer = Lucene.containers.container({
    name = "mobListContainer",
    x = 0, y = "10%",
    height = "90%", width = "100%"
}, Lucene.targetWindow.mobContainer)

local mobNameHeader = Lucene.containers.label({
    name = "mobNameHeader",
    x = 0, y = 0,
    height = px(15), width = "60%"
}, Lucene.targetWindow.mobListContainer)
mobNameHeader:echo(" Name")
mobNameHeader:setStyleSheet(Lucene.styles.mobHeader)

function Lucene.targetWindow.updateMobList()
    local i = 1

    for _, v in ipairs(Lucene.targetWindow.mobs) do
        Lucene.containers.remove(v)
    end

    local mobTable = {}

    for _, v in ipairs(Lucene.room.mobs) do
        if v then table.insert(mobTable, v) end
    end

    for _, v in ipairs(Lucene.room.mobs) do
        local mobLineItem = Lucene.containers.label({
            name = "mobItem"..i,
            x = 0, y = px(15 * i),
            height = px(15), width = "60%"
        }, Lucene.targetWindow.mobListContainer)
        mobLineItem:echo(v.name)
        mobLineItem:setStyleSheet(Lucene.styles.mobItem)

        table.insert(Lucene.targetWindow.mobs, "mobItem"..i)

        i = i + 1
    end
end
registerAnonymousEventHandler("Lucene.mobAdded", "Lucene.targetWindow.updateMobList")
registerAnonymousEventHandler("Lucene.mobsUpdated", "Lucene.targetWindow.updateMobList")
registerAnonymousEventHandler("Lucene.mobRemoved", "Lucene.targetWindow.updateMobList")

-- Ships
Lucene.targetWindow.shipButton = Lucene.containers.label({
    name = "mobShipButton"
}, Lucene.targetWindow.headerBox)
Lucene.targetWindow.shipButton:echo("<center>S")
Lucene.targetWindow.shipButton:setStyleSheet([[
    QLabel {
        background: rgba(213, 56, 255, .4);
    }
    QLabel:hover {
        background: rgba(213, 56, 255, .6);
    }
]])

-- Players
Lucene.targetWindow.playerButton = Lucene.containers.label({
    name = "mobPlayerButton"
}, Lucene.targetWindow.headerBox)
Lucene.targetWindow.playerButton:echo("<center>P")
Lucene.targetWindow.playerButton:setStyleSheet([[
    QLabel {
        background: rgba(255, 204, 81, .4);
        border-top-right-radius: 10px;
    }
    QLabel:hover {
        background: rgba(255, 204, 81, .6);
    }
]])