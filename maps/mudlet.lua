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

Lucene.maps.mudletMap.updateMudletMap = function()
    centerview(gmcp.Room.Info.num)
end
registerAnonymousEventHandler("gmcp.Room.Info", "Lucene.maps.mudletMap.updateMudletMap")