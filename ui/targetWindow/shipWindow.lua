-- Ships
local shipLineTable = {}

local idwidth = "10%"
local nameWidth = "50%"

Lucene.targetWindow.shipButton = Lucene.containers.label({
    name = "shipButton"
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
Lucene.targetWindow.shipButton:setClickCallback("Lucene.targetWindow.setActiveWindow", "ships")

Lucene.targetWindow.shipListContainer = Lucene.containers.container({
    name = "shipListContainer",
    x = 0, y = "10%",
    height = "90%", width = "100%"
}, Lucene.targetWindow.listContainer)

local shipTitleHeader = Lucene.containers.label({
    name = "shipTitleHeader",
    x = 0, y = 0,
    height = px(Lucene.targetWindow.variables.lineHeight), width = nameWidth
}, Lucene.targetWindow.shipListContainer)
shipTitleHeader:echo("Object")
shipTitleHeader:setStyleSheet(Lucene.styles.listLineHeader)

local shipIdHeader = Lucene.containers.label({
    name = "shipIdHeader",
    x = nameWidth, y = 0,
    height = px(Lucene.targetWindow.variables.lineHeight), width = idwidth
}, Lucene.targetWindow.shipListContainer)
shipIdHeader:echo("ID")
shipIdHeader:setStyleSheet(Lucene.styles.listLineHeader)

function Lucene.targetWindow:cleanupShipWindow()
    for _, item in ipairs(shipLineTable) do
        Lucene.containers.remove(item)
    end

    shipLineTable = {}
end

function Lucene.targetWindow.updateNearbyShips()
    i = 1

    Lucene.targetWindow.cleanupShipWindow()
    
    for _, ship in ipairs(Lucene.spaceship.nearby) do
        local nearbyShipLine = Lucene.containers.container({
            name = "nearbyShipLine"..i,
            x = 0, y = px(Lucene.targetWindow.variables.lineHeight * i),
            height = px(Lucene.targetWindow.variables.lineHeight), width = "100%"
        }, Lucene.targetWindow.shipListContainer)

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

        table.insert(shipLineTable, nearbyShipLine)
    end

    Lucene.targetWindow.updating = false

    if Lucene.targetWindow.shouldUpdate then
        Lucene.targetWindow.shouldUpdate = false
        Lucene.targetWindow.scheduleUpdate()
    end
end