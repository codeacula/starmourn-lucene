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

    newLabel:echo("<center>"..name, nil, "9")

    newLabel:setStyleSheet(Lucene.styles.chatNormal)

    newLabel:setClickCallback("Lucene.maps.activateMap", name)
    return newLabel
end

Lucene.maps.showMap = function()
    Lucene.maps.mapTab:setStyleSheet(Lucene.styles.chatActive)
    Lucene.maps.space.tab:setStyleSheet(Lucene.styles.chatNormal)
    Lucene.maps.space.mapContainer:hide()
    Lucene.maps.mudletMapContainer:show()
    Lucene.maps.inSpace = false
end

Lucene.maps.init = function()
    Lucene.import("maps/mudlet")
    Lucene.import("maps/space")
end
Lucene.callbacks.register("Lucene.bootstrap", Lucene.maps.init)

Lucene.maps.showSpace = function()
    Lucene.maps.mapTab:setStyleSheet(Lucene.styles.chatNormal)
    Lucene.maps.space.tab:setStyleSheet(Lucene.styles.chatActive)
    Lucene.maps.mudletMapContainer:hide()
    Lucene.maps.space.mapContainer:show()
    Lucene.maps.inSpace = true
end