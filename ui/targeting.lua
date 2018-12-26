-- The targeting window
Lucene.targetWindow = {}
Lucene.targetWindow.mobs = {}
Lucene.targetWindow.space = {}
Lucene.targetWindow.players = {}

Lucene.targetWindow.variables = {
    lineHeight = 15
}

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

local mobNameHeader = Lucene.containers.label({
    name = "mobHunterHeader",
    x = "60%", y = 0,
    height = px(15), width = "5%"
}, Lucene.targetWindow.mobListContainer)
mobNameHeader:echo("<center>+")
mobNameHeader:setStyleSheet(Lucene.styles.mobHeader)

local mobWeightNameHeader = Lucene.containers.label({
    name = "mobWeightNameHeader",
    x = "65%", y = 0,
    height = px(15), width = "10%"
}, Lucene.targetWindow.mobListContainer)
mobWeightNameHeader:echo("<center>Name")
mobWeightNameHeader:setStyleSheet(Lucene.styles.mobHeader)

local mobWeightIndividualHeader = Lucene.containers.label({
    name = "mobWeightIndividualHeader",
    x = "75%", y = 0,
    height = px(15), width = "10%"
}, Lucene.targetWindow.mobListContainer)
mobWeightIndividualHeader:echo("<center>Num")
mobWeightIndividualHeader:setStyleSheet(Lucene.styles.mobHeader)

function Lucene.targetWindow.updateMobList()
    local i = 1

    for _, v in ipairs(Lucene.targetWindow.mobs) do
        Lucene.containers.remove(v)
    end

    local mobTable = {}

    for _, v in ipairs(Lucene.room.mobs) do
        if v then table.insert(mobTable, v) end
    end
    
    table.sort(mobTable, function(a, b)
        local aweight = 0
        local bweight = 0

        if not a.monster then aweight = aweight + 30 end
        if not b.monster then bweight = bweight + 30 end

        if a.ignore then aweight = aweight + 1000 end
        if b.ignore then bweight = bweight + 1000 end

        aweight = aweight + Lucene.hunter.getWeight(a)
        bweight = bweight + Lucene.hunter.getWeight(b)

        if aweight == 0 then aweight = 29 end
        if bweight == 0 then bweight = 29 end

        if aweight == bweight and a.name == b.name then
            return a.id < b.id
        end

        if aweight == bweight then
            return a.name < b.name
        end

        return aweight < bweight
    end)

    for _, v in ipairs(mobTable) do
        local mobLineItem = Lucene.containers.container({
            name = "mobItem"..i,
            x = 0, y = px(Lucene.targetWindow.variables.lineHeight * i),
            height = px(Lucene.targetWindow.variables.lineHeight), width = "100%"
        }, Lucene.targetWindow.mobListContainer)

        -- Mob Name
        local mobNameItem = Lucene.containers.label({
            name = "mobNameItem"..i,
            x = 0, y = 0,
            height = "100%", width = "60%"
        }, mobLineItem)
        mobNameItem:setStyleSheet(Lucene.styles.mobItem)

        
        if v.ignore == 1 then
            mobNameItem:echo(v.name, "dim_grey")
            mobNameItem:setDoubleClickCallback("Lucene.targeting.setTarget", v.id)
        elseif Lucene.target and Lucene.target == v.id then
            mobNameItem:echo(v.name, "LuceneDanger")
            mobNameItem:setClickCallback("Lucene.targeting.setTarget", v.id)
        elseif Lucene.hunter.isRegistered(v) then
            mobNameItem:echo(v.name, "LuceneSuccess")
            mobNameItem:setClickCallback("Lucene.targeting.setTarget", v.id)
        else
            mobNameItem:echo(v.name)
            mobNameItem:setClickCallback("Lucene.targeting.setTarget", v.id)
        end

        -- Add To Hunter
        local mobHunterItem = Lucene.containers.label({
            name = "mobHunterItem"..i,
            x = "60%", y = 0,
            height = "100%", width = "5%"
        }, mobLineItem)
        mobHunterItem:setStyleSheet(Lucene.styles.mobItem)
        
        if Lucene.hunter.isRegistered(v) then
            mobHunterItem:echo("<center>-", "LuceneDanger")
            mobHunterItem:setClickCallback("Lucene.hunter.remove", v.name)
        elseif Lucene.hunter.isHuntable(v) == 1 then
            mobHunterItem:echo("<center>+", "LuceneSuccess")
            mobHunterItem:setClickCallback("Lucene.hunter.add", v.name, 25)
        end

        table.insert(Lucene.targetWindow.mobs, "mobItem"..i)

        i = i + 1
    end
end
registerAnonymousEventHandler("Lucene.mobAdded", "Lucene.targetWindow.updateMobList")
registerAnonymousEventHandler("Lucene.mobsUpdated", "Lucene.targetWindow.updateMobList")
registerAnonymousEventHandler("Lucene.mobRemoved", "Lucene.targetWindow.updateMobList")
registerAnonymousEventHandler("Lucene.newTarget", "Lucene.targetWindow.updateMobList")
registerAnonymousEventHandler("Lucene.hunterUpdated", "Lucene.targetWindow.updateMobList")

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