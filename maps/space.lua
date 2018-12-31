local createButton = function(name, text, callback, parent)
    newButton = Lucene.containers.label({
        name = name,
        fgColor = "#ffffff"
    }, parent)
    
    newButton:echo("<center>"..text, nil, "10")
    newButton:setClickCallback(callback)
    newButton:setStyleSheet(Lucene.styles.mapControlButton)

    return newButton
end

Lucene.maps.space = {}
Lucene.maps.space.mapContainer = Lucene.containers.container({
    name = "spaceMapContainer",
    x = "0%", y = "0%",
    width = "100%", height = "100%"
}, Lucene.ui.sides.right.mapFooter)

Lucene.maps.space.map = Lucene.containers.console({
    name = "spaceMap",
    x = "0%", y = "0%",
    height = "100%", width = "50%"
}, Lucene.maps.space.mapContainer)
Lucene.maps.space.map:setColor("black")
Lucene.maps.space.map:setFontSize(8)

Lucene.maps.mapTab = Lucene.maps.addTab("Mudlet")
Lucene.maps.mapTab:setStyleSheet(Lucene.styles.chatActive)

Lucene.maps.space.tab = Lucene.maps.addTab("Space")
Lucene.maps.space.tab:setStyleSheet(Lucene.styles.chatNormal)

Lucene.maps.space.firstButtonRow = Lucene.containers.container({
    name = "firstButtonRow",
    x = "50%", y = px(0),
    height = "33%", width = "50%"
}, Lucene.maps.space.mapContainer)

-- First row buttons
Lucene.maps.space.row1 = Lucene.containers.hbox({
    name = "spaceRow1",
    x = 0, y = 0,
    width = "100%", height = "33%"
}, Lucene.maps.space.firstButtonRow)

Lucene.maps.space.shipBeaconButton = createButton("shipBeaconButton", "Beacon (B)", "", Lucene.maps.space.row1)
Lucene.maps.space.shipBeaconButton:setClickCallback("send", "SHIP BEACON", true)
Lucene.maps.space.shipConeButton = createButton("shipConeButton", "Cone (C)", "", Lucene.maps.space.row1)
Lucene.maps.space.shipConeButton:setClickCallback("send", "SHIP CONE", true)

Lucene.maps.space.mapContainer:hide()

function Lucene.maps.space.docking()
    Lucene.say("We have left space.")
    Lucene.maps.showMap()
end
Lucene.callbacks.register("Lucene.docked", Lucene.maps.space.docking)

function Lucene.maps.space.switchToSpace()
    Lucene.say("Entering space.")
    Lucene.maps.showSpace()
end
Lucene.callbacks.register("Lucene.enteredSpace", Lucene.maps.space.switchToSpace)