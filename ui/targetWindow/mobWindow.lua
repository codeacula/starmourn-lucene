Lucene.targetWindow.mobs = {}

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
Lucene.targetWindow.mobButton:setClickCallback("Lucene.targetWindow.setActiveWindow", "mobs")

Lucene.targetWindow.mobListContainer = Lucene.containers.container({
    name = "mobListContainer",
    x = 0, y = "10%",
    height = "90%", width = "100%"
}, Lucene.targetWindow.listContainer)

local mobNameHeader = Lucene.containers.label({
    name = "mobNameHeader",
    x = 0, y = 0,
    height = px(15), width = "80%"
}, Lucene.targetWindow.mobListContainer)
mobNameHeader:echo(" Name")
mobNameHeader:setStyleSheet(Lucene.styles.listLineHeader)

local mobProbeHeader = Lucene.containers.label({
    name = "mobProbeHeader",
    x = "80%", y = 0,
    height = px(15), width = "5%"
}, Lucene.targetWindow.mobListContainer)
mobProbeHeader:echo("<center>P")
mobProbeHeader:setStyleSheet(Lucene.styles.listLineHeader)

local mobNameHeader = Lucene.containers.label({
    name = "mobHunterHeader",
    x = "85%", y = 0,
    height = px(15), width = "5%"
}, Lucene.targetWindow.mobListContainer)
mobNameHeader:echo("<center>+")
mobNameHeader:setStyleSheet(Lucene.styles.listLineHeader)

local mobWeightNameHeader = Lucene.containers.label({
    name = "mobWeightNameHeader",
    x = "90%", y = 0,
    height = px(15), width = "10%"
}, Lucene.targetWindow.mobListContainer)
mobWeightNameHeader:echo("<center>Hunt")
mobWeightNameHeader:setStyleSheet(Lucene.styles.listLineHeader)

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

        if a.monster == 0 then aweight = aweight + 30 end
        if b.monster == 0 then bweight = bweight + 30 end

        if a.ignore == 1 then aweight = aweight + 1000 end
        if b.ignore == 1 then bweight = bweight + 1000 end

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
        local weight = Lucene.hunter.getWeight(v)

        local mobLineItem = Lucene.containers.container({
            name = "mobItem"..i,
            x = 0, y = px(Lucene.targetWindow.variables.lineHeight * i),
            height = px(Lucene.targetWindow.variables.lineHeight), width = "100%"
        }, Lucene.targetWindow.mobListContainer)

        -- Mob Name
        local mobNameItem = Lucene.containers.label({
            name = "mobNameItem"..i,
            x = 0, y = 0,
            height = "100%", width = "80%"
        }, mobLineItem)
        mobNameItem:setStyleSheet(Lucene.styles.listLineItem)
        mobNameItem:setClickCallback("")
        mobNameItem:setDoubleClickCallback("")

        
        if v.questable == 1 then
            mobNameItem:echo(v.name, "LuceneWarn")
            mobNameItem:setClickCallback("send", v.questCommand, true)
        elseif v.ignore == 1 then
            mobNameItem:echo(v.name, "dim_grey")
            mobNameItem:setClickCallback("Lucene.room.greet", v.id)
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

        local mobProbe = Lucene.containers.label({
            name = "mobProbe"..i,
            x = "80%", y = 0,
            height = "100%", width = "5%"
        }, mobLineItem)
        mobProbe:setStyleSheet(Lucene.styles.listLineItem)
        mobProbe:setClickCallback("Lucene.room.probe", v.id)
        mobProbe:echo("<center>P")

        -- Add To Hunter
        local mobHunterItem = Lucene.containers.label({
            name = "mobHunterItem"..i,
            x = "85%", y = 0,
            height = "100%", width = "5%"
        }, mobLineItem)
        mobHunterItem:setStyleSheet(Lucene.styles.listLineItem)
        
        if Lucene.hunter.isRegistered(v) then
            mobHunterItem:echo("<center>-", "LuceneDanger")
            mobHunterItem:setClickCallback("Lucene.hunter.remove", v.name)
        elseif Lucene.hunter.isHuntable(v) == 1 then
            mobHunterItem:echo("<center>+", "LuceneSuccess")
            mobHunterItem:setClickCallback("Lucene.hunter.add", v.name, 25)
        end

        -- Promote/demote mob by name
        local mobHunterDemoteName = Lucene.containers.label({
            name = "mobHunterDemoteName"..i,
            x = "90%", y = 0,
            height = "100%", width = "5%"
        }, mobLineItem)
        mobHunterDemoteName:setStyleSheet(Lucene.styles.listLineItem)
        mobHunterDemoteName:setClickCallback("")

        if Lucene.hunter.isHuntable(v) == 1 and weight ~= Lucene.hunter.maxWeight then
            mobHunterDemoteName:echo("<center>↓")
            mobHunterDemoteName:setClickCallback("Lucene.hunter.adjustWeight", v.name, weight + 1)
        end

        local mobHunterPromoteName = Lucene.containers.label({
            name = "mobHunterPromoteName"..i,
            x = "95%", y = 0,
            height = "100%", width = "5%"
        }, mobLineItem)
        mobHunterPromoteName:setStyleSheet(Lucene.styles.listLineItem)
        mobHunterPromoteName:setClickCallback("")

        if Lucene.hunter.isHuntable(v) == 1 and weight > 1 then
            mobHunterPromoteName:echo("<center>↑")
            mobHunterPromoteName:setClickCallback("Lucene.hunter.adjustWeight", v.name, weight - 1)
        end

        table.insert(Lucene.targetWindow.mobs, "mobItem"..i)

        i = i + 1
    end

    Lucene.targetWindow.updating = false

    if Lucene.targetWindow.shouldUpdate then
        Lucene.targetWindow.shouldUpdate = false
        Lucene.targetWindow.scheduleUpdate()
    end
end