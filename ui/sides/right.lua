Lucene.ui.sides.right = {}

Lucene.ui.sides.right.container = Lucene.containers.container({
    name = "rightContainer",
    x = "-"..px(Lucene.settings.border.right), y = "0px",
    width = px(Lucene.settings.border.right), height = "100%"
})

Lucene.ui.sides.right.label = Lucene.containers.label({
    name = "rightLabel",
    x = px(0), px(0),
    width = px(Lucene.settings.border.right), height = "100%"
}, Lucene.ui.sides.right.container)
Lucene.ui.sides.right.label:setStyleSheet(Lucene.styles.rightLabel)

Lucene.ui.sides.right.chatContainer = Lucene.containers.container({
    name="chatContainer",
    x = px(0), y = px(0),
    width = "100%", height = "50%"
}, Lucene.ui.sides.right.container)

Lucene.ui.sides.right.chatHeader = Lucene.containers.hbox({
    name = "chatHeader",
    x = 0, y = 0,
    width = "100%", height = "10%"
}, Lucene.ui.sides.right.chatContainer)

Lucene.ui.sides.right.chatFooter = Lucene.containers.label({
  name = "chatFooter",
  x = 0, y = "10%",
  width = "100%",
  height = "90%",
}, Lucene.ui.sides.right.chatContainer)

Lucene.ui.sides.right.chatFooter:setStyleSheet([[
    background-color: #050F2B;
]])

Lucene.ui.sides.right.mapContainer = Lucene.containers.container({
    name="mapContainer",
    x = px(0), y = "35%",
    width = px(Lucene.settings.border.right), height = "65%"
}, Lucene.ui.sides.right.container)

Lucene.ui.sides.right.mapHeader = Lucene.containers.hbox({
    name = "mapHeader",
    x = 0, y = 0,
    width = "100%", height = "7%"
}, Lucene.ui.sides.right.mapContainer)

Lucene.ui.sides.right.mapFooter = Lucene.containers.container({
  name = "mapFooter",
  x = 0, y = "7%",
  width = "100%",
  height = "93%",
}, Lucene.ui.sides.right.mapContainer)