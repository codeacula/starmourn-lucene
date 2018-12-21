Lucene.maps = {}

Lucene.maps.capturedSpace = false
Lucene.maps.capturingSpace = false
Lucene.maps.ignorePrompt = false
Lucene.maps.inSpace = false
Lucene.maps.skipLine = 0

Lucene.maps.activateMap = function(name)
    if name == "Space" then
        Lucene.maps.showSpace()
        Lucene.maps.inSpace = true
    else
        Lucene.maps.showMap()
        Lucene.maps.inSpace = false
    end
end

Lucene.maps.addTab = function(name)
    local newLabel = Lucene.containers.label({
        name = name.."MapLabel",
        fgColor = "#ffffff"
    }, Lucene.ui.sides.right.mapHeader)

    newLabel:echo("<center>"..name, nil, "10")

    newLabel:setStyleSheet(Lucene.styles.chatNormal)

    newLabel:setClickCallback("Lucene.maps.activateMap", name)
    return newLabel
end

Lucene.maps.showMap = function()
    Lucene.maps.mapTab:setStyleSheet(Lucene.styles.chatActive)
    Lucene.maps.spaceTab:setStyleSheet(Lucene.styles.chatNormal)
    Lucene.maps.spaceMapContainer:hide()
    Lucene.maps.mudletMapContainer:show()
    Lucene.maps.inSpace = false
end

Lucene.maps.init = function()
    Lucene.maps.mudletMapContainer = Lucene.containers.container({
        name = "mudletMapContainer",
        x = "0", y = "0",
        width = "100%", height = "100%"
    }, Lucene.ui.sides.right.mapFooter)
    
    Lucene.maps.mudletMap = Lucene.containers.mapper({
        name = "mudletMap",
        x = "0", y = "0%",
        width = "100%", height = "100%"
    }, Lucene.maps.mudletMapContainer)

    Lucene.maps.spaceMapContainer = Lucene.containers.container({
        name = "spaceMapContainer",
        x = "1%", y = "1%",
        width = "98%", height = "98%"
    }, Lucene.ui.sides.right.mapFooter)

    Lucene.maps.spaceMap = Lucene.containers.console({
        name = "spaceMap",
        x = "0%", y = "0%",
        height = "100%", width = "50%"
    }, Lucene.maps.spaceMapContainer)
    Lucene.maps.spaceMap:setColor("black")
    Lucene.maps.spaceMap:setFontSize(8)
    
    Lucene.maps.mapTab = Lucene.maps.addTab("Mudlet")
    Lucene.maps.mapTab:setStyleSheet(Lucene.styles.chatActive)
    
    Lucene.maps.spaceTab = Lucene.maps.addTab("Space")
    Lucene.maps.spaceTab:setStyleSheet(Lucene.styles.chatNormal)
    Lucene.maps.spaceMapContainer:hide()
end
registerAnonymousEventHandler("Lucene.bootstrap", "Lucene.maps.init")

Lucene.maps.showSpace = function()
    Lucene.maps.mapTab:setStyleSheet(Lucene.styles.chatNormal)
    Lucene.maps.spaceTab:setStyleSheet(Lucene.styles.chatActive)
    Lucene.maps.mudletMapContainer:hide()
    Lucene.maps.spaceMapContainer:show()
    Lucene.maps.inSpace = true
end