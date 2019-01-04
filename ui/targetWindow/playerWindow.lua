local playerWindow = Lucene.objects.targetWindow:new()
playerWindow.lines = {}

-- Players
function playerWindow:build()
    self.tabButton = Lucene.containers.label({
        name = "playerTargetButton"
    }, Lucene.targetWindow.headerBox)
    self.tabButton:echo("<center>P")
    self.tabButton:setStyleSheet([[
        QLabel {
            background: rgba(255, 204, 81, .4);
            border-top-right-radius: 10px;
        }
        QLabel:hover {
            background: rgba(255, 204, 81, .6);
        }
    ]])
    self.tabButton:setClickCallback("Lucene.targetWindow.headerCallback", self.tabIndex)
    
    self.container = Lucene.containers.container({
        name = "playerListContainer",
        x = 0, y = "10%",
        height = "90%", width = "100%"
    }, Lucene.targetWindow.listContainer)

    self.playerNameHeader = Lucene.containers.label({
        name = "playerNameHeader",
        x = 0, y = 0,
        height = Lucene.targetWindow.variables.lineHeight, width = "70%"
    }, self.container)
    self.playerNameHeader:echo("Name")
    self.playerNameHeader:setStyleSheet(Lucene.styles.listLineHeader)
    
    self.targetPlayerHeader = Lucene.containers.label({
        name = "targetPlayerHeader",
        x = "70%", y = 0,
        height = Lucene.targetWindow.variables.lineHeight, width = "5%"
    }, self.container)
    self.targetPlayerHeader:echo("<center>T")
    self.targetPlayerHeader:setStyleSheet(Lucene.styles.listLineHeader)
    
    self.enemyPlayerHeader = Lucene.containers.label({
        name = "enemyPlayerHeader",
        x = "75%", y = 0,
        height = Lucene.targetWindow.variables.lineHeight, width = "5%"
    }, self.container)
    self.enemyPlayerHeader:echo("<center>E")
    self.enemyPlayerHeader:setStyleSheet(Lucene.styles.listLineHeader)
    
    self.allyPlayerHeader = Lucene.containers.label({
        name = "allyPlayerHeader",
        x = "80%", y = 0,
        height = Lucene.targetWindow.variables.lineHeight, width = "5%"
    }, self.container)
    self.allyPlayerHeader:echo("<center>A")
    self.allyPlayerHeader:setStyleSheet(Lucene.styles.listLineHeader)
end

function playerWindow:clean()
    for _, v in ipairs(self.lines) do
        Lucene.containers.remove(v)
    end

    for i = 1, 100 do
        hideWindow("playerLine"..i)
    end

    self.lines = {}
end

function playerWindow:hide()
    self.container:hide()
end

function playerWindow:show()
    self.container:show()
end

function playerWindow:update()
    local i = 1
    
    self:clean()

    table.sort(Lucene.players.here)
    for _, v in ipairs(Lucene.players.here) do
        local lineItem = Lucene.containers.container({
            name = "playerLine"..i,
            x = 0, y = px(Lucene.targetWindow.variables.lineHeight * i),
            height = px(Lucene.targetWindow.variables.lineHeight), width = "100%"
        }, self.container)

        -- Player Name
        local playerNameItem = Lucene.containers.label({
            name = "playerNameItem"..i,
            x = 0, y = 0,
            height = "100%", width = "70%"
        }, lineItem)
        playerNameItem:setStyleSheet(Lucene.styles.listLineItem)
        playerNameItem:setClickCallback("send", "look "..v:name(), true)
        playerNameItem:setDoubleClickCallback("Lucene.targeting.setTarget", Lucene.targeting, v:name())
        playerNameItem:echo(v:name(), v:color())

        -- Target player
        local targetPlayer = Lucene.containers.label({
            name = "targetPlayer"..i,
            x = "70%", y = 0,
            height = "100%", width = "5%"
        }, lineItem)
        targetPlayer:setStyleSheet(Lucene.styles.listLineItem)
        targetPlayer:setClickCallback("Lucene.targeting.setTarget", Lucene.targeting, v:name())
        targetPlayer:echo("<center>T")

        -- Enemy player
        local enemyPlayer = Lucene.containers.label({
            name = "enemyPlayer"..i,
            x = "75%", y = 0,
            height = "100%", width = "5%"
        }, lineItem)
        enemyPlayer:setStyleSheet(Lucene.styles.listLineItem)
        enemyPlayer:echo("<center>E", "Enemy")

        if v:enemy() then
            enemyPlayer:setClickCallback("Lucene.players.unenemy", Lucene.players, v:name())
        else
            enemyPlayer:setClickCallback("Lucene.players.enemy", Lucene.players, v:name())
        end

        -- Ally player
        local allyPlayer = Lucene.containers.label({
            name = "allyPlayer"..i,
            x = "80%", y = 0,
            height = "100%", width = "5%"
        }, lineItem)
        allyPlayer:setStyleSheet(Lucene.styles.listLineItem)
        allyPlayer:echo("<center>A", "Ally")

        if v:ally() then
            allyPlayer:setClickCallback("Lucene.players.unally", Lucene.players, v:name())
        else
            allyPlayer:setClickCallback("Lucene.players.ally", Lucene.players, v:name())
        end

        table.insert(self.lines, "playerLine"..i)
        i = i + 1
    end
end

Lucene.targetWindow:registerWindow(playerWindow)