local mobWindow = Lucene.objects.targetWindow:new()
mobWindow.mobs = {}

function mobWindow:addTab()
    self.tabButton = Lucene.containers.label({
        name = "mobTargetsButton"
    }, self.headerBox)
    self.tabButton:echo("<center>M")
    self.tabButton:setStyleSheet([[
        QLabel {
            background: rgba(24, 204, 138, .4);
        }
        QLabel:hover {
            background: rgba(24, 204, 138, .6);
        }
    ]])
    self.tabButton:setClickCallback([[function()
        Lucene.targetWindow:setActiveWindow(self.subWindows["mob"]) 
    end]])
end

function mobWindow:build()
    self.container = Lucene.containers.container({
        name = "mobListContainer",
        x = 0, y = "10%",
        height = "90%", width = "100%"
    }, self.listContainer)
    
    self.mobNameHeader = Lucene.containers.label({
        name = "mobNameHeader",
        x = 0, y = 0,
        height = px(15), width = "80%"
    }, self.container)
    self.mobNameHeader:echo("Name")
    self.mobNameHeader:setStyleSheet(Lucene.styles.listLineHeader)
    
    self.mobProbeHeader = Lucene.containers.label({
        name = "mobProbeHeader",
        x = "80%", y = 0,
        height = px(15), width = "5%"
    }, self.container)
    self.mobProbeHeader:echo("<center>P")
    self.mobProbeHeader:setStyleSheet(Lucene.styles.listLineHeader)
    
    self.mobHunterAdd = Lucene.containers.label({
        name = "mobHunterAdd",
        x = "85%", y = 0,
        height = px(15), width = "5%"
    }, self.container)
    self.mobHunterAdd:echo("<center>+")
    self.mobHunterAdd:setStyleSheet(Lucene.styles.listLineHeader)
    
    self.mobWeightNameHeader = Lucene.containers.label({
        name = "mobWeightNameHeader",
        x = "90%", y = 0,
        height = px(15), width = "10%"
    }, self.container)
    self.mobWeightNameHeader:echo("<center>Hunt")
    self.mobWeightNameHeader:setStyleSheet(Lucene.styles.listLineHeader)
end

function mobWindow:cleanupMobWindow()
    for _, v in ipairs(self.mobs) do
        Lucene.containers.remove(v)
    end

    self.mobs = {}
end

function mobWindow:reset()
    for i = 1, 100 do
        hideWindow("mobItem"..i)
    end
end

function mobWindow:update()
    local i = 1
    
    self:cleanupMobWindow()

    table.sort(Lucene.room.mobs)

    for _, v in ipairs(Lucene.room.mobs) do
        local weight = v:weight()

        local mobLineItem = Lucene.containers.container({
            name = "mobItem"..i,
            x = 0, y = px(self.variables.lineHeight * i),
            height = px(self.variables.lineHeight), width = "100%"
        }, self.subWindows["mob"])

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
end

Lucene.targetWindow.subWindows["mob"] = mobWindow