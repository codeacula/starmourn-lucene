Lucene.targetWindow.mobs = {}

function Lucene.targetWindow:buildMobWindow()
    self.mobButton = Lucene.containers.label({
        name = "mobTargetsButton"
    }, self.headerBox)
    self.mobButton:echo("<center>M")
    self.mobButton:setStyleSheet([[
        QLabel {
            background: rgba(24, 204, 138, .4);
        }
        QLabel:hover {
            background: rgba(24, 204, 138, .6);
        }
    ]])
    self.mobButton:setClickCallback([[function()
        Lucene.targetWindow:setActiveWindow("mobs") 
    end]])
    
    self.mobListContainer = Lucene.containers.container({
        name = "mobListContainer",
        x = 0, y = "10%",
        height = "90%", width = "100%"
    }, self.listContainer)
    
    local mobNameHeader = Lucene.containers.label({
        name = "mobNameHeader",
        x = 0, y = 0,
        height = px(15), width = "80%"
    }, self.mobListContainer)
    mobNameHeader:echo("Name")
    mobNameHeader:setStyleSheet(Lucene.styles.listLineHeader)
    
    local mobProbeHeader = Lucene.containers.label({
        name = "mobProbeHeader",
        x = "80%", y = 0,
        height = px(15), width = "5%"
    }, self.mobListContainer)
    mobProbeHeader:echo("<center>P")
    mobProbeHeader:setStyleSheet(Lucene.styles.listLineHeader)
    
    local mobNameHeader = Lucene.containers.label({
        name = "mobHunterHeader",
        x = "85%", y = 0,
        height = px(15), width = "5%"
    }, self.mobListContainer)
    mobNameHeader:echo("<center>+")
    mobNameHeader:setStyleSheet(Lucene.styles.listLineHeader)
    
    local mobWeightNameHeader = Lucene.containers.label({
        name = "mobWeightNameHeader",
        x = "90%", y = 0,
        height = px(15), width = "10%"
    }, self.mobListContainer)
    mobWeightNameHeader:echo("<center>Hunt")
    mobWeightNameHeader:setStyleSheet(Lucene.styles.listLineHeader)
end

function Lucene.targetWindow:cleanupMobWindow()
    for _, v in ipairs(self.mobs) do
        Lucene.containers.remove(v)
    end

    self.mobs = {}
end

function Lucene.targetWindow:scrubMobs()
    for i = 1, 100 do
        hideWindow("mobItem"..i)
        echo(i)
    end
end

function Lucene.targetWindow:updateMobList()
    local i = 1
    
    self:cleanupMobWindow()

    table.sort(Lucene.room.mobs)

    for _, v in ipairs(Lucene.room.mobs) do
        local weight = v:weight()

        local mobLineItem = Lucene.containers.container({
            name = "mobItem"..i,
            x = 0, y = px(self.variables.lineHeight * i),
            height = px(self.variables.lineHeight), width = "100%"
        }, self.mobListContainer)

        -- Mob Name
        local mobNameItem = Lucene.containers.label({
            name = "mobNameItem"..i,
            x = 0, y = 0,
            height = "100%", width = "80%"
        }, mobLineItem)
        mobNameItem:setStyleSheet(Lucene.styles.listLineItem)
        mobNameItem:setClickCallback("")
        mobNameItem:setDoubleClickCallback("")

        if v:questable() then
            mobNameItem:echo(v:name(), "LuceneWarn")
            mobNameItem:setClickCallback("send", v.questCommand, true)
        elseif v:ignore() then
            mobNameItem:echo(v:name(), "dim_grey")
            mobNameItem:setClickCallback("send", "greet "..v:id(), true)
            mobNameItem:setDoubleClickCallback("Lucene.targeting.setTarget", v:id())
        elseif Lucene.target and Lucene.target == v:id() then
            mobNameItem:echo(v:name(), "LuceneDanger")
            mobNameItem:setClickCallback("Lucene.targeting.setTarget", Lucene.targeting, nil)
        elseif Lucene.hunter:isRegistered(v) then
            mobNameItem:echo(v:name(), "LuceneSuccess")
            mobNameItem:setClickCallback("Lucene.targeting.setTarget", Lucene.targeting, v:id())
        else
            mobNameItem:echo(v:name())
            mobNameItem:setClickCallback("Lucene.targeting.setTarget", Lucene.targeting, v:id())
        end

        local mobProbe = Lucene.containers.label({
            name = "mobProbe"..i,
            x = "80%", y = 0,
            height = "100%", width = "5%"
        }, mobLineItem)
        mobProbe:setStyleSheet(Lucene.styles.listLineItem)
        mobProbe:setClickCallback("send", "probe "..v:id(), true)
        mobProbe:echo("<center>P")

        -- Add To Hunter
        local mobHunterItem = Lucene.containers.label({
            name = "mobHunterItem"..i,
            x = "85%", y = 0,
            height = "100%", width = "5%"
        }, mobLineItem)
        mobHunterItem:setStyleSheet(Lucene.styles.listLineItem)
        
        if Lucene.hunter:isRegistered(v) then
            mobHunterItem:echo("<center>-", "LuceneDanger")
            mobHunterItem:setClickCallback("Lucene.hunter.remove", v:name())
        elseif Lucene.hunter:isHuntable(v) == 1 then
            mobHunterItem:echo("<center>+", "LuceneSuccess")
            mobHunterItem:setClickCallback("Lucene.hunter.add", v:name(), 25)
        end

        -- Promote/demote mob by name
        local mobHunterDemoteName = Lucene.containers.label({
            name = "mobHunterDemoteName"..i,
            x = "90%", y = 0,
            height = "100%", width = "5%"
        }, mobLineItem)
        mobHunterDemoteName:setStyleSheet(Lucene.styles.listLineItem)
        mobHunterDemoteName:setClickCallback("")

        if Lucene.hunter:isRegistered(v) and weight ~= Lucene.hunter.maxWeight then
            mobHunterDemoteName:echo("<center>↓")
            mobHunterDemoteName:setClickCallback("Lucene.hunter.adjustWeight", v:name(), weight + 1)
        end

        local mobHunterPromoteName = Lucene.containers.label({
            name = "mobHunterPromoteName"..i,
            x = "95%", y = 0,
            height = "100%", width = "5%"
        }, mobLineItem)
        mobHunterPromoteName:setStyleSheet(Lucene.styles.listLineItem)
        mobHunterPromoteName:setClickCallback("")

        if Lucene.hunter:isRegistered(v) and weight > 1 then
            mobHunterPromoteName:echo("<center>↑")
            mobHunterPromoteName:setClickCallback("Lucene.hunter.adjustWeight", v:name(), weight - 1)
        end

        table.insert(self.mobs, "mobItem"..i)

        i = i + 1
    end

    self.updating = false

    if self.shouldUpdate then
        self.shouldUpdate = false
        self:scheduleUpdate()
    end
end