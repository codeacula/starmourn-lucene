local shipWindow = Lucene.objects.targetWindow:new()
shipWindow.lines ={}

local idwidth = "10%"
local nameWidth = "50%"

function shipWindow:build()
    self.shipButton = Lucene.containers.label({
        name = "shipButton"
    }, Lucene.targetWindow.headerBox)
    self.shipButton:echo("<center>S")
    self.shipButton:setStyleSheet([[
        QLabel {
            background: rgba(213, 56, 255, .4);
        }
        QLabel:hover {
            background: rgba(213, 56, 255, .6);
        }
    ]])
    self.shipButton:setClickCallback("Lucene.targetWindow.headerCallback", self.tabIndex)
    
    self.shipListContainer = Lucene.containers.container({
        name = "shipListContainer",
        x = 0, y = "10%",
        height = "90%", width = "100%"
    }, Lucene.targetWindow.listContainer)
    
    self.shipTitleHeader = Lucene.containers.label({
        name = "shipTitleHeader",
        x = 0, y = 0,
        height = px(Lucene.targetWindow.variables.lineHeight), width = nameWidth
    }, self.shipListContainer)
    self.shipTitleHeader:echo("Object")
    self.shipTitleHeader:setStyleSheet(Lucene.styles.listLineHeader)
    
    self.shipIdHeader = Lucene.containers.label({
        name = "shipIdHeader",
        x = nameWidth, y = 0,
        height = px(Lucene.targetWindow.variables.lineHeight), width = idwidth
    }, self.shipListContainer)
    self.shipIdHeader:echo("ID")
    self.shipIdHeader:setStyleSheet(Lucene.styles.listLineHeader)
end

function shipWindow:cleanupShipWindow()
    for _, item in ipairs(self.lines) do
        Lucene.containers.remove(item)
    end

    self.lines = {}
end

function shipWindow:hide()
    self.shipListContainer:hide()
end

function shipWindow:show()
    self.shipListContainer:show()
end

function shipWindow:update()
    i = 1

    self:cleanupShipWindow()
    
    for _, ship in ipairs(Lucene.spaceship.nearby) do
        local nearbyShipLine = Lucene.containers.container({
            name = "nearbyShipLine"..i,
            x = 0, y = px(Lucene.targetWindow.variables.lineHeight * i),
            height = px(Lucene.targetWindow.variables.lineHeight), width = "100%"
        }, self.shipListContainer)

        -- Ship Name
        local nearbyShipName = Lucene.containers.label({
            name = "nearbyShipName"..i,
            x = 0, y = 0,
            height = "100%", width = nameWidth
        }, nearbyShipLine)
        nearbyShipName:echo(("%s | %s"):format(ship.type, ship.display))
        nearbyShipName:setStyleSheet(Lucene.styles.listLineItem)
        nearbyShipName:setClickCallback("Lucene.spaceship.move", ship.distance, ship.direction)
        nearbyShipName:setDoubleClickCallback("")

        local nearbyShipId = Lucene.containers.label({
            name = "nearbyShipId"..i,
            x = nameWidth, y = 0,
            height = "100%", width = idwidth
        }, nearbyShipLine)
        nearbyShipId:setStyleSheet(Lucene.styles.listLineItem)
        nearbyShipId:setClickCallback("")
        nearbyShipId:setDoubleClickCallback("")

        if ship.id ~= 0 then
            nearbyShipId:echo(ship.id)
            nearbyShipId:setClickCallback("Lucene.spaceship.target", ship.id)
            nearbyShipId:setDoubleClickCallback("")
        end

        i = i + 1

        table.insert(self.lines, nearbyShipLine)
    end
end

Lucene.targetWindow:registerWindow(shipWindow)