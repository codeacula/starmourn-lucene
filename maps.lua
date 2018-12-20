Lucene.maps = {}

Lucene.maps.mudletMapContainer = Lucene.containers.container({
    name = "mudletMapContainer",
    x = "0", y = "0%",
    width = "100%", height = "100%"
}, Lucene.ui.sides.right.mapFooter)

Lucene.maps.mudletMap = Lucene.containers.mapper({
    name = "mudletMap",
    x = "0", y = "0%",
    width = "100%", height = "100%"
}, Lucene.maps.mudletMapContainer)

Lucene.maps.capturedSpace = false
Lucene.maps.capturingSpace = false
Lucene.maps.ignorePrompt = false
Lucene.maps.inSpace = false
Lucene.maps.skipLine = 0

Lucene.maps.spaceMap = Lucene.containers.console({
    name = "spaceMap",
    x = "1%", y = "1%",
    height = "98%", width = "98%"
}, Lucene.ui.sides.right.mapFooter)
Lucene.maps.spaceMap:setColor("black")
Lucene.maps.spaceMap:setFontSize(11)

function Lucene.maps.activateMap(name)
    if name == "Space" then
        Lucene.maps.showSpace()
        Lucene.maps.inSpace = true
    else
        Lucene.maps.showMap()
        Lucene.maps.inSpace = false
    end
end

function Lucene.maps.addTab(name)
    local newLabel = Lucene.containers.label({
        name = name.."MapLabel",
        fgColor = "#ffffff"
    }, Lucene.ui.sides.right.mapHeader)

    newLabel:echo("<center>"..name, nil, "10")

    newLabel:setStyleSheet(Lucene.styles.chatNormal)

    newLabel:setClickCallback("Lucene.maps.activateMap", name)
    return newLabel
end

function Lucene.maps.showMap()
    Lucene.maps.mapTab:setStyleSheet(Lucene.styles.chatActive)
    Lucene.maps.spaceTab:setStyleSheet(Lucene.styles.chatNormal)
    Lucene.maps.spaceMap:hide()
    Lucene.maps.mudletMapContainer:show()
    Lucene.maps.inSpace = false
end

function Lucene.maps.showSpace()
    Lucene.maps.mapTab:setStyleSheet(Lucene.styles.chatNormal)
    Lucene.maps.spaceTab:setStyleSheet(Lucene.styles.chatActive)
    Lucene.maps.mudletMapContainer:hide()
    Lucene.maps.spaceMap:show()
    Lucene.maps.inSpace = true
end

Lucene.maps.mapTab = Lucene.maps.addTab("Mudlet")
Lucene.maps.mapTab:setStyleSheet(Lucene.styles.chatActive)
Lucene.maps.spaceTab = Lucene.maps.addTab("Space")
Lucene.maps.spaceTab:setStyleSheet(Lucene.styles.chatNormal)
Lucene.maps.spaceMap:hide()